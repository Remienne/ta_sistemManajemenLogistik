import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_app/repositories/logistic_repository/logisticsIn_model.dart';
import 'package:the_app/repositories/logistic_repository/logisticsOut_model.dart';

class LogisticDb extends GetxController{
  static LogisticDb get instance => Get.find();
  final _dbLogistikMasuk = FirebaseFirestore.instance.collection('logistikMasuk');
  final _dbLogistikKeluar = FirebaseFirestore.instance.collection('logistikKeluar');

  insertLogisticAlert(LogisticsInModel logistics) async {
    await _dbLogistikMasuk.add(logistics.toJson()).whenComplete(() {
      Get.snackbar(
          "Sukses!",
          "Item berhasil ditambahkan.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.greenAccent.withOpacity(0.1),
          colorText: Colors.green
      );
    }).catchError((error, stackTrace){
      Get.snackbar(
          "Error",
          "Something went wrong. Try again!",
          snackPosition:SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.red
      );
      return null;
    });

  }

  Future<String> getData() async {
    DocumentReference docRef = _dbLogistikMasuk.doc();
    DocumentSnapshot docSnap = await docRef.get();
    var docID2= docSnap.reference.id;
    return docID2;
  }

  Future<void> distributeItem(LogisticsInModel logistics, String id, double quantity, String destination) async {
    try {
      if (logistics.stock >= quantity) {

        // Update stock in logistikMasuk
        await _dbLogistikMasuk.doc(id).update({"Stok": logistics.stock - quantity});

        // Create an instance of LogisticsOutModel for the record in logistikKeluar
        LogisticsOutModel distributedItem = LogisticsOutModel(
          name: logistics.name,
          destination: destination,
          storageId: logistics.storageId,
          units: logistics.units,
          stock: quantity,
          remainingStock: logistics.stock - quantity,
          category: logistics.category,
          dateEnd: logistics.dateEnd,
          distributeDate: logistics.insertDate,
          imgPath: logistics.imgPath,
          officer: logistics.officer,
        );

        // Add record to logistikKeluar
        await _dbLogistikKeluar.add(distributedItem.toJson());

        Get.snackbar(
          "Sukses!",
          "Item berhasil didistribusikan.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
        );
      }
      else {
        Get.snackbar(
          "Gagal!",
          "Stok tidak mencukupi untuk distribusi.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.red,
        );
      }
    } catch (e) {
      // Log the error
      debugPrint('Error distributing item: $e');
    }
  }
}