import 'package:emvigo_test/core/network/utils/response.dart';

abstract class AuthRepo {
  Future<Response<String>> signUp({
    required String email,
    required String password,
  });

  Future<Response<String>> signIn({
    required String email,
    required String password,
  });

  Future<Response<void>> signOut();

  String? get currentUserId;

  String? get currentUserEmail;
}
