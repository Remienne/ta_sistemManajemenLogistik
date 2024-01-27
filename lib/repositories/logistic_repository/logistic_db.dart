import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_app/repositories/logistic_repository/logisticsIn_model.dart';
import 'package:the_app/repositories/logistic_repository/logisticsOut_model.dart';

class LogisticDb extends GetxController{
  static LogisticDb get instance => Get.find();
  final _dbLogistikMasuk = FirebaseFirestore.instance.collection('logistikMasuk');
  final _dbLogistikKeluar = FirebaseFirestore.instance.collection('logistikKeluar');

  insertLogisticAlert(LogisticsInModel logistics) async {
    try {
      await _dbLogistikMasuk.add(logistics.toJson());
      Get.snackbar(
        "Sukses!",
        "Item berhasil ditambahkan.",
        snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white
      );

      // Return a placeholder DocumentReference to match the expected type
      return Future.value(_dbLogistikMasuk.doc()); // Replace with the correct method if available
    } catch (error) {
      Get.snackbar(
        "Error",
        "Something went wrong. Try again!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );

      // Return a FutureOr<DocumentReference<Map<String, dynamic>>>
      return Future.value(null);
    }
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
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
      else {
        Get.snackbar(
          "Gagal!",
          "Stok tidak mencukupi untuk distribusi.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      // Log the error
      debugPrint('Error distributing item: $e');
    }
  }

  // Edit function
  Future<void> editLogistic(LogisticsInModel logistics, String id) async {
    try {
      // Update the document in logistikMasuk
      await _dbLogistikMasuk.doc(id).update(logistics.toJson());

      Get.snackbar(
        "Sukses!",
        "Item berhasil diubah.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      // Log the error
      debugPrint('Error editing item: $e');

      Get.snackbar(
        "Galat!",
        "Terjadi kesalahan, mohon ulangi kembali.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }


  Future<void> deleteItem(String id, String imageUrl) async {
    try {
      // Delete the document from logistikMasuk
      await _dbLogistikMasuk.doc(id).delete();
      await FirebaseStorage.instance.refFromURL(imageUrl).delete();
      Get.snackbar(
        "Sukses!",
        "Item berhasil dihapus.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (error) {
      Get.snackbar(
        "Error",
        "Gagal menghapus item. Silakan coba lagi!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      debugPrint("Error deleting item: $error");
    }
  }
}