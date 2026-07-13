import 'package:equatable/equatable.dart';
import 'package:emvigo_test/core/network/utils/exceptions.dart';

export 'package:emvigo_test/core/network/utils/exceptions.dart';

enum Status { initial, loading, success, error }

abstract class BaseState extends Equatable {
  const BaseState({this.state, this.error});

  final Status? state;
  final Error? error;

  @override
  List<Object?> get props => [state];

  bool get isInitial => state == Status.initial;
  bool get isLoading => state == Status.loading;
  bool get isSuccess => state == Status.success;
  bool get isError => state == Status.error;

  T cast<T>() => this as T;
  T? tryCast<T>() => this is T ? this as T : null;
}

class InitialState extends BaseState {
  const InitialState() : super(state: Status.initial);
}

class LoadingState extends BaseState {
  const LoadingState() : super(state: Status.loading);
}

class SuccessState extends BaseState {
  const SuccessState() : super(state: Status.success);
}

class ErrorState extends BaseState {
  const ErrorState({required Error error}) : super(state: Status.error, error: error);
}
