import 'package:cloud_firestore/cloud_firestore.dart';

class LogisticsModel{
  final String? id;
  final String name;
  final String source;
  final String storageId;
  final String units;
  final double stock;
  final String category;
  Timestamp dateEnd;
  Timestamp uploadedDate;
  final String imgPath;
  final String officer;

  LogisticsModel({
    this.id,
    required this.name,
    required this.source,
    required this.storageId,
    required this.units,
    required this.stock,
    required this.category,
    required this.dateEnd,
    required this.uploadedDate,
    required this.imgPath,
    required this.officer,
  });

  toJson(){
    return{
      "Nama Barang": name,
      "Asal Perolehan": source,
      "Rak": storageId,
      "Satuan": units,
      "Stok": stock,
      "Kategori": category,
      "Tanggal Kadaluarsa":dateEnd,
      "Tanggal Unggah":uploadedDate,
      "Link Gambar": imgPath,
      "Nama Petugas": officer,
    };
  }

  factory LogisticsModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
    final data = document.data()!;
    return LogisticsModel(
        id: document.id,
        name: data['Nama Barang'] ?? '',
        source: data['Asal Perolehan'] ?? '',
        storageId: data['Rak'] ?? '',
        units: data['Satuan'] ?? '',
        stock: double.parse(data['Stok'].toString()),
        category: data['Kategori'] ?? '',
        dateEnd: data['Tanggal Kadaluarsa'],
        uploadedDate: data['Tanggal Kadaluarsa'],
        imgPath: data['Link Gambar'] ?? '',
        officer: data['Nama Petugas'] ?? '',
    );
  }
}