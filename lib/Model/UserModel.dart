import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String email;
  final String password;
  final String id;
  final String photoUrl;
  final String username;
  final String bio;
  final int age;
  final String phoneNumber;
  final Map followers;
  final Map following;

  const UserModel({required this.phoneNumber,required this.password, required this.age,required this.username, required this.id, required this.photoUrl, required this.email, required this.bio, require, required this.followers, required this.following});

  factory UserModel.fromDocument(DocumentSnapshot document) {
    return UserModel(
      email: document['email'],
      age: document['age'],
      phoneNumber: document['phonenumber'],
      password: document['password'],
      username: document['username'],
      photoUrl: document['photoUrl'],
      id: document.id,
      bio: document['bio'],
      followers: document['followers'],
      following: document['following'],
    );
  }

  Map<String, dynamic> toMap() => {
    "id": id,
    "email": email,
    "username": username,
    "password": password,
    "PhotoUrl": photoUrl,
    "bio": bio,
    "Followers": followers,
    "Following": following,
    "age": age,
    "phoneNumber": phoneNumber,
  };
}
