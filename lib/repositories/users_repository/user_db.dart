import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:the_app/repositories/users_repository/user_model.dart';

class UserDb extends GetxController{
  static UserDb get instance => Get.find();
  final _db = FirebaseFirestore.instance;

  Future<UserModel> getUserDetails(String email) async{
    final snapshot = await _db.collection("users").where("email", isEqualTo: email).get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
    return userData;
  }

}