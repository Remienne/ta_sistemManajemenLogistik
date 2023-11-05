import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:the_app/features/authentication/views/login_page.dart';
import 'package:the_app/features/logisticMain/views/logistic_main.dart';
import 'package:the_app/features/logisticMain/views/logistic_in.dart';

class AuthenticationRepository extends GetxController{
  static AuthenticationRepository get instance => Get.find();

  final auth = FirebaseAuth.instance;
  late Rx<User?> firebaseUser;

  @override
  void onReady(){
    super.onReady();

    firebaseUser = Rx<User?>(auth.currentUser);

    firebaseUser.bindStream(auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user){
    user == null ? Get.offAll(() => const LoginPage()) : Get.offAll(() => const LogisticMain());
  }

  Future<void> login(String email, String password) async{
    try{
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } catch(firebaseAuthException){}
  }

  void logout() async => await auth.signOut();

}

