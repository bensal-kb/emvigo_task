part of 'signup_cubit.dart';

class SignupState extends BaseState {
  const SignupState({
    super.state = Status.initial,
    super.error,
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
  });

  final String email;
  final String password;
  final String confirmPassword;

  @override
  List<Object?> get props => [state, error, email, password, confirmPassword];

  SignupState copyWith({
    Status? status,
    Error? error,
    String? email,
    String? password,
    String? confirmPassword,
  }) {
    return SignupState(
      state: status ?? state,
      error: error,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
    );
  }
}
