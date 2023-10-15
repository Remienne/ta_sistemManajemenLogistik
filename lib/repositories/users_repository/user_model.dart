import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  final String? id;
  final String name;
  final String email;

  UserModel({
    this.id,
    required this.email,
    required this.name,
  });

  toJson(){
    return{
      "email": email,
      "nama": name,
    };
  }

  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
    final data = document.data()!;
    return UserModel(
      id: document.id,
      email: data['email'] ?? '',
      name: data['nama'] ?? '',
    );
  }
}