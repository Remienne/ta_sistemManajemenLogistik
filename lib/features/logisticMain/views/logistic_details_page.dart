import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:the_app/constants/colors.dart';
import 'package:the_app/features/logisticMain/controllers/logistic_detail_controller.dart';
import 'package:the_app/features/logisticMain/controllers/user_controller.dart';
import 'package:the_app/features/logisticMain/views/logisitc_edit.dart';
import 'package:the_app/repositories/logistic_repository/logisticsIn_model.dart';
import 'logistic_main.dart';

class LogisticDetailsPage extends StatefulWidget {
  final Map<String, dynamic> data;
  final String source;
  const LogisticDetailsPage({super.key, required this.data, required this.source});

  @override
  State<LogisticDetailsPage> createState() => _LogisticDetailsPageState();
}

class _LogisticDetailsPageState extends State<LogisticDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final logisticDetailController = Get.put(LogisticDetailController());
  final userController = Get.put(UserController());
  String validatorNull = 'Kolom tidak boleh kosong!';
  DateTime selectedDate = DateTime.now();

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
    var screenHeight = MediaQuery.of(context).size.height;
    DateTime expirationDate = (widget.data['Tanggal Kadaluarsa']).toDate();
    String formattedExpDate = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(expirationDate);

    if (widget.source == 'logistikIn') {
      return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          appBar: AppBar(
            actions: [
              Builder(
                  builder: (context){
                    return FutureBuilder<bool>(
                      future: userController.isUserAdmin(),
                      builder: (context, snapshot){
                        if (snapshot.connectionState == ConnectionState.done){
                          if(snapshot.hasData && snapshot.data!){
                            return PopupMenuButton<String>(
                              color: Colors.white,
                              onSelected: (value) {
                                if (value == 'edit') {
                                  // Call the function to edit the logistics item
                                  _editPage();
                                }
                                else if (value == 'delete') {
                                  // Call the function to delete the logistics item
                                  Alert(
                                    context: context,
                                    type: AlertType.warning,
                                    title: "PERINGATAN!",
                                    desc: "Apakah anda yakin ingin menghapus item?",
                                    buttons: [
                                      DialogButton(
                                        onPressed: () {
                                          setState(() {
                                            logisticDetailController.deleteItem(
                                              widget.data['id'],
                                              widget.data['Link Gambar'],
                                            );
                                            Get.offAll(() => const LogisticMain());
                                          });
                                        },
                                        color: taAccentColor,
                                        child: const Text(
                                          "Ya",
                                          style: TextStyle(color: Colors.white, fontSize: 20),
                                        ),
                                      ),
                                      DialogButton(
                                        onPressed: () => Get.back(),
                                        color: Colors.white,
                                        child: Text(
                                          "Tidak",
                                          style: TextStyle(color: Colors.grey.shade700, fontSize: 20),
                                        ),
                                      ),
                                    ],
                                  ).show();
                                }
                              },
                              itemBuilder: (BuildContext context) {
                                return [
                                  PopupMenuItem<String>(
                                      value: 'edit',
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Icon(Icons.edit_note, color: Colors.grey.shade700,),
                                          const SizedBox(width: 20,),
                                          const Text('Ubah Data'),
                                        ],
                                      )
                                  ),
                                  PopupMenuItem<String>(
                                      value: 'delete',
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Icon(Icons.delete, color: Colors.grey.shade700,),
                                          const SizedBox(width: 20,),
                                          const Text('Hapus Data'),
                                        ],
                                      )
                                  ),
                                ];
                              },
                            );
                          }
                          else{
                            return Container();
                          }
                        }
                        else{
                          return Container();
                        }
                      }
                    );
                  }
              )
            ],
            title: Text(
              "Detail Barang",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            toolbarHeight: screenHeight * 0.08,
            elevation: 0,
            leading: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white, // Customize the color
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
                      tag: widget.data['id'],
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
                  'Jumlah',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey
                  ),
                ),
                Row(
                  children: [
                    Text(
                        widget.data['Stok'].toInt().toString(),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 3),
                    Text(
                        widget.data['Satuan'],
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)
                    )
                  ],
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
                  expirationDate.isBefore(DateTime.now()) ? '$formattedExpDate (Telah Kadaluarsa)' : formattedExpDate,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: expirationDate.isBefore(DateTime.now()) ? Colors.redAccent : null
                  ),
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

                FutureBuilder(
                  future: userController.isUserViewer(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      final bool isReadonly = snapshot.data ?? false;
                      if(snapshot.hasData && !isReadonly){
                        return SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              LogisticsInModel logisticsIn = LogisticsInModel(
                                id: widget.data['id'],
                                name: widget.data['Nama Barang'],
                                source: widget.data['Asal Perolehan'],
                                storageId: widget.data['Rak'],
                                units: widget.data['Satuan'],
                                stock: double.parse(widget.data['Stok'].toString()),
                                category: widget.data['Kategori'],
                                dateEnd: widget.data['Tanggal Kadaluarsa'],
                                insertDate: widget.data['Tanggal Masuk'], // You might want to adjust this field based on your data structure
                                imgPath: widget.data['Link Gambar'],
                                officer: widget.data['Nama Petugas'],
                              );
                              showDistributionPopup(context, logisticsIn);
                            },
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 20),
                                backgroundColor: taAccentColor,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                )
                            ),
                            child: Text('Lanjutkan untuk barang keluar', style: GoogleFonts.poppins(fontSize: 14, color: Colors.white)),
                          ),
                        );
                      }
                      else{
                        return Container();
                      }
                    }
                    else {
                      return const SizedBox.shrink(); // Return an empty widget while waiting for the future to complete
                    }
                  },
                )
              ],
            ),
          ),
        ),
      );
    }
    if (widget.source == 'logistikOut') {
      DateTime distributeDate = (widget.data['Tanggal Keluar']).toDate();
      String formattedDistDate = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(distributeDate);

      return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          appBar: AppBar(
            actions: [
              Builder(
                  builder: (context){
                    return FutureBuilder<bool>(
                        future: userController.isUserAdmin(),
                        builder: (context, snapshot){
                          if (snapshot.connectionState == ConnectionState.done){
                            if(snapshot.hasData && snapshot.data!){
                              return PopupMenuButton<String>(
                                color: Colors.white,
                                onSelected: (value) {
                                  if (value == 'editDestination') {
                                    // Call the function to edit the logistics item destination
                                    logisticDetailController.destination.text = widget.data['Tujuan Pengiriman'];
                                    showChangeDestinationPopup(context, logisticDetailController.destination.text);
                                  }
                                  if (value == 'editDistributeDate') {
                                    // Call the function to edit the logistics item distribute date
                                    logisticDetailController.distributeDate.text = formattedDistDate;
                                    selectedDate = distributeDate;
                                    showChangeDistributeDatePopup(context, selectedDate);
                                  }
                                  else if (value == 'delete') {
                                    // Call the function to delete the logistics item
                                    Alert(
                                      context: context,
                                      type: AlertType.warning,
                                      title: "PERINGATAN!",
                                      desc: "Apakah anda yakin ingin menghapus item?",
                                      buttons: [
                                        DialogButton(
                                          onPressed: () {
                                            setState(() {
                                              logisticDetailController.deleteItemOut(
                                                widget.data['id'],
                                              );
                                              Get.offAll(() => const LogisticMain());
                                            });
                                          },
                                          color: taAccentColor,
                                          child: const Text(
                                            "Ya",
                                            style: TextStyle(color: Colors.white, fontSize: 20),
                                          ),
                                        ),
                                        DialogButton(
                                          onPressed: () => Get.back(),
                                          color: Colors.white,
                                          child: Text(
                                            "Tidak",
                                            style: TextStyle(color: Colors.grey.shade700, fontSize: 20),
                                          ),
                                        ),
                                      ],
                                    ).show();
                                  }
                                },
                                itemBuilder: (BuildContext context) {
                                  return [
                                    PopupMenuItem<String>(
                                        value: 'editDestination',
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Icon(Icons.edit_location_alt, color: Colors.grey.shade700,),
                                            const SizedBox(width: 20,),
                                            const Text('Ubah Tujuan Kirim'),
                                          ],
                                        )
                                    ),
                                    PopupMenuItem<String>(
                                        value: 'editDistributeDate',
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Icon(Icons.edit_calendar, color: Colors.grey.shade700,),
                                            const SizedBox(width: 20,),
                                            const Text('Ubah Tanggal Kirim'),
                                          ],
                                        )
                                    ),
                                    PopupMenuItem<String>(
                                        value: 'delete',
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Icon(Icons.delete, color: Colors.grey.shade700,),
                                            const SizedBox(width: 20,),
                                            const Text('Hapus Data'),
                                          ],
                                        )
                                    ),
                                  ];
                                },
                              );
                            }
                            else{
                              return Container();
                            }
                          }
                          else{
                            return Container();
                          }
                        }
                    );
                  }
              )
            ],
            title: Text(
              "Detail Barang",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            toolbarHeight: screenHeight * 0.08,
            elevation: 0,
            leading: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white, // Customize the color
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
                      tag: widget.data['id'],
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
                  'Jumlah Keluar',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey
                  ),
                ),
                Row(
                  children: [
                    Text(
                      widget.data['Stok'].toInt().toString(),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      widget.data['Satuan'],
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                //sisa stok
                const Text(
                  'Sisa Stok',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey
                  ),
                ),
                Row(
                  children: [
                    Text(
                      widget.data['Sisa Stok'].toInt().toString(),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      widget.data['Satuan'],
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                //rak
                const Text(
                  'Rak Asal',
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
                  expirationDate.isBefore(DateTime.now()) ? '$formattedExpDate (Telah Kadaluarsa)' : formattedExpDate,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: expirationDate.isBefore(DateTime.now()) ? Colors.redAccent : null
                  ),
                ),
                const SizedBox(height: 20),

                //tujuan
                const Text(
                    'Tujuan Pengiriman',
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey
                    ),
                  ),
                Text(
                    widget.data['Tujuan Pengiriman'],
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),

                const SizedBox(height: 20),

                //tanggal kirim
                const Text(
                  'Tanggal Pengiriman',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey
                  ),
                ),
                Text(
                  formattedDistDate,
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
              ],
            ),
          ),
        ),
      );
    }
    return const Text('Null');
  }

  Future<void> _editPage() async {
    await Get.offAll(() => LogisticEdit(data: widget.data, source: 'logistikIn',));
  }

  Future<bool> _onBackPressed() {
    Get.back();
    return Future.value(false);
  }

  showDistributionPopup(BuildContext context, LogisticsInModel logistics) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0), // Adjust the value as needed
          ),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Informasi Barang Keluar: ',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10,),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Jumlah'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return validatorNull;
                    }
                    return null;
                  },
                  controller: logisticDetailController.quantity,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: true),
                ),
                const SizedBox(height: 20,),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Tujuan Pengiriman'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return validatorNull;
                    }
                    if (value.length > 66) {
                      return 'Peringatan! Teks tidak dapat melebihi 66 karakter.'; // Add your warning message here
                    }
                    return null;
                  },
                  controller: logisticDetailController.destination,
                  style: GoogleFonts.poppins(
                    fontSize: 12.5,
                  ),
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                  maxLength: 66,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text(
                'Batal',
                style: GoogleFonts.poppins(
                  color: Colors.grey,
                  fontWeight: FontWeight.w400,
                  fontSize:12,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if(_formKey.currentState!.validate()){
                  final quantityText = logisticDetailController.quantity.text.trim();
                  // Check if the input contains only digits
                  if (!RegExp(r'^\d+$').hasMatch(quantityText))  {
                    // Show an error message or handle the invalid input here
                    Get.snackbar(
                      "PERINGATAN!",
                      "Input nilai tidak valid. Mohon cek kembali!",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.redAccent,
                      colorText: Colors.white,
                    );
                    return;
                  }
                  final quantity = double.tryParse(quantityText);
                  if (quantity == null) {
                    // Show an error message or handle the invalid input here
                    Get.snackbar(
                      "PERINGATAN!",
                      "Input nilai tidak valid. Mohon cek kembali!",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.redAccent,
                      colorText: Colors.white,
                    );
                  }
                  else if(quantity <= 0){
                    Get.snackbar(
                      "PERINGATAN!",
                      "Input nilai tidak dapat bernilai 0. Mohon cek kembali!",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.redAccent,
                      colorText: Colors.white,
                    );
                  }
                  else if (logisticDetailController.destination.text.length > 66) {
                    // Show a warning message for destination length
                    Get.snackbar(
                      "PERINGATAN!",
                      "Teks tujuan pengiriman terlalu panjang. Mohon atur kembali!",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.orange, // You can adjust the color for warnings
                      colorText: Colors.white,
                    );
                  }
                  else {
                    final availableStock = widget.data['Stok'].toInt();

                    if (quantity > availableStock) {
                      // Show an error message or handle the case where the entered quantity exceeds available stock
                      Get.snackbar(
                        "PERINGATAN!",
                        "Input nilai melebihi stok yang tersedia. Mohon cek kembali!",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.redAccent,
                        colorText: Colors.white,
                      );
                      return;
                    }
                    final destination = logisticDetailController.destination.text.trim();
                    setState(() {
                      logisticDetailController.distributeItemController(
                        logistics,
                        widget.data['id'],
                        quantity,
                        destination
                      );
                      Get.offAll(() => const LogisticMain());
                    });
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: taAccentColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
              ),
              child: Text(
                'Konfirmasi',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize:14,
                ),
              ),
            ),
            const SizedBox(width: 5,)
          ],
        );
      },
    );
  }

  showChangeDestinationPopup(BuildContext context, String destination) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0), // Adjust the value as needed
          ),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ubah Tujuan Pengiriman ',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10,),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return validatorNull;
                    }
                    return null;
                  },
                  controller: logisticDetailController.destination,
                  style: GoogleFonts.poppins(
                    fontSize: 12.5,
                  ),
                  keyboardType: TextInputType.text,
                  maxLength: 66,
                ),
              ],
            ),
          ),
          actions: [
            //cancel
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text(
                'Batal',
                style: GoogleFonts.poppins(
                  color: Colors.grey,
                  fontWeight: FontWeight.w400,
                  fontSize:12,
                ),
              ),
            ),

            //proceed
            ElevatedButton(
              onPressed: () {
                if(_formKey.currentState!.validate()){
                  final sendDestination = logisticDetailController.destination.text;
                  setState(() {
                    logisticDetailController.changeItemDestination(
                        sendDestination,
                        widget.data['id'],
                    );
                    Get.offAll(() => const LogisticMain());
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: taAccentColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
              ),
              child: Text(
                'Konfirmasi',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize:14,
                ),
              ),
            ),

            const SizedBox(width: 5,)
          ],
        );
      },
    );
  }

  showChangeDistributeDatePopup(BuildContext context, DateTime date) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0), // Adjust the value as needed
          ),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ubah Tanggal Keluar ',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10,),
                TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: logisticDetailController.distributeDate,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return validatorNull;
                      }
                      return null;
                    },
                    onTap: () async {
                    final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2001),
                        lastDate: DateTime(2101));
                    if (picked != null) {
                      setState(() {
                        selectedDate = DateTime(
                          picked.year,
                          picked.month,
                          picked.day,
                          DateTime.now().hour,
                          DateTime.now().minute,
                          DateTime.now().second,
                        );
                        logisticDetailController.distributeDate.text = DateFormat(
                            'EEEE, d MMMM yyyy', 'id_ID')
                            .format(selectedDate);
                      });
                    }
                  },
                    style: GoogleFonts.poppins(
                      fontSize: 12.5,
                    ),
                    readOnly: true,
                ),
              ],
            ),
          ),
          actions: [
            //cancel
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text(
                'Batal',
                style: GoogleFonts.poppins(
                  color: Colors.grey,
                  fontWeight: FontWeight.w400,
                  fontSize:12,
                ),
              ),
            ),

            //proceed
            ElevatedButton(
              onPressed: () {
                if(_formKey.currentState!.validate()){
                  final sendDistributeDate = selectedDate;
                  setState(() {
                    logisticDetailController.changeItemDistributeDate(
                      sendDistributeDate,
                      widget.data['id'],
                    );
                    Get.offAll(() => const LogisticMain());
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: taAccentColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
              ),
              child: Text(
                'Konfirmasi',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize:14,
                ),
              ),
            ),

            const SizedBox(width: 5,)
          ],
        );
      },
    );
  }
}