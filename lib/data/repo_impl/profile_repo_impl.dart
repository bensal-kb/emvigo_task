import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:emvigo_test/core/network/utils/exceptions.dart';
import 'package:emvigo_test/core/network/utils/response.dart';
import 'package:emvigo_test/data/models/entities/profile_model.dart';
import 'package:emvigo_test/data/repo/profile_repo.dart';

class ProfileRepoImpl implements ProfileRepo {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  ProfileRepoImpl(this._firestore, this._firebaseAuth);

  @override
  Future<Response<void>> saveProfile(ProfileModel profile) async {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) {
      return const Response.failure(
        InvalidError(message: 'You must be signed in to save a profile.'),
      );
    }

    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .set(profile.toJson(), SetOptions(merge: true));
      return const Response.success(null);
    } on FirebaseException catch (e) {
      return Response.failure(handleFirestoreException(e));
    }
  }

  @override
  Future<Response<ProfileModel?>> getProfile() async {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) {
      return const Response.failure(
        InvalidError(message: 'You must be signed in to view your profile.'),
      );
    }

    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) {
        return const Response.success(null);
      }
      return Response.success(ProfileModel.fromJson(doc.data()!));
    } on FirebaseException catch (e) {
      return Response.failure(handleFirestoreException(e));
    }
  }
}
