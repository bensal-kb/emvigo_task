import 'package:emvigo_test/core/base/base_bloc/base_bloc.dart';
import 'package:emvigo_test/core/utils/validators.dart';
import 'package:emvigo_test/data/models/entities/profile_model.dart';
import 'package:emvigo_test/data/repo/auth_repo.dart';
import 'package:emvigo_test/data/repo/profile_repo.dart';

part 'create_profile_state.dart';

class CreateProfileCubit extends Cubit<CreateProfileState> {
  final ProfileRepo _profileRepo;
  final AuthRepo _authRepo;

  CreateProfileCubit(this._profileRepo, this._authRepo) : super(const CreateProfileState());

  void firstNameChanged(String value) => emit(state.copyWith(firstName: value, status: Status.initial));

  void lastNameChanged(String value) => emit(state.copyWith(lastName: value, status: Status.initial));

  void dateOfBirthChanged(DateTime value) =>
      emit(state.copyWith(dateOfBirth: value, status: Status.initial));

  void genderChanged(String value) => emit(state.copyWith(gender: value, status: Status.initial));

  void nationalityChanged(String value) =>
      emit(state.copyWith(nationality: value, status: Status.initial));

  void languageChanged(String value) => emit(state.copyWith(language: value, status: Status.initial));

  Future<void> submit() async {
    final error =
        Validators.required(
          state.firstName,
          message: 'First name is required',
        ) ??
        Validators.required(state.lastName, message: 'Last name is required') ??
        Validators.dateOfBirth(state.dateOfBirth);

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

    final result = await _profileRepo.saveProfile(
      ProfileModel(
        firstName: state.firstName,
        lastName: state.lastName,
        dateOfBirth: state.dateOfBirth!,
        gender: state.gender,
        nationality: state.nationality,
        language: state.language,
      ),
    );

    if (result.isSuccess) {
      emit(state.copyWith(status: Status.success));
    } else {
      emit(state.copyWith(status: Status.error, error: result.error));
    }
  }

  Future<void> logout() async {
    emit(state.copyWith(status: Status.loading));

    final result = await _authRepo.signOut();

    if (result.isSuccess) {
      await prefs.setGuestUser(false);
      emit(state.copyWith(status: Status.success, loggedOut: true));
    } else {
      emit(state.copyWith(status: Status.error, error: result.error));
    }
  }
}
