# Adding a New Feature

Follow these steps every time you add a new screen or feature to the app.

---

## 1. Create the folder structure

Every feature lives under `lib/features/<feature_name>/` with three sub-folders:

```
lib/features/product_detail/
├── bloc/
│   └── product_detail_cubit/
│       ├── product_detail_cubit.dart
│       └── product_detail_state.dart
├── view/
│   └── product_detail_page.dart
└── widgets/
    └── product_info_section.dart   ← widgets only this feature uses
```

Naming rules:
- Folder name: `snake_case` (e.g. `product_detail`)
- Page class: `PascalCase` + `Page` suffix (e.g. `ProductDetailPage`)
- Cubit class: `PascalCase` + `Cubit` suffix (e.g. `ProductDetailCubit`)
- State class: `PascalCase` + `State` suffix (e.g. `ProductDetailState`)

---

## 2. Write the state

There are two patterns. Pick based on the complexity of your screen.

### Pattern A — State extends `SuccessState` (preferred for simple screens)

The cubit emits generic `LoadingState()` / `ErrorState()` for those phases, and a custom state that extends `SuccessState` for the data:

`bloc/product_detail_cubit/product_detail_state.dart`:

```dart
part of 'product_detail_cubit.dart';

class ProductDetailState extends SuccessState {
  final ProductModel product;

  const ProductDetailState({required this.product});

  @override
  List<Object?> get props => [product];
}
```

This is the lightest option — no `copyWith` needed because loading and error use the built-in base states.

### Pattern B — State extends `BaseState` with `copyWith` (for stateful screens)

Use when the page holds incremental state (e.g. form fields, pagination, filters):

```dart
class ProductDetailState extends BaseState {
  final ProductModel? product;

  const ProductDetailState({super.state, super.error, this.product});

  @override
  List<Object?> get props => [state, error, product];

  ProductDetailState copyWith({
    Status? status,
    Error? error,
    ProductModel? product,
  }) {
    return ProductDetailState(
      state: status ?? this.state,
      error: error ?? this.error,
      product: product ?? this.product,
    );
  }
}
```

---

## 3. Write the cubit

### With Pattern A state:

`bloc/product_detail_cubit/product_detail_cubit.dart`:

```dart
import 'package:flutter_template/core/base/base_bloc/base_bloc.dart';
import 'package:flutter_template/data/repo/product_repo.dart';

part 'product_detail_state.dart';

class ProductDetailCubit extends Cubit<BaseState> {
  final ProductRepo _repo;
  final String productId;

  ProductDetailCubit(this._repo, {required this.productId})
      : super(const InitialState());

  Future<void> load() async {
    emit(const LoadingState());

    final result = await _repo.getProduct(productId);

    if (result.isSuccess) {
      emit(ProductDetailState(product: result.data!));
    } else {
      emit(ErrorState(error: result.error!));
    }
  }
}
```

Rules:
- Inject repos via the constructor — never call `sl<>()` inside a cubit.
- Always emit `LoadingState()` before async work.
- Always handle both success and failure.

---

## 4. Write the page

Split every screen into two widgets: a **Page** (provides the cubit) and a **View** (consumes it).

### Pattern A — `StateWidget` (recommended for most screens)

```dart
import 'package:flutter_template/core/base/base_ui/base_page.dart';
import 'package:flutter_template/core/base/base_ui/state_widget.dart';
import 'package:flutter_template/core/base/base_ui/base_ui.dart';
import 'package:flutter_template/dependencies/get_dependencies.dart';
import '../bloc/product_detail_cubit/product_detail_cubit.dart';
import '../bloc/product_detail_cubit/product_detail_state.dart';

// Page: owns the BlocProvider
class ProductDetailPage extends StatelessWidget {
  final String productId;

  const ProductDetailPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductDetailCubit(sl(), productId: productId)..load(),
      child: const _ProductDetailView(),
    );
  }
}

// View: consumes the cubit — never creates it
class _ProductDetailView extends StatelessWidget {
  const _ProductDetailView();

  @override
  Widget build(BuildContext context) {
    return BasePage(
      appBar: AppBar(title: const Text('Product')),
      onRefresh: () async => context.read<ProductDetailCubit>().load(),
      child: StateWidget<ProductDetailCubit>(
        retry: () => context.read<ProductDetailCubit>().load(),
        builder: (context, state) {
          final product = state.cast<ProductDetailState>().product;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Text(product.name),
          );
        },
      ),
    );
  }
}
```

`StateWidget` automatically shows a spinner while loading and an error widget on failure. You only write the success UI.

### Pattern B — Manual `BlocBuilder` (for complex multi-stream screens)

Use when the page has multiple independent cubits:

```dart
class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return BasePage(
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthCubit, BaseState>(
            listener: (context, state) {
              if (state.isError) showToast(state.error!.message!);
            },
          ),
        ],
        child: BlocBuilder<HomeCubit, BaseState>(
          builder: (context, state) {
            if (state.isLoading) return const DefaultLoadingWidget(state: state);
            if (state.isError) return DefaultErrorWidget(state: state, retry: () => context.read<HomeCubit>().load());
            return const _HomeContent();
          },
        ),
      ),
    );
  }
}
```

### Decision table

| Situation | Pattern |
|---|---|
| Single cubit drives the whole page | `StateWidget` (Pattern A) |
| Multiple independent cubits on one page | Manual `BlocBuilder` (Pattern B) |
| Side effects only (toast, navigation) | `BlocListener` |
| Both UI rebuild + side effect | `BlocConsumer` |

---

## 5. Register the route

Add the route constant in `lib/core/router/app_routes.dart`:

```dart
static const productDetail = '/product/:id';
```

Add the `GoRoute` in `lib/core/router/app_router.dart`:

```dart
GoRoute(
  path: Routes.productDetail,
  builder: (context, state) => ProductDetailPage(
    productId: state.pathParameters['id']!,
  ),
),
```

Navigate from anywhere:

```dart
context.push('/product/${product.id}');
```

---

## 6. Register the repo (if new)

Add it in `lib/dependencies/dependencies.dart`:

```dart
sl.registerLazySingleton<ProductRepo>(() => ProductRepoImpl(sl()));
```

See `docs/REPO_GUIDE.md` for writing the repo.

---

## Checklist

- [ ] Folder structure: `bloc/`, `view/`, `widgets/`
- [ ] State extends `SuccessState` or `BaseState` (with `copyWith` + `props`)
- [ ] Cubit injects repos via constructor, emits `LoadingState` before async calls
- [ ] Page widget owns `BlocProvider`, View widget consumes it
- [ ] View uses `BasePage` (never raw `Scaffold`)
- [ ] View uses `StateWidget` or `BlocBuilder` — not both inconsistently
- [ ] Route added to `app_routes.dart` and `app_router.dart`
- [ ] Repo registered in `dependencies.dart` (if new)
