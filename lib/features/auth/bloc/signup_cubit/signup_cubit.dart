import 'package:emvigo_test/core/base/base_bloc/base_bloc.dart';
import 'package:emvigo_test/core/utils/validators.dart';
import 'package:emvigo_test/data/repo/auth_repo.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthRepo _authRepo;

  SignupCubit(this._authRepo) : super(const SignupState());

  void emailChanged(String value) => emit(state.copyWith(email: value));

  void passwordChanged(String value) => emit(state.copyWith(password: value));

  void confirmPasswordChanged(String value) =>
      emit(state.copyWith(confirmPassword: value));

  Future<void> submit() async {
    final error =
        Validators.email(state.email) ??
        Validators.password(state.password) ??
        Validators.confirmPassword(state.confirmPassword, state.password);

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

    final result = await _authRepo.signUp(email: state.email, password: state.password);

    if (result.isSuccess) {
      emit(state.copyWith(status: Status.success));
    } else {
      emit(state.copyWith(status: Status.error, error: result.error));
    }
  }
}
