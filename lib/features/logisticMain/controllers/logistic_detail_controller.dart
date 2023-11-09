import 'package:get/get.dart';
import 'package:the_app/repositories/logistic_repository/logistic_db.dart';
import 'package:the_app/repositories/logistic_repository/logisticsIn_model.dart';

class LogisticDetailController extends GetxController{
  static LogisticDetailController get instance => Get.find();
  final logisticDb = Get.put(LogisticDb());

  Future<void> distributeItemController(LogisticsInModel logistics, String id, double quantity) async {
    await logisticDb.distributeItem(logistics, id, quantity);
  }
}