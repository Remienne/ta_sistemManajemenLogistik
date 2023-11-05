import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:the_app/constants/colors.dart';
import 'package:the_app/features/logisticMain/controllers/user_controller.dart';
import 'package:the_app/features/logisticMain/views/logistic_in.dart';
import 'package:the_app/repositories/logistic_repository/logistics_model.dart';
import 'package:the_app/features/logisticMain/controllers/logistic_input_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';
import 'package:the_app/repositories/users_repository/user_model.dart';

class LogisticOut extends StatefulWidget {
  const LogisticOut({super.key});

  @override
  State<LogisticOut> createState() => _LogisticOutState();
}

class _LogisticOutState extends State<LogisticOut> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        body: Center(
          child: Text("Hello World"),
        )
    );
  }
}
