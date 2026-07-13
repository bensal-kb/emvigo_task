import 'package:emvigo_test/core/base/base_bloc/base_bloc.dart';
import 'package:emvigo_test/core/utils/validators.dart';
import 'package:emvigo_test/data/repo/auth_repo.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepo _authRepo;

  LoginCubit(this._authRepo) : super(const LoginState());

  void emailChanged(String value) => emit(state.copyWith(email: value, status: Status.initial));

  void passwordChanged(String value) => emit(state.copyWith(password: value, status: Status.initial));

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

    final result = await _authRepo.signIn(email: state.email, password: state.password);

    if (result.isSuccess) {
      emit(state.copyWith(status: Status.success));
    } else {
      emit(state.copyWith(status: Status.error, error: result.error));
    }
  }
}
