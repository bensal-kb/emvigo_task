import 'package:emvigo_test/core/base/base_bloc/base_bloc.dart';
import 'package:emvigo_test/data/models/entities/profile_model.dart';
import 'package:emvigo_test/data/repo/auth_repo.dart';
import 'package:emvigo_test/data/repo/profile_repo.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<BaseState> {
  final AuthRepo _authRepo;
  final ProfileRepo _profileRepo;

  HomeCubit(this._authRepo, this._profileRepo) : super(const InitialState()) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    emit(const LoadingState());

    final result = await _profileRepo.getProfile();
    if (result.isSuccess) {
      if (result.data == null) {
        emit(const ProfileMissingState());
      } else {
        emit(HomeState(email: _authRepo.currentUserEmail, profile: result.data!));
      }
    } else {
      emit(ErrorState(error: result.error!));
    }
  }

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
