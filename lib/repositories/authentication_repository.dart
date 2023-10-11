import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:the_app/features/authentication/views/login_page.dart';
import 'package:the_app/features/logisticMain/views/logistic_page.dart';

class AuthenticationRepository extends GetxController{
  static AuthenticationRepository get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;

  @override
  void onReady(){
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user){
    user == null ? Get.offAll(() => const LoginPage()) : Get.offAll(() => LogisticPage());
  }

  Future<void> login(String email, String password) async{
    try{
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch(_){}
  }

  Future<void> logout() async => await _auth.signOut();

}

