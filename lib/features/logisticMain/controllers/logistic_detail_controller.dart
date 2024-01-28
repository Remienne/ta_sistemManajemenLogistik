import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_app/repositories/logistic_repository/logistic_db.dart';
import 'package:the_app/repositories/logistic_repository/logisticsIn_model.dart';

class LogisticDetailController extends GetxController{

  final quantity = TextEditingController();
  final destination = TextEditingController();

  static LogisticDetailController get instance => Get.find();
  final logisticDb = Get.put(LogisticDb());

  Future<void> distributeItemController(
      LogisticsInModel logistics,
      String id,
      double quantity,
      String destination
      ) async {
    await logisticDb.distributeItem(logistics, id, quantity, destination);
  }

  Future<void> changeItemDestination(String destination, String id,) async {
    await logisticDb.editChangeDestination(destination, id);
  }

  Future<void> deleteItem(String id, String imageUrl) async {
    await logisticDb.deleteItem(id, imageUrl);
  }

  Future<void> deleteItemOut(String id) async {
    await logisticDb.deleteItemOut(id);
  }

}