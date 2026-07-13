import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileModel {
  final String firstName;
  final String lastName;
  final DateTime dateOfBirth;
  final String gender;
  final String nationality;
  final String language;

  const ProfileModel({
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.gender,
    required this.nationality,
    required this.language,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      dateOfBirth: (json['dateOfBirth'] as Timestamp).toDate(),
      gender: json['gender'] as String,
      nationality: json['nationality'] as String,
      language: json['language'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'dateOfBirth': Timestamp.fromDate(dateOfBirth),
      'gender': gender,
      'nationality': nationality,
      'language': language,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
