import 'package:get/get.dart';
import 'package:the_app/repositories/logistic_repository/logistic_db.dart';
import 'package:the_app/repositories/logistic_repository/logisticsIn_model.dart';

class LogisticPageController extends GetxController{
  static LogisticPageController get instance => Get.find();
  final logisticDb = Get.put(LogisticDb());

  Future<List<LogisticsModel>> getItemList() async{
    return await logisticDb.itemList();
  }
}