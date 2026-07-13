import 'package:emvigo_test/core/base/base_bloc/base_bloc.dart';
import 'package:emvigo_test/data/repo/auth_repo.dart';

class HomeCubit extends Cubit<BaseState> {
  final AuthRepo _authRepo;

  HomeCubit(this._authRepo) : super(const InitialState());

  Future<void> logout() async {
    emit(const LoadingState());

    final result = await _authRepo.signOut();

    if (result.isSuccess) {
      await prefs.setGuestUser(false);
      emit(const SuccessState());
    } else {
      emit(ErrorState(error: result.error!));
    }
  }
}
