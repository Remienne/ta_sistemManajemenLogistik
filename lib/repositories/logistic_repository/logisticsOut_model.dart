import 'package:cloud_firestore/cloud_firestore.dart';

class LogisticsOutModel{
  final String? id;
  final String name;
  final String destination;
  final String storageId;
  final String units;
  final double stock;
  final double remainingStock;
  final String category;
  Timestamp dateEnd;
  Timestamp distributeDate;
  final String imgPath;
  final String officer;

  LogisticsOutModel({
    this.id,
    required this.name,
    required this.destination,
    required this.storageId,
    required this.units,
    required this.stock,
    required this.remainingStock,
    required this.category,
    required this.dateEnd,
    required this.distributeDate,
    required this.imgPath,
    required this.officer,
  });

  toJson(){
    return{
      "Nama Barang": name,
      "Tujuan Pengiriman": destination,
      "Rak": storageId,
      "Satuan": units,
      "Stok": stock,
      "Sisa Stok": remainingStock,
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
      destination: data['Tujuan Pengiriman'] ?? '',
      storageId: data['Rak'] ?? '',
      units: data['Satuan'] ?? '',
      stock: double.parse(data['Stok'].toString()),
      remainingStock: double.parse(data['Sisa Stok'].toString()),
      category: data['Kategori'] ?? '',
      dateEnd: data['Tanggal Kadaluarsa'],
      distributeDate: data['Tanggal Keluar'],
      imgPath: data['Link Gambar'] ?? '',
      officer: data['Nama Petugas'] ?? '',
    );
  }
}