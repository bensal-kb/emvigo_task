# Writing Cubits and States

---

## Two state patterns

### Pattern A — Custom state extends `SuccessState` (preferred)

The cubit type is `Cubit<BaseState>`. It emits the built-in `LoadingState` and `ErrorState`, and a custom class extending `SuccessState` for the data:

```dart
// state file (usually a `part of` the cubit file)
class ItemsState extends SuccessState {
  final List<String> items;

  const ItemsState({required this.items});

  @override
  List<Object?> get props => [items];
}

// cubit file
class ItemsCubit extends Cubit<BaseState> {
  final ItemsRepo _repo;

  ItemsCubit(this._repo) : super(const InitialState());

  Future<void> load() async {
    emit(const LoadingState());
    final result = await _repo.getItems();
    if (result.isSuccess) {
      emit(ItemsState(items: result.data!));
    } else {
      emit(ErrorState(error: result.error!));
    }
  }
}
```

Best for: simple fetch-and-display screens with no incremental state.

---

### Pattern B — Custom state extends `BaseState` with `copyWith`

Use when the screen accumulates state over time (forms, filters, pagination):

```dart
class ItemsState extends BaseState {
  final List<String> items;
  final String? filter;

  const ItemsState({super.state, super.error, this.items = const [], this.filter});

  @override
  List<Object?> get props => [state, error, items, filter];

  ItemsState copyWith({
    Status? status,
    Error? error,
    List<String>? items,
    String? filter,
  }) {
    return ItemsState(
      state: status ?? this.state,
      error: error ?? this.error,
      items: items ?? this.items,
      filter: filter ?? this.filter,
    );
  }
}

class ItemsCubit extends Cubit<ItemsState> {
  final ItemsRepo _repo;

  ItemsCubit(this._repo) : super(const ItemsState());

  Future<void> load() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repo.getItems(filter: state.filter);
    if (result.isSuccess) {
      emit(state.copyWith(status: Status.success, items: result.data!));
    } else {
      emit(state.copyWith(status: Status.error, error: result.error));
    }
  }

  void setFilter(String filter) {
    emit(state.copyWith(filter: filter));
    load();
  }
}
```

---

## `BaseState` helpers

Available on any state:

```dart
state.isInitial   // true when Status.initial
state.isLoading   // true when Status.loading
state.isSuccess   // true when Status.success
state.isError     // true when Status.error
state.error       // Error? — has .message and .exception
state.cast<T>()   // cast to a concrete state type (throws if wrong type)
state.tryCast<T>() // safe cast — returns null if wrong type
```

Access the concrete state inside a builder:

```dart
// Pattern A — cast from BaseState
final data = state.cast<ItemsState>().items;

// Pattern B — direct (cubit type is already ItemsState)
final data = state.items;
```

---

## Cubit rules

- Always emit `LoadingState()` (or `state.copyWith(status: Status.loading)`) before any async call.
- Always handle both success and failure from the repo — never leave the error branch empty.
- Never call `sl<>()` inside a cubit. Inject all dependencies via the constructor.
- Never put navigation or toast logic inside a cubit. Use `BlocListener` in the UI instead.
- Never import `package:flutter/material.dart` in a cubit.

---

## Cubit vs Bloc (with events)

Use **Cubit** for almost everything — it's simpler and has less boilerplate.

Use a full **Bloc** (with `BaseEvent`) only when you need `bloc_concurrency` to control how events overlap:

```dart
// Example: debounce search input, drop rapid taps
class SearchBloc extends Bloc<SearchEvent, BaseState> {
  SearchBloc(this._repo) : super(const InitialState()) {
    on<SearchQueryChanged>(
      _onQueryChanged,
      transformer: debounce(const Duration(milliseconds: 300)),
    );
  }
}
```

Base events available in `lib/core/base/base_bloc/base_events.dart`:
- `LoadDataEvent`
- `RefreshDataEvent`
- `RetryEvent`

---

## Reacting to state in the UI

**`StateWidget`** — the default. Handles loading/error/success automatically. See `FEATURE_GUIDE.md`.

**`BlocBuilder`** — for manual control:

```dart
BlocBuilder<ItemsCubit, BaseState>(
  builder: (context, state) {
    if (state.isLoading) return DefaultLoadingWidget(state: state);
    if (state.isError) return DefaultErrorWidget(state: state, retry: context.read<ItemsCubit>().load);
    return ListView(children: state.cast<ItemsState>().items.map(Text.new).toList());
  },
)
```

**`BlocListener`** — side effects only (navigation, toasts, dialogs):

```dart
BlocListener<ItemsCubit, BaseState>(
  listener: (context, state) {
    if (state.isSuccess) context.go(Routes.home);
    if (state.isError) showToast(state.error!.message!);
  },
  child: const _ItemsView(),
)
```

**`BlocConsumer`** — when you need both a rebuild and a side effect:

```dart
BlocConsumer<ItemsCubit, BaseState>(
  listener: (context, state) {
    if (state.isError) showToast(state.error!.message!);
  },
  builder: (context, state) {
    if (state.isLoading) return DefaultLoadingWidget(state: state);
    return const _ItemsView();
  },
)
```

---

## Global vs local cubits

| Type | Where to create | Lifetime |
|---|---|---|
| **Local** | Inside `BlocProvider` in the Page widget | Disposed when the page is popped |
| **Global** | Registered in `dependencies.dart`, provided at App level | Entire app session |

Only make a cubit global when its state must survive across unrelated screens (e.g. cart badge count, auth session, user gender preference). Everything else is local.
