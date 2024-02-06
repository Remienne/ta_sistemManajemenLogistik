import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:the_app/constants/colors.dart';
import 'package:the_app/features/logisticMain/controllers/logistic_edit_controller.dart';
import 'package:the_app/features/logisticMain/controllers/user_controller.dart';
import 'package:the_app/features/logisticMain/views/logistic_main.dart';
import 'package:the_app/repositories/logistic_repository/logisticsIn_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';
import 'package:the_app/repositories/users_repository/user_model.dart';

class LogisticEdit extends StatefulWidget {
  final Map<String, dynamic> data;
  final String source;
  const LogisticEdit({super.key, required this.data, required this.source});

  @override
  State<LogisticEdit> createState() => _LogisticEditState();
}

class _LogisticEditState extends State<LogisticEdit> {
  final _formKey = GlobalKey<FormState>();
  final editController = Get.put(LogisticEditController());
  final userController = Get.put(UserController());

  // ignore: prefer_typing_uninitialized_variables
  var category, units, _urlItemImage;
  bool isImageUploading = false;
  String validatorNull = 'Kolom tidak boleh kosong!';
  DateTime dateNow = DateTime.now();
  DateTime selectedDate = DateTime.now();

  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  File? _image;
  final ImagePicker _imagePicker = ImagePicker();
  final List<String> _previousImageUrls = [];

  Future imgFromGallery() async {

    final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 30,
        maxHeight: 800,
        maxWidth: 800
    );

