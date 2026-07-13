part of 'create_profile_cubit.dart';

class CreateProfileState extends BaseState {
  const CreateProfileState({
    super.state = Status.initial,
    super.error,
    this.firstName = '',
    this.lastName = '',
    this.dateOfBirth,
    this.gender = 'Male',
    this.nationality = 'Indian',
    this.language = 'English',
  });

  final String firstName;
  final String lastName;
  final DateTime? dateOfBirth;
  final String gender;
  final String nationality;
  final String language;

  @override
  List<Object?> get props => [
    state,
    error,
    firstName,
    lastName,
    dateOfBirth,
    gender,
    nationality,
    language,
  ];

  CreateProfileState copyWith({
    Status? status,
    Error? error,
    String? firstName,
    String? lastName,
    DateTime? dateOfBirth,
    String? gender,
    String? nationality,
    String? language,
  }) {
    return CreateProfileState(
      state: status ?? state,
      error: error,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      nationality: nationality ?? this.nationality,
      language: language ?? this.language,
    );
  }
}
