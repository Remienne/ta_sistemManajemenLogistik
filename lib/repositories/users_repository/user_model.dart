import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  final String? id;
  final String name;
  final String email;
  final String priv;

  UserModel({
    this.id,
    required this.email,
    required this.name,
    required this.priv,
  });

  toJson(){
    return{
      "email": email,
      "nama": name,
      "privilege": priv,
    };
  }

  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
    final data = document.data()!;
    return UserModel(
      id: document.id,
      email: data['email'] ?? '',
      name: data['nama'] ?? '',
      priv: data['privilege'] ?? '',
    );
  }
}