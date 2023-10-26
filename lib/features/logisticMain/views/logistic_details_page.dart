import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:the_app/constants/colors.dart';

import 'logistic_page.dart';

class LogisticDetailsPage extends StatefulWidget {
  final Map<String, dynamic> data;
  const LogisticDetailsPage({super.key, required this.data});

  @override
  State<LogisticDetailsPage> createState() => _LogisticDetailsPageState();
}

class _LogisticDetailsPageState extends State<LogisticDetailsPage> {
  @override
  void initState() {
    super.initState();

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Your code when dependencies change
  }

  @override
  void dispose() {
    // Your cleanup code here
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    DateTime date = (widget.data['Tanggal Kadaluarsa']).toDate();
    String formatted = DateFormat('EEEE, d MMMM yyyy').format(date);

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: screenHeight * 0.08,
          elevation: 0,
          leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Container(
              margin: EdgeInsets.only(left: screenWidth * 0.02, bottom: screenHeight * 0.01),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: taAccentColor, // Customize the color
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white, // Customize the color
              ),
            ),
          ),
          title: Text(
            "Detail Barang",
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
          backgroundColor: taPrimaryColor,
        ),
        backgroundColor: taBackgroundColor,
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 14, bottom: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display image
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                height: 200,
                child: Hero(
                  tag: widget.data['Link Gambar'],
                  child: CachedNetworkImage(
                    imageUrl: widget.data['Link Gambar'],
                    progressIndicatorBuilder: (_, url, download) => CircularProgressIndicator(value: download.progress),
                    errorWidget: (context, url, error) => const Image(image: AssetImage('assets/images/no-photo.png')),
                    fit: BoxFit.fitHeight,
                  ),
                )
              ),
              const SizedBox(height: 30),

              //nama
              const Text(
                'Nama',
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey
                ),
              ),
              Text(
                widget.data['Nama Barang'],
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500
                ),
              ),
              const SizedBox(height: 20),

              //kategori
              const Text(
                'Kategori',
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey
                ),
              ),
              Text(
                widget.data['Kategori'],
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),

              //stok
              const Text(
                'Stok',
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey
                ),
              ),
              Text(
                widget.data['Stok'].toInt().toString(),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),

              //rak
              const Text(
                'Rak',
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey
                ),
              ),
              Text(
                widget.data['Rak'],
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),

              //kadaluarsa
              const Text(
                'Kadaluarsa',
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey
                ),
              ),
              Text(
                formatted,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),

              //perolehan
              const Text(
                'Asal Perolehan',
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey
                ),
              ),
              Text(
                widget.data['Asal Perolehan'],
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),

              //petugas
              const Text(
                'Penanggungjawab',
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey
                ),
              ),
              Text(
                widget.data['Nama Petugas'],
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),

              // Divider
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() {
    Get.offAll(const LogisticPage());
    return Future.value(false);
  }
}