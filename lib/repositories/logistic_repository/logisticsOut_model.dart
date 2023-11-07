import 'package:cloud_firestore/cloud_firestore.dart';

class LogisticsExpiryDateModel{
  final String? id;
  Timestamp dateEnd;

  LogisticsExpiryDateModel({
    this.id,
    required this.dateEnd,
  });

  toJson(){
    return{
      "Tanggal Kadaluarsa":dateEnd,
    };
  }

  factory LogisticsExpiryDateModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
    final data = document.data()!;
    return LogisticsExpiryDateModel(
      id: document.id,
      dateEnd: data['Tanggal Kadaluarsa'],
    );
  }
}