import 'package:firebase_auth/firebase_auth.dart';
import 'package:emvigo_test/core/network/utils/exceptions.dart';
import 'package:emvigo_test/core/network/utils/response.dart';
import 'package:emvigo_test/data/repo/auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  final FirebaseAuth _firebaseAuth;

  AuthRepoImpl(this._firebaseAuth);

  @override
  Future<Response<String>> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Response.success(credential.user!.uid);
    } on FirebaseAuthException catch (e) {
      return Response.failure(handleFirebaseAuthException(e));
    }
  }

  @override
  Future<Response<String>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Response.success(credential.user!.uid);
    } on FirebaseAuthException catch (e) {
      return Response.failure(handleFirebaseAuthException(e));
    }
  }

  @override
  Future<Response<void>> signOut() async {
    await _firebaseAuth.signOut();
    return const Response.success(null);
  }

  @override
  String? get currentUserId => _firebaseAuth.currentUser?.uid;

  @override
  String? get currentUserEmail => _firebaseAuth.currentUser?.email;
}