    setState(() {
      if (pickedFile != null) {
        // Delete previous images if they exist
        for (String imageUrl in _previousImageUrls) {
          deletePreviousImage(imageUrl);
        }
        _image = File(pickedFile.path);
        setState(() {
          isImageUploading = true;
        });

        uploadFile().then((value) {
          _urlItemImage = value;
          _previousImageUrls.add(value); // Add the new image URL to the list
        });

        Get.snackbar(
            "Proses unggah selesai",
            "Gambar berhasil diunggah!",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white
        );

        setState(() {
          isImageUploading = false;
        });
      }
      else {
        debugPrint('No image uploaded.');
      }
    });
  }

  Future imgFromCamera() async {

    final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 30,
        maxHeight: 800,
        maxWidth: 800
    );

    setState(() {
      if (pickedFile != null) {
        // Delete previous images if they exist
        for (String imageUrl in _previousImageUrls) {
          deletePreviousImage(imageUrl);
        }
        _image = File(pickedFile.path);
        setState(() {
          isImageUploading = true;
        });

        uploadFile().then((value) {
          _urlItemImage = value;
          _previousImageUrls.add(value); // Add the new image URL to the list
        });

        Get.snackbar(
            "Proses unggah selesai",
            "Gambar berhasil diunggah!",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white
        );
        setState(() {
          isImageUploading = false;
        });
      } else {
        debugPrint('No image uploaded.');
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

  Future deletePreviousImage(String imageUrl) async {
    try {
      await firebase_storage.FirebaseStorage.instance.refFromURL(imageUrl).delete();
    } catch (e) {
      debugPrint('Error deleting previous image: $e');
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
    DateTime expirationDate = (widget.data['Tanggal Kadaluarsa']).toDate();
    String formatted = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(expirationDate);
    editController.imageUrl.text = widget.data['Link Gambar'];
    editController.name.text = widget.data['Nama Barang'];
    editController.source.text = widget.data['Asal Perolehan'];
    editController.stock.text = widget.data['Stok'].toInt().toString();
    units = widget.data['Satuan'];
    editController.storageID.text = widget.data['Rak'];
    category = widget.data['Kategori'];
    editController.dateEnd.text = formatted;
    selectedDate = expirationDate;
    debugPrint(selectedDate.toString());
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope (
      onWillPop: () async {
        // Your custom back press logic goes here
        bool shouldPop = false; // Set to false if you want to prevent the back press
        if (!shouldPop) {
          // Show a confirmation dialog or perform other actions
          Alert(
            context: context,
            type: AlertType.warning,
            title: "PERINGATAN!",
            desc: "Apakah anda akan batal mengubah item?",
            buttons: [
              DialogButton(
                onPressed: () {
                  Get.offAll(() => const LogisticMain());
                },
                color: taAccentColor,
                child: const Text(
                  "Ya",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              DialogButton(
                onPressed: () {
                  Get.back();
                },
                color: Colors.white,
                child: const Text(
                  "Tidak",
                  style: TextStyle(color: taPrimaryColor, fontSize: 15),
                ),
              ),
            ],
          ).show();
        }
        return shouldPop;
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            toolbarHeight: screenHeight * 0.08,
            elevation: 0,
            title: Container(
              margin: EdgeInsets.only(left: screenWidth * 0.02, bottom: screenHeight * 0.01),
              child: Text(
                "Ubah Data \nBarang",
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
          body: SingleChildScrollView(
            child: Form(
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
                            _showPicker(context);
                          },
                          child: SizedBox(
                            width: 120,
                            height: 120,
                            child: Center(
                              child: Stack(
                                children: [
                                  CircleAvatar(
                                      backgroundColor: Colors.grey[300],
                                      radius: 55,
                                      child:  _image != null
                                      //image uploaded
                                          ? ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Image.file(
                                          _image!,
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.fitHeight,
                                        ),
                                      )
                                          : ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: CachedNetworkImage(
                                          imageUrl: editController.imageUrl.text,
                                          progressIndicatorBuilder: (_, url, download) => CircularProgressIndicator(value: download.progress),
                                          errorWidget: (context, url, error) => const Image(image: AssetImage('assets/images/no-photo.png')),
                                          fit: BoxFit.fitHeight,
                                        ),
                                      )
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
                          controller: editController.name,
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
                              return validatorNull;
                            }
                            return null;
                          },
                          maxLength: 30,
                        ),

                        const SizedBox(height: 15),

                        //input asal perolehan
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: editController.source,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Asal Perolehan',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return validatorNull;
                            }
                            return null;
                          },
                          maxLength: 50,
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
                                      return validatorNull;
                                    }
                                    return null;
                                  },
                                  controller: editController.stock,
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
                                  if(snapshot.hasError){
                                    return Center(child: Text(snapshot.error.toString()));
                                  }
                                  if(!snapshot.hasData){
                                    return DotsIndicator(
                                      dotsCount: 3,
                                      position: 0,
                                      decorator: const DotsDecorator(
                                        color: Colors.grey, // Inactive color
                                        activeColor: taSecondaryColor,
                                      ),
                                    );
                                  }
                                  return DropdownButtonFormField(
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        labelText: "Satuan",
                                        labelStyle: GoogleFonts.poppins(fontSize: 14)
                                    ),
                                    validator: (value) {
                                      if (value == null) {
                                        return validatorNull;
                                      }
                                      return null;
                                    },
                                    isExpanded: false,
                                    value: units,
                                    items: snapshot.data?.docs.map((value) {
                                      return DropdownMenuItem(
                                        value: value.get('nama'),
                                        child: Text('${value.get('nama')}'),
                                      );
                                    }).toList(),
                                    onChanged: (unitVal) {
                                      units = unitVal;
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
                                    return validatorNull;
                                  }
                                  return null;
                                },
                                controller: editController.storageID,
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
                            if (!snapshot.hasData) {
                              return DotsIndicator(
                                dotsCount: 3,
                                position: 0,
                                decorator: const DotsDecorator(
                                  color: Colors.grey, // Inactive color
                                  activeColor: taSecondaryColor,
                                ),
                              );
                            }
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
                                  return validatorNull;
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
                            controller: editController.dateEnd,
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
                                  selectedDate = picked;
                                  editController.dateEnd.text = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(selectedDate);
                                });
                              }
                            }
                        ),

                        const SizedBox(height: 30),

                        //buttonAdd
                        FutureBuilder(
                          future: userController.getUserData(),
                          builder: (context, snapshot){
                            if(snapshot.connectionState == ConnectionState.done){
                              if(snapshot.hasData){
                                UserModel userData = snapshot.data as UserModel;
                                return SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: isImageUploading
                                        ? null
                                        : () {
                                      if(_formKey.currentState!.validate()){
                                        if(_image == null){
                                          setState(() {
                                            final logistics = LogisticsInModel(
                                              name: editController.name.text.trim(),
                                              source: editController.source.text.trim(),
                                              storageId: editController.storageID.text.trim(),
                                              units: units,
                                              stock: double.parse(editController.stock.text.trim()),
                                              category: category,
                                              dateEnd: Timestamp.fromDate(selectedDate),
                                              insertDate: Timestamp.fromDate(dateNow),
                                              imgPath: editController.imageUrl.text,
                                              officer: userData.name,
                                            );
                                            editController.editItem(logistics, widget.data['id']);
                                            Get.offAll(() => const LogisticMain());
                                          });
                                          _formKey.currentState?.reset();
                                        }
                                        else{
                                          setState(() {
                                            final logistics = LogisticsInModel(
                                              name: editController.name.text.trim(),
                                              source: editController.source.text.trim(),
                                              storageId: editController.storageID.text.trim(),
                                              units: units,
                                              stock: double.parse(editController.stock.text.trim()),
                                              category: category,
                                              dateEnd: Timestamp.fromDate(selectedDate),
                                              insertDate: Timestamp.fromDate(dateNow),
                                              imgPath: _urlItemImage?? '',
                                              officer: userData.name,
                                            );
                                            editController.editItem(logistics, widget.data['id']);
                                            Get.offAll(() => const LogisticMain());
                                          });
                                          _formKey.currentState?.reset();
                                        }
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 20),
                                        backgroundColor: isImageUploading ? Colors.grey : taAccentColor,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(15)),
                                        )
                                    ),
                                    child: Text('Ubah Data', style: GoogleFonts.poppins(fontSize: 14, color: Colors.white)),
                                  ),
                                );
                              }else if(snapshot.hasError){
                                return Center(child: Text(snapshot.error.toString()));
                              }else{
                                return const Center(child: Text("Something went wrong!"));
                              }
                            }else{
                              return const Center(child: CircularProgressIndicator());
                            }
                          },
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
                                desc: "Apakah anda akan batal mengubah item?",
                                buttons: [
                                  DialogButton(
                                    onPressed: () {
                                      Get.offAll(() => const LogisticMain());
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
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.transparent),
                              elevation: MaterialStateProperty.all(0.0),
                              splashFactory: NoSplash.splashFactory,
                              overlayColor: MaterialStateProperty.all(Colors.transparent),
                            ),
                            child: Text('Kembali', style: GoogleFonts.poppins(fontSize: 14, color: taPrimaryColor)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
      ),
    );
  }
}
