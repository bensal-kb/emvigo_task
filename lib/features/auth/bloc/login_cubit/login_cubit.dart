import 'package:emvigo_test/core/base/base_bloc/base_bloc.dart';
import 'package:emvigo_test/core/utils/validators.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState());

  void emailChanged(String value) => emit(state.copyWith(email: value));

  void passwordChanged(String value) => emit(state.copyWith(password: value));

  Future<void> submit() async {
    final error =
        Validators.email(state.email) ??
        Validators.password(state.password, minLength: 1);

    if (error != null) {
      emit(
        state.copyWith(
          status: Status.error,
          error: InvalidError(message: error),
        ),
      );
      return;
    }

    emit(state.copyWith(status: Status.loading));

    await Future.delayed(const Duration(milliseconds: 600));
    await prefs.setAuthToken('dummy-token');

    emit(state.copyWith(status: Status.success));
  }
}
