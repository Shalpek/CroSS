// lib/models/user_model.dart
class UserModel {
  final String uid;
  final String? email;
  String? firstName;
  String? lastName;
  DateTime? birthDate;
  String? description;
  List<String>? interests;

  UserModel({
    required this.uid,
    this.email,
    this.firstName,
    this.lastName,
    this.birthDate,
    this.description,
    this.interests,
  });

  Map<String, dynamic> toMap() => {
    'uid': uid,
    'email': email,
    'firstName': firstName,
    'lastName': lastName,
    'birthDate': birthDate?.toIso8601String(),
    'description': description,
    'interests': interests,
  };

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
    uid: map['uid'] as String,
    email: map['email'] as String?,
    firstName: map['firstName'] as String?,
    lastName: map['lastName'] as String?,
    birthDate:
        map['birthDate'] != null ? DateTime.parse(map['birthDate']) : null,
    description: map['description'] as String?,
    interests: (map['interests'] as List?)?.map((e) => e.toString()).toList(),
  );
}
