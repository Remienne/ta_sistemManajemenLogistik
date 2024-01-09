import 'package:get/get.dart';
import 'package:the_app/repositories/authentication_repository.dart';
import 'package:the_app/repositories/users_repository/user_db.dart';


class UserController extends GetxController{
  static UserController get instance => Get.find();

  final _userDb = Get.put(UserDb());
  final _authDb = Get.put(AuthenticationRepository());

  getUserData() async{
    final email = _authDb.firebaseUser.value?.email;
    if(email != null){
      return _userDb.getUserDetails(email);
    }else{
      Get.snackbar("Error", "Login to continue");
    }
  }

  Future<bool> isUserAdmin() async {
    final user = _authDb.firebaseUser.value;
    if (user != null) {
      final userData = await _userDb.getUserDetails(user.email!);
      return userData.priv == 'admin';
    } else {
      return false;
    }
  }

  Future<bool> isUserViewer() async {
    final user = _authDb.firebaseUser.value;
    if (user != null) {
      final userData = await _userDb.getUserDetails(user.email!);
      return userData.priv == 'readonly';
    } else {
      return false;
    }
  }
}