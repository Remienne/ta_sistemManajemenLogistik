import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_app/repositories/logistic_repository/logistics_model.dart';

class LogisticDb extends GetxController{
  static LogisticDb get instance => Get.find();
  final _db = FirebaseFirestore.instance.collection('logistics');

  insertLogisticAlert(LogisticsModel logistics) async {
    await _db.add(logistics.toJson()).whenComplete(() {
      Get.snackbar(
          "Sukses!",
          "Item berhasil ditambahkan.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green
      );
    }).catchError((error, stackTrace){
      Get.snackbar(
          "Error",
          "Something went wrong. Try again!",
          snackPosition:SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.red);
      debugPrint("ERROR - $error");
    });
  }

  Future<List<LogisticsModel>> itemList() async{
    final snapshot = await _db.get();
    final logisticData = snapshot.docs.map((e) => LogisticsModel.fromSnapshot(e)).toList();
    return logisticData;
  }

}