import 'package:emvigo_test/core/network/utils/response.dart';
export 'package:emvigo_test/core/network/utils/response.dart';

abstract class UseCase<T, Params> {
  Future<Response<T>> call(Params params);
}

class NoParams {}
