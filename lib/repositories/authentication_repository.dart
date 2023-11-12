import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:the_app/features/authentication/views/login_page.dart';
import 'package:the_app/features/logisticMain/views/logistic_main.dart';

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
    user == null
        ? Get.offAll(() => const LoginPage())
        : Get.offAll(() => const LogisticMain());
  }

  Future<String?> login(String email, String password) async{
    try{
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e){
      String errorMessage = "Terjadi kesalahan. Silahkan coba lagi!.";

       if (e.code == 'invalid-email') {
        errorMessage = 'Email salah, mohon cek kembali.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Password salah, mohon cek kembali.';
      } else if (e.code == 'user-not-found') {
         errorMessage = 'Akun tidak ditemukan, mohon periksa kembali.';
       }

      return errorMessage; // Return an error message on login failure
    }
  }

  void logout() async => await auth.signOut();

}

