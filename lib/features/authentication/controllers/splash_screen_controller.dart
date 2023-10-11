import 'package:get/get.dart';
import 'package:the_app/features/logisticMain/views/logistic_page.dart';


class SplashScreenController extends GetxController{
  static SplashScreenController get find => Get.find();

  RxBool animate = false.obs;

  Future startAnimation() async{
    await Future.delayed(const Duration(milliseconds: 500));
    animate.value = true;
    await Future.delayed(const Duration(milliseconds: 4500));
    Get.offAll(() => LogisticPage());
  }

}