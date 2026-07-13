part of 'login_cubit.dart';

class LoginState extends BaseState {
  const LoginState({
    super.state = Status.initial,
    super.error,
    this.email = '',
    this.password = '',
  });

  final String email;
  final String password;

  @override
  List<Object?> get props => [state, error, email, password];

  LoginState copyWith({
    Status? status,
    Error? error,
    String? email,
    String? password,
  }) {
    return LoginState(
      state: status ?? state,
      error: error,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}
