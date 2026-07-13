import 'package:emvigo_test/core/base/base_bloc/base_bloc.dart';
import 'package:emvigo_test/core/utils/validators.dart';

part 'create_profile_state.dart';

class CreateProfileCubit extends Cubit<CreateProfileState> {
  CreateProfileCubit() : super(const CreateProfileState());

  void firstNameChanged(String value) => emit(state.copyWith(firstName: value));

  void lastNameChanged(String value) => emit(state.copyWith(lastName: value));

  void dateOfBirthChanged(DateTime value) =>
      emit(state.copyWith(dateOfBirth: value));

  void genderChanged(String value) => emit(state.copyWith(gender: value));

  void nationalityChanged(String value) =>
      emit(state.copyWith(nationality: value));

  void languageChanged(String value) => emit(state.copyWith(language: value));

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

    await Future.delayed(const Duration(milliseconds: 600));

    emit(state.copyWith(status: Status.success));
  }
}
