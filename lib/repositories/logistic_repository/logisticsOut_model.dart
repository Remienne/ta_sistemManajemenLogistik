import 'package:cloud_firestore/cloud_firestore.dart';

class LogisticsOutModel{
  final String? id;
  final String name;
  final String source;
  final String storageId;
  final String units;
  final double stock;
  final String category;
  Timestamp dateEnd;
  Timestamp distributeDate;
  final String imgPath;
  final String officer;

  LogisticsOutModel({
    this.id,
    required this.name,
    required this.source,
    required this.storageId,
    required this.units,
    required this.stock,
    required this.category,
    required this.dateEnd,
    required this.distributeDate,
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
      "Tanggal Keluar":distributeDate,
      "Link Gambar": imgPath,
      "Nama Petugas": officer,
    };
  }

  factory LogisticsOutModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
    final data = document.data()!;
    return LogisticsOutModel(
      id: document.id,
      name: data['Nama Barang'] ?? '',
      source: data['Asal Perolehan'] ?? '',
      storageId: data['Rak'] ?? '',
      units: data['Satuan'] ?? '',
      stock: double.parse(data['Stok'].toString()),
      category: data['Kategori'] ?? '',
      dateEnd: data['Tanggal Kadaluarsa'],
      distributeDate: data['Tanggal Keluar'],
      imgPath: data['Link Gambar'] ?? '',
      officer: data['Nama Petugas'] ?? '',
    );
  }
}