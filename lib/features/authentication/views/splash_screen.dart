import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_app/constants/colors.dart';
import 'package:the_app/constants/img_path.dart';
import 'package:the_app/constants/sizes.dart';
import 'package:the_app/constants/text_strings.dart';
import 'package:the_app/features/authentication/controllers/splash_screen_controller.dart';

class SplashScreen extends StatelessWidget{
  SplashScreen({super.key});

  final splashController = Get.put(SplashScreenController());

  @override
  Widget build(BuildContext context) {
    splashController.startAnimation();
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset : false,
      backgroundColor: taPrimaryColor,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Obx( () => AnimatedPositioned(
                top: screenHeight * 0.3,
                left: splashController.animate.value ? screenWidth * taDefaultSize: -50,
                right: screenWidth * taDefaultSize,
                duration: const Duration(milliseconds: 1600),
                child: AnimatedOpacity(
                    opacity: splashController.animate.value ? 1 : 0,
                    duration: const Duration(milliseconds: 1600),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          taAppDesc,
                          style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                )
            ),
          ),
          Obx( () => AnimatedPositioned(
                duration: const Duration(milliseconds: 1500),
                bottom: splashController.animate.value ? screenHeight * 0.3 : 0,
                child: AnimatedOpacity(
                    opacity: splashController.animate.value ? 1 : 0,
                    duration: const Duration(milliseconds: 1100),
                    child: const Image(
                      alignment: Alignment.centerRight,
                      image: AssetImage(taSplashImage),
                      width: 250,
                      height: 250,
                    ),
                )
            ),
          )
        ],
      ),
    );
  }
}