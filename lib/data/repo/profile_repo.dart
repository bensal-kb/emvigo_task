import 'package:emvigo_test/core/network/utils/response.dart';
import 'package:emvigo_test/data/models/entities/profile_model.dart';

abstract class ProfileRepo {
  Future<Response<void>> saveProfile(ProfileModel profile);

  Future<Response<ProfileModel?>> getProfile();
}
