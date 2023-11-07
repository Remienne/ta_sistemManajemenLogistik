import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_app/repositories/logistic_repository/logistic_db.dart';
import 'package:the_app/repositories/logistic_repository/logisticsIn_model.dart';

class LogisticInputController extends GetxController{
  static LogisticInputController get instance => Get.find();

  //Textfield Controllers to get data from Textfields
  final name = TextEditingController();
  final source = TextEditingController();
  final storageID = TextEditingController();
  final units = TextEditingController();
  final stock = TextEditingController();
  final category = TextEditingController();
  final dateEnd = TextEditingController();

  final logisticDb = Get.put(LogisticDb());

  Future<void> insertItem(LogisticsModel logistics) async {
    await logisticDb.insertLogisticAlert(logistics);
  }
}