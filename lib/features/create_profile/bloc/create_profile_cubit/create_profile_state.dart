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
    this.loggedOut = false,
  });

  final String firstName;
  final String lastName;
  final DateTime? dateOfBirth;
  final String gender;
  final String nationality;
  final String language;
  final bool loggedOut;

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
    loggedOut,
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
    bool? loggedOut,
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
      loggedOut: loggedOut ?? this.loggedOut,
    );
  }
}
