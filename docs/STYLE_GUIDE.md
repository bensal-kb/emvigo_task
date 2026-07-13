# Style Guide

Naming and formatting conventions for this project.

---

## Naming

| Thing | Convention | Example |
|---|---|---|
| Files | `snake_case` | `product_detail_cubit.dart` |
| Folders | `snake_case` | `product_detail/` |
| Classes | `PascalCase` | `ProductDetailCubit` |
| Variables / methods | `camelCase` | `loadProduct()`, `productId` |
| Constants | `camelCase` in a class | `AppColors.primary` |
| Private members | `_camelCase` | `_repo`, `_loadData()` |
| Route strings | `camelCase` field, `kebab-case` path | `Routes.productDetail = '/product/:id'` |

### Suffixes to always use

| Type | Suffix | Example |
|---|---|---|
| Page widget | `Page` | `ProductDetailPage` |
| Cubit | `Cubit` | `ProductDetailCubit` |
| State | `State` | `ProductDetailState` |
| Repo interface | `Repo` | `ProductRepo` |
| Repo implementation | `RepoImpl` | `ProductRepoImpl` |
| Use case | `UseCase` | `GetProductUseCase` |
| Model (response) | `Model` | `ProductModel` |
| Model (request) | `Req` | `AddToCartReq` |

---

## File Organization

Within a file, order members as:
1. Fields (final first, then non-final)
2. Constructor
3. Factory constructors / `fromJson`
4. Public methods
5. Private methods
6. `build` (for widgets)

---

## Do / Don't

| Do | Don't |
|---|---|
| `BasePage(appBar: ..., child: ...)` | `Scaffold(appBar: ..., body: ...)` |
| `StateWidget<MyCubit>(builder: ...)` | Repeat loading/error boilerplate in every BlocBuilder |
| `context.theme.primary` | `Colors.blue` or any hardcoded color |
| `context.theme.light` | `Colors.white` |
| `context.router.push(...)` | `Navigator.of(context).push(...)` |
| `context.removeFocus()` | `FocusScope.of(context).unfocus()` |
| `emit(const LoadingState())` | `emit(state.copyWith(status: Status.loading))` when using Pattern A |
| `emit(ErrorState(error: result.error!))` | Silently ignoring error branches |

---

## Widget Rules

- Keep `build` methods short. Extract complex subtrees into private widget classes.
- Prefer `const` constructors wherever possible.
- Never put business logic in a widget — move it to the cubit.
- Use named parameters for widgets with more than two arguments.

```dart
// Preferred
ProductCard(
  title: product.name,
  price: product.price,
  onTap: () => context.push('/product/${product.id}'),
)

// Avoid
ProductCard(product.name, product.price, () => ...)
```

---

## State Emission

For Pattern B (BaseState + copyWith), always use `copyWith`:

```dart
// Correct — preserves all other state fields
emit(state.copyWith(status: Status.loading));

// Avoid — wipes filter, pagination, and any other field
emit(ProductDetailState(state: Status.loading));
```

For Pattern A (extends SuccessState), always emit the concrete base states:

```dart
// Correct
emit(const LoadingState());
emit(ErrorState(error: result.error!));
emit(ProductDetailState(product: result.data!));

// Avoid — don't mix patterns
emit(state.copyWith(...)); // state is BaseState — no copyWith
```

---

## Imports

Order imports as:
1. `dart:` packages
2. `package:flutter/...`
3. Third-party packages
4. Local imports (`package:flutter_template/...`)

Use the package import style (`package:flutter_template/...`) everywhere — never relative imports except within the same folder.

---

## Comments

Write comments only when the **why** is non-obvious. Do not comment what the code does — well-named identifiers already do that.

```dart
// Correct — explains a non-obvious constraint
// PhonePe SDK requires the amount in paise (integer), not rupees
final amountInPaise = (price * 100).toInt();

// Avoid — just restates the code
// Multiply price by 100
final amountInPaise = (price * 100).toInt();
```

---

## Assets

| Type | Folder |
|---|---|
| PNG / JPG images | `assets/images/` |
| SVG icons | `assets/svg/` |
| Lottie animations | `assets/lottie/` |
| App icon source | `assets/icons/` |

Access assets via a constants class to avoid typos:

```dart
class Assets {
  Assets._();
  static const logo = 'assets/images/logo.png';
  static const successAnimation = 'assets/lottie/done.json';
}
```
