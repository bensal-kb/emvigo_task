import 'package:emvigo_test/core/network/utils/exceptions.dart';

class Response<T> {
  final T? data;
  final Error? error;
  final bool isSuccess;

  const Response.success(this.data)
      : error = null,
        isSuccess = true;

  const Response.failure(this.error)
      : data = null,
        isSuccess = false;

  void fold({
    required void Function(T data) onSuccess,
    required void Function(Error error) onError,
  }) {
    if (isSuccess) {
      onSuccess(data as T);
    } else {
      onError(error!);
    }
  }
}
