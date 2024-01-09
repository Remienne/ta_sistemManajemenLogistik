import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_app/repositories/logistic_repository/logistic_db.dart';
import 'package:the_app/repositories/logistic_repository/logisticsIn_model.dart';

class LogisticEditController extends GetxController{
  static LogisticEditController get instance => Get.find();
  final logisticDb = Get.put(LogisticDb());

  //Textfield Controllers to get data from Textfields
  final name = TextEditingController();
  final imageUrl = TextEditingController();
  final source = TextEditingController();
  final storageID = TextEditingController();
  final stock = TextEditingController();
  final dateEnd = TextEditingController();

  Future<void> editItem(LogisticsInModel logistics, String id) async {
    await logisticDb.editLogistic(logistics, id);
  }

}