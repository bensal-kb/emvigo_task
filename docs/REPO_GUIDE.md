# Writing Repos and Use Cases

---

## Repository Pattern

Every data domain gets two files:
- `data/repo/<name>_repo.dart` — abstract interface
- `data/repo_impl/<name>_repo_impl.dart` — concrete implementation

This separation means cubits depend on the interface, not the HTTP implementation. It makes the code testable (mock the interface) and swappable.

---

## 1. Define the interface

`lib/data/repo/product_repo.dart`:

```dart
import 'package:flutter_template/core/network/utils/response.dart';
import 'package:flutter_template/data/models/res/product/product_model.dart';

abstract class ProductRepo {
  Future<Response<ProductModel>> getProduct(String id);
  Future<Response<List<ProductModel>>> getProducts({int page = 1});
}
```

Rules:
- Every method returns `Future<Response<T>>` — never raw types or exceptions.
- No implementation details — just the contract.
- One interface per domain (product, cart, order, auth, etc.).

---

## 2. Write the implementation

`lib/data/repo_impl/product_repo_impl.dart`:

```dart
import 'package:flutter_template/core/network/app_services.dart';
import 'package:flutter_template/core/network/utils/response.dart';
import 'package:flutter_template/data/models/res/product/product_model.dart';
import 'package:flutter_template/data/repo/product_repo.dart';

class ProductRepoImpl implements ProductRepo {
  final AppServices _services;

  ProductRepoImpl(this._services);

  @override
  Future<Response<ProductModel>> getProduct(String id) {
    return _services.get(
      '/products/$id',
      fromJson: (json) => ProductModel.fromJson(json['data']),
    );
  }

  @override
  Future<Response<List<ProductModel>>> getProducts({int page = 1}) {
    return _services.get(
      '/products',
      queryParameters: {'page': page},
      fromJson: (json) => (json['data'] as List)
          .map((e) => ProductModel.fromJson(e))
          .toList(),
    );
  }
}
```

Rules:
- Inject `AppServices` via the constructor.
- Use `_services.get/post/put/delete` — they already handle Dio errors and wrap the result in `Response`.
- Never call `Dio` directly in a repo impl.
- Never hold state in a repo.

---

## 3. Register in DI

`lib/dependencies/dependencies.dart`:

```dart
sl.registerLazySingleton<ProductRepo>(() => ProductRepoImpl(sl()));
```

Always use `registerLazySingleton` for repos.

---

## 4. Write the model

`lib/data/models/res/product/product_model.dart`:

```dart
class ProductModel {
  final String id;
  final String name;
  final double price;

  const ProductModel({
    required this.id,
    required this.name,
    required this.price,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'] ?? json['id'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
  };
}
```

Rules:
- Plain Dart — no Flutter imports, no business logic.
- Use `factory fromJson` for deserialization.
- Put request body models in `data/models/req/`.
- Put response models in `data/models/res/<domain>/`.
- Put shared domain entities in `data/models/entities/`.

---

## 5. Use Cases (optional)

Add a use case when the logic between cubit and repo is non-trivial.

`lib/data/repo/usecases/get_product_usecase.dart`:

```dart
import 'package:flutter_template/core/base/usecases/usecase.dart';
import 'package:flutter_template/data/models/res/product/product_model.dart';
import 'package:flutter_template/data/repo/product_repo.dart';

class GetProductUseCase extends UseCase<ProductModel, String> {
  final ProductRepo _repo;

  GetProductUseCase(this._repo);

  @override
  Future<Response<ProductModel>> call(String productId) {
    return _repo.getProduct(productId);
  }
}
```

Use it in the cubit:

```dart
class ProductDetailCubit extends Cubit<ProductDetailState> {
  final GetProductUseCase _getProduct;

  ProductDetailCubit(this._getProduct) : super(const ProductDetailState());

  Future<void> load(String id) async {
    emit(state.copyWith(status: Status.loading));
    final result = await _getProduct(id);
    if (result.isSuccess) {
      emit(state.copyWith(status: Status.success, product: result.data));
    } else {
      emit(state.copyWith(status: Status.error, error: result.error));
    }
  }
}
```

**When to skip the use case:** for straightforward get/list/create/delete operations with no extra logic, calling the repo directly from the cubit is simpler and fine.
