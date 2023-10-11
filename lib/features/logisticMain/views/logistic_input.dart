import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:the_app/constants/colors.dart';
import 'package:the_app/features/logisticMain/views/logistic_page.dart';
import 'package:the_app/repositories/logistic_repository/logistics_model.dart';
import 'package:the_app/features/logisticMain/controllers/logistic_input_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';

class LogisticInput extends StatefulWidget {
  static const routeName = '/logisticInput';
  const LogisticInput({super.key});

  @override
  State<LogisticInput> createState() => _LogisticInputState();
}

class _LogisticInputState extends State<LogisticInput> {

  final _formKey = GlobalKey<FormState>();
  final controller = Get.put(LogisticInputController());

  // ignore: prefer_typing_uninitialized_variables
  var category, units, _urlItemImage;
  DateTime dateNow = DateTime.now();
  DateTime selectedDate = DateTime.now();

  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  File? _image;
  final ImagePicker _imagePicker = ImagePicker();

  Future imgFromGallery() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        Get.snackbar(
            "Proses upload dalam proses...",
            "Mohon tunggu.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withOpacity(0.1),
            colorText: Colors.yellowAccent
        );
        uploadFile().then((value) => _urlItemImage = value);
        Get.snackbar(
            "Sukses!",
            "Gambar berhasil diunggah.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withOpacity(0.1),
            colorText: Colors.green
        );
        setState(() {});
      } else {
        debugPrint('No image selected.');
      }
    });
  }

  Future imgFromCamera() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        Get.snackbar(
            "Proses upload dalam proses...",
            "Mohon tunggu.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withOpacity(0.1),
            colorText: Colors.yellowAccent
        );
        uploadFile().then((value) => _urlItemImage = value);
        Get.snackbar(
            "Sukses!",
            "Gambar berhasil diunggah.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withOpacity(0.1),
            colorText: Colors.green
        );
        setState(() {});
      } else {
        debugPrint('No image selected.');
      }
    });
  }

  Future uploadFile() async {
    if (_image == null) return;
    final fileName = basename(_image!.path);

    try {
      final imgRef = firebase_storage.FirebaseStorage.instance.ref().child(fileName + DateTime.now().toString());
      await imgRef.putFile(_image!);
      return await imgRef.getDownloadURL();
    } on firebase_storage.FirebaseException {
      debugPrint('error occured');
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Gallery'),
                    onTap: () {
                      imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: screenHeight * 0.08,
        elevation: 0,
        title: Container(
          margin: EdgeInsets.only(left: screenWidth * 0.02, bottom: screenHeight * 0.01),
          child: Text(
            "Manajemen \nLogistik",
            style: GoogleFonts.poppins(
              fontSize: 20,
              height: 1.1,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        backgroundColor: taPrimaryColor,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: Column(
                children: [
                  //input gambar
                  GestureDetector(
                    onTap: () {
                      // Handle image selection here
                      _showPicker(context);
                    },
                    child: SizedBox(
                      width: 120,
                      height: 120,
                      // decoration: BoxDecoration(
                      //   shape: BoxShape.circle,
                      //   color: Colors.grey[300],
                      // ),
                      child: Center(
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 55,
                              child:  _image != null
                              ? ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.file(
                                  _image!,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.fitHeight,
                                ),
                              )
                              : Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(50)),
                                width: 100,
                                height: 100,
                                child: Icon(
                                  Icons.add_a_photo,
                                  color: Colors.grey[800],
                                ),
                              ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  //input nama item
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: controller.name,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Nama Barang',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama Item tidak boleh kosong!';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 15),

                  //stok, satuan, rak
                  Row(
                    children: [
                      //item stocks insert
                      Expanded(
                        child: TextFormField(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Stok tidak boleh kosong!';
                              }
                              return null;
                            },
                            controller: controller.stock,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Stok',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            keyboardType: const TextInputType.numberWithOptions(),
                            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
                        ),
                      ),
                      const SizedBox(width: 10),
                      //item units insert
                      Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('satuan')
                              .orderBy('nama')
                              .snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) return const Center(child: Text("Something went wrong!"));
                            if(snapshot.hasError){
                              return Center(child: Text(snapshot.error.toString()));
                            }
                            return DropdownButtonFormField(
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  labelText: "Satuan",
                                  labelStyle: GoogleFonts.poppins(fontSize: 14)
                              ),
                              isExpanded: false,
                              value: units,
                              items: snapshot.data?.docs.map((value) {
                                return DropdownMenuItem(
                                  value: value.get('nama'),
                                  child: Text('${value.get('nama')}'),
                                );
                              }).toList(),
                              onChanged: (value) {
                                units = value;
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      //rack insert
                      Expanded(
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Nama Item tidak boleh kosong!';
                            }
                            return null;
                          },
                          controller: controller.storageID,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Rak',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  //kategori
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('kategori')
                        .orderBy('nama')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      // Safety check to ensure that snapshot contains data
                      // without this safety check, StreamBuilder dirty state warnings will be thrown
                      if (!snapshot.hasData) return Container();
                      // Set this value for default,
                      // setDefault will change if an item was selected
                      // First item from the List will be displayed
                      return DropdownButtonFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          labelText: 'Kategori',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        isExpanded: false,
                        value: category,
                        items: snapshot.data?.docs.map((value) {
                          return DropdownMenuItem(
                            value: value.get('nama'),
                            child: Text('${value.get('nama')}'),
                          );
                        }).toList(),
                        onChanged: (catValue) {
                          category = catValue;
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 15),

                  //datePicker
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: controller.dateEnd,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                    ),
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Tanggal Kadaluarsa',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama Item tidak boleh kosong!';
                      }
                      return null;
                    },
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2001),
                          lastDate: DateTime(2101));
                      if (picked != null && picked != selectedDate) {
                        setState(() {
                          selectedDate = picked;
                          controller.dateEnd.text = DateFormat('EEEE, d MMMM yyyy').format(selectedDate);
                        });
                      }
                    }
                  ),

                  const SizedBox(height: 30),

                  //buttonAdd
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if(_formKey.currentState!.validate()){
                          //do your setState stuff
                          setState(() {
                            final logistics = LogisticsModel(
                                name: controller.name.text.trim(),
                                storageId: controller.storageID.text.trim(),
                                units: units,
                                stock: double.parse(controller.stock.text.trim()),
                                category: category,
                                dateEnd: Timestamp.fromDate(selectedDate),
                                uploadedDate: Timestamp.fromDate(dateNow),
                                imgPath: _urlItemImage?? 'Tidak ada gambar'
                            );
                            LogisticInputController.instance.insertItem(logistics);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => LogisticPage())
                            );
                          });
                          _formKey.currentState?.reset();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 20),
                          backgroundColor: taAccentColor,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          )
                      ),
                      child: Text('Tambah Item', style: GoogleFonts.poppins(fontSize: 14, color: Colors.white)),
                    ),
                  ),

                  const SizedBox(height: 10),

                  //buttonCancel
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Alert(
                          context: context,
                          type: AlertType.warning,
                          title: "PERINGATAN!",
                          desc: "Apakah anda akan batal menginputkan item?",
                          buttons: [
                            DialogButton(
                              onPressed: () => Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (context) => LogisticPage()),
                                      (Route<dynamic> route) => false
                              ),
                              color: taPrimaryColor,
                              child: const Text(
                                "Ya",
                                style: TextStyle(color: Colors.white, fontSize: 20),
                              ),
                            ),
                            DialogButton(
                              onPressed: () => Navigator.pop(context),
                              color: Colors.white,
                              child: const Text(
                                "Tidak",
                                style: TextStyle(color: taPrimaryColor),
                              ),
                            ),
                          ],
                        ).show();
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.transparent),
                        elevation: MaterialStateProperty.all(0.0),
                        splashFactory: NoSplash.splashFactory,
                        overlayColor: MaterialStateProperty.all(Colors.transparent),
                      ),
                      child: Text('Kembali', style: GoogleFonts.poppins(fontSize: 14, color: taPrimaryColor)),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}
