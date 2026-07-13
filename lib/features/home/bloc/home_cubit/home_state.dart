part of 'home_cubit.dart';

class HomeState extends SuccessState {
  const HomeState({required this.email, required this.profile});

  final String? email;
  final ProfileModel profile;

  @override
  List<Object?> get props => [email, profile];
}

class ProfileMissingState extends SuccessState {
  const ProfileMissingState();
}
