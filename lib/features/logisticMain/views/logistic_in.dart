import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:document_file_save_plus/document_file_save_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_shakemywidget/flutter_shakemywidget.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdfx/pdfx.dart' as pdfx_show;
import 'package:share/share.dart';
import 'package:the_app/constants/colors.dart';
import 'package:the_app/constants/img_path.dart';
import 'package:the_app/features/logisticMain/controllers/user_controller.dart';
import 'package:the_app/features/logisticMain/views/logistic_details_page.dart';
import 'logistic_input.dart';
import 'package:pdf/widgets.dart' as pw;

class LogisticIn extends StatefulWidget {
  const LogisticIn({super.key});

  @override
  State<LogisticIn> createState() => _LogisticInState();
}

class _LogisticInState extends State<LogisticIn> {
  final userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //body
          Column(
            children: [
              // Search bar with sort button
              Padding(
                padding: const EdgeInsets.only(top: 25, left: 15, right: 15, bottom: 8),
                child: Row(
                  children: [
                    //search bar
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                ),
                                decoration: const InputDecoration(
                                  hintText: 'Pencarian ...',
                                  hintStyle: TextStyle(fontStyle: FontStyle.italic),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            const Icon(Icons.search),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    //sort button
                    GestureDetector(
                      onTap: () {
                        // Implement the sort button function
                        _showFilterPopup(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _sortButtonColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.sort, color: _sortIconColor),
                      ),
                    ),
                  ],
                ),
              ),

              // item list
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 7),
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator(),)
                        : _resultList.isEmpty
                          ? Center(
                            child: Text(
                              'Data tidak ditemukan!',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                      )
                          : ListView.builder(
                            itemCount: _resultList.length,
                            itemBuilder: (c, index) {
                              DateTime expirationDate = (_resultList[index]['Tanggal Kadaluarsa']).toDate();
                              bool isExpired = expirationDate.isBefore(DateTime.now());
                              String formatted = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(expirationDate);

                              // Check if the current item is expired
                              if (isExpired) {
                                // Expired item UI
                                return Column(
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                        Get.to(() => LogisticDetailsPage(data: _resultList[index], source: 'logistikIn'));
                                      },
                                      child: Card(
                                          margin: const EdgeInsets.only(bottom: 12),
                                          clipBehavior: Clip.antiAlias,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(14),
                                          ),
                                          child: Container(
                                              height: 90,
                                              padding: const EdgeInsets.only(top: 2, bottom: 2, left: 12, right: 6),
                                              child: Row(
                                                children: [
                                                  //image
                                                  SizedBox(
                                                      width: 65,
                                                      height: 65,
                                                      child: Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(10),
                                                          ),
                                                          child: Hero(
                                                              tag: _resultList[index]['id'],
                                                              child: CachedNetworkImage(
                                                                imageUrl: _resultList[index]['Link Gambar'],
                                                                progressIndicatorBuilder: (_, url, download) => CircularProgressIndicator(value: download.progress),
                                                                errorWidget: (context, url, error) => const Image(image: AssetImage('assets/images/no-photo.png')),
                                                              )
                                                          )
                                                      )
                                                  ),
                                                  const SizedBox(width: 20),
                                                  //desc
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          _resultList[index]['Nama Barang'],
                                                          overflow: TextOverflow.ellipsis,
                                                          style: GoogleFonts.poppins(
                                                            fontWeight: FontWeight.w600,
                                                            fontSize:18,
                                                          ),
                                                        ),
                                                        Text(
                                                          _resultList[index]['Kategori'],
                                                          style: GoogleFonts.poppins(
                                                            fontSize:14,
                                                          ),
                                                        ),
                                                        Text(
                                                          'Kadaluarsa',
                                                          style: GoogleFonts.poppins(
                                                              fontSize:14,
                                                              color: Colors.redAccent
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              )
                                          )
                                      ),
                                    ), // Divider for expired items
                                  ],
                                );
                              }
                              else {
                                // Not expired item UI
                                return Column(
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                        Get.to(() => LogisticDetailsPage(data: _resultList[index], source: 'logistikIn'));
                                      },
                                      child: Card(
                                          margin: const EdgeInsets.only(bottom: 12),
                                          clipBehavior: Clip.antiAlias,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(14),
                                          ),
                                          child: Container(
                                              height: 90,
                                              padding: const EdgeInsets.only(top: 2, bottom: 2, left: 12, right: 6),
                                              child: Row(
                                                children: [
                                                  //image
                                                  SizedBox(
                                                      width: 65,
                                                      height: 65,
                                                      child: Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(10),
                                                          ),
                                                          child: Hero(
                                                              tag: _resultList[index]['id'],
                                                              child: CachedNetworkImage(
                                                                imageUrl: _resultList[index]['Link Gambar'],
                                                                progressIndicatorBuilder: (_, url, download) => CircularProgressIndicator(value: download.progress),
                                                                errorWidget: (context, url, error) => const Image(image: AssetImage('assets/images/no-photo.png')),
                                                              )
                                                          )
                                                      )
                                                  ),
                                                  const SizedBox(width: 20),
                                                  //desc
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          _resultList[index]['Nama Barang'],
                                                          overflow: TextOverflow.ellipsis,
                                                          style: GoogleFonts.poppins(
                                                            fontWeight: FontWeight.w600,
                                                            fontSize:18,
                                                          ),
                                                        ),
                                                        Text(
                                                          _resultList[index]['Kategori'],
                                                          style: GoogleFonts.poppins(
                                                            fontSize:14,
                                                          ),
                                                        ),
                                                        Text(
                                                          "Exp: $formatted",
                                                          style: GoogleFonts.poppins(
                                                            fontSize:14,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              )
                                          )
                                      ),
                                    ),
                                  ],
                                );
                              }
                        },
                      ),
                  )
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FutureBuilder(
        future: userController.isUserViewer(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final bool isReadonly = snapshot.data ?? false;
            return SpeedDial(
              animatedIcon: AnimatedIcons.menu_close,
              backgroundColor: taAccentColor,
              foregroundColor: Colors.white,
              activeBackgroundColor: Colors.white,
              activeForegroundColor: Colors.black,
              elevation: 0,
              overlayOpacity: 0,
              children: [
                if(!isReadonly)
                  SpeedDialChild(
                    child: Transform.scale(
                      scale: 1.2,
                      child: const Icon(Icons.add),
                    ),
                    backgroundColor: taAccentColor,
                    foregroundColor: Colors.white,
                    onTap: () {
                      Get.off(() => const LogisticInput());
                    },
                  ),

                SpeedDialChild(
                  child: Transform.scale(
                    scale: 1.2,
                    child: const Icon(Icons.picture_as_pdf),
                  ),
                  backgroundColor: taAccentColor,
                  foregroundColor: Colors.white,
                  onTap: () {
                    generatePDF();
                  },
                ),
              ],
            );
          } else {
            return const SizedBox.shrink(); // Return an empty widget while waiting for the future to complete
          }
        },
      )
    );
  }

  @override
  void initState() {
    super.initState();
    getRecords();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    // Your cleanup code here
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  final shakeKey = GlobalKey<ShakeWidgetState>();

  final TextEditingController _searchController = TextEditingController();

  List _allResults =[]; //temporary array list for storing values from firebase

  List _resultList =[]; //second temporary array list to fetch the values from _allResults[],
  // and then the value of this list would be used to show the final results of the data lists

  List<String> _filterOptions = []; // temporary string list for storing filter options

  final List<String> _selectedFilterOption = [];
  final List<DateTime> _selectedFilterOption2 = [];// New variable for selected filter option/s

  bool _isLoading = true; //loading state

  bool areFiltersApplied() {
    return _selectedFilterOption.isNotEmpty || _selectedStartDateController.text.isNotEmpty || _selectedEndDateController.text.isNotEmpty;
  } //filter options selected checker

  bool _shouldUpdateSortButtonColor = false; //sort button active checker

  Color _sortButtonColor = Colors.white; // Default color of the sorting button
  Color _sortIconColor = Colors.black; // Default color of the sorting button

  DateTime _defaultSelectedStartDate = DateTime.parse('1990-01-01 12:00:00Z');
  final _selectedStartDateController = TextEditingController();

  DateTime _defaultSelectedEndDate = DateTime.parse('2077-12-30 12:00:00Z');
  final _selectedEndDateController = TextEditingController();

  bool _isStartDateSelected = false; //start date condition check
  final FocusNode _startDateFocusNode = FocusNode(); //start date text field focus controller
  final FocusNode _endDateFocusNode = FocusNode(); //end date text field focus controller

  getRecords()async{
    setState(() {
      _isLoading = true;
    });

    Query<Map<String, dynamic>> query = FirebaseFirestore.instance.collection('logistikMasuk');
    DateTime defaultEndDate = DateTime(_defaultSelectedStartDate.year
        , _defaultSelectedStartDate.month
        , _defaultSelectedStartDate.day
        , 23, 59, 59, 999, 999);

    // Check if there are selected filter options
    if (_selectedFilterOption.isNotEmpty) {
      // If only one filter option is selected, use normal where
      if (_selectedFilterOption.length == 1) {
        query = query.where('Kategori', isEqualTo: _selectedFilterOption[0]);
      }
      else {
        // If more than one filter option is selected, use Filter.or

        // insert all Filter functions in the List below, then...
        List<Filter> filters = [];
        for (String option in _selectedFilterOption) {
          filters.add(Filter('Kategori', isEqualTo: option));
        }

        // Apply Filter.or to all filters
        Filter orCondition = Filter.or(filters[0],filters[1]);
        for (int i = 1; i < filters.length; i++) {
          orCondition = Filter.or(orCondition, filters[i]);
        }

        //combine all queries
        query = query.where(orCondition);
      }
    }

    if (_selectedFilterOption2.isNotEmpty) {
      // If only one filter option is selected, use normal where
      if(_selectedFilterOption2.length == 1){
        query = query
            .where('Tanggal Masuk', isGreaterThanOrEqualTo: _defaultSelectedStartDate)
            .where('Tanggal Masuk', isLessThan: defaultEndDate);
      }
      if(_selectedFilterOption2.length == 2){
        query = query
            .where('Tanggal Masuk', isGreaterThanOrEqualTo: _defaultSelectedStartDate)
            .where('Tanggal Masuk', isLessThanOrEqualTo: _defaultSelectedEndDate);
      }
    }

    var logisticData = await query.get();

    List<Map<String, dynamic>> logisticResults = [];
    for (var doc in logisticData.docs) {
      Map<String, dynamic> resultWithId = doc.data();
      resultWithId['id'] = doc.id; // Adding the document ID to the result map
      resultWithId['Tanggal Masuk'] = Timestamp(resultWithId['Tanggal Masuk'].seconds, 0,);
      logisticResults.add(resultWithId);
    }

    var categoryData = await FirebaseFirestore
        .instance
        .collection('kategori')
        .get();

    List<Map<String, dynamic>> categoryResults = [];
    for (var doc in categoryData.docs) {
      categoryResults.add(doc.data());
    }

    // Populate filterOptions with unique values from 'Kategori' field
    Set<String> uniqueCategories = categoryResults.map((result) => result['nama'] as String).toSet();
    _filterOptions = uniqueCategories.toList();

    setState(() {
      _allResults = logisticResults;
      _isLoading = false;
    });
    _allResults.sort((a, b) {
      // Extract and parse 'Tanggal Kadaluarsa' as DateTime
      DateTime tanggalKadaluarsaA = a['Tanggal Kadaluarsa'].toDate();
      DateTime tanggalKadaluarsaB = b['Tanggal Kadaluarsa'].toDate();

      // Compare 'Tanggal Kadaluarsa'
      return tanggalKadaluarsaA.compareTo(tanggalKadaluarsaB);
    });
    _searchResultList();
  }

  _onSearchChanged() {
    _searchResultList();
  }

  _searchResultList(){
    var showResult = [];
    if(_searchController.text != "")
    {
      for (var clientSnapshot in _allResults){
        var name = clientSnapshot['Nama Barang'].toString().toLowerCase();
        if(name.contains(_searchController.text.toLowerCase())){
          showResult.add(clientSnapshot);
        }
      }
    }
    else{
      showResult = List.from(_allResults);
    }

    setState(() {
      _resultList = showResult;
    });

  }

  void _updateSortButtonColor() {
    setState(() {
      // Check if filters are applied and update the sort button color
      // Here you can customize the color based on your preference
      if (_shouldUpdateSortButtonColor) {
        setState(() {
          _sortButtonColor = areFiltersApplied() ? taAccentColor : Colors.white;
          _sortIconColor = areFiltersApplied() ? Colors.white : Colors.black;
        });
      }
    });
  }

  void _showFilterPopup(BuildContext context) {
    bool isButtonDisabled = false;
    Get.dialog(
        barrierDismissible: false,
        WillPopScope(
          onWillPop: () async {
            // Return false to prevent closing if the user selects 'No'
            shakeKey.currentState?.shake();
            return false;
          },
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                title: Text(
                  'Filter Data',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0), // Adjust the value as needed
                ),
                content: _buildFilterContents(setState),
                actions: [
                  //hapus semua
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isStartDateSelected = false;
                        _startDateFocusNode.unfocus();
                        _endDateFocusNode.unfocus();
                        _selectedFilterOption.clear();
                        _selectedFilterOption2.clear();
                        _selectedStartDateController.clear();
                        _selectedEndDateController.clear();
                        _defaultSelectedStartDate = DateTime.parse('1990-01-01 12:00:00Z');
                        _defaultSelectedEndDate = DateTime.parse('2101-12-31 12:00:00Z');
                      });
                    },
                    child: Text(
                      'Hapus Semua',
                      style: GoogleFonts.poppins(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.normal,
                        fontSize:14,
                      ),
                    ),
                  ),

                  //terapkan
                  ShakeMe(
                    // pass the GlobalKey as an argument
                    key: shakeKey,
                    // configure the animation parameters
                    shakeCount: 3,
                    shakeOffset: 5,
                    shakeDuration: const Duration(milliseconds: 500),
                    child: ElevatedButton(
                      onPressed: isButtonDisabled
                          ? () {} // Disable the button if _isButtonDisabled is true
                          : () async {
                              // Your validation logic
                              if (_defaultSelectedEndDate.isBefore(_defaultSelectedStartDate)) {
                                // Handle validation error, show a Snackbar
                                setState(() {
                                  isButtonDisabled = true;
                                });
                                Get.snackbar(
                                  "Peringatan!",
                                  "Tanggal Akhir tidak dapat sebelum Tanggal Awal. Mohon cek kembali.",
                                  duration: const Duration(milliseconds: 1500),
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.redAccent,
                                  colorText: Colors.white,
                                );
                                await Future.delayed(const Duration(seconds: 2));
                                setState(() {
                                  isButtonDisabled = false;
                                });
                              } else if (_defaultSelectedEndDate.isAtSameMomentAs(_defaultSelectedStartDate)) {
                                // Handle validation error, show a Snackbar
                                setState(() {
                                  isButtonDisabled = true;
                                });
                                Get.snackbar(
                                  "Peringatan!",
                                  "Tanggal Akhir tidak dapat sama dengan Tanggal Awal. Mohon cek kembali.",
                                  duration: const Duration(milliseconds: 1500),
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.redAccent,
                                  colorText: Colors.white,
                                );
                                await Future.delayed(const Duration(seconds: 2));
                                setState(() {
                                  isButtonDisabled = false;
                                });
                              }
                              else {
                                setState(() {
                                  Get.back();
                                  _shouldUpdateSortButtonColor = true;
                                  _updateSortButtonColor();
                                  getRecords();
                                });
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isButtonDisabled ? Colors.grey : taAccentColor,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                      ),
                      child: Text(
                        'Terapkan',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          fontSize:14,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 5,)
                ],
              );
            },
          ),
        )
    );
  }

  Widget _buildFilterContents(StateSetter setState) {
    return Wrap(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //filter chips for categories
            Text(
              'Kategori',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 5,),
            Wrap(
              spacing: 8,
              children: [
                for (String option in _filterOptions)
                  FilterChip(
                    label: Text(
                      option,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize:13,
                        color: _selectedFilterOption.contains(option) ? Colors.white : null,
                      ),
                    ),
                    selected: _selectedFilterOption.contains(option),
                    onSelected: (selected) {
                      setState(() {
                        if (selected && !_selectedFilterOption.contains(option)) {
                          _selectedFilterOption.add(option);
                        } else if (!selected && _selectedFilterOption.contains(option)){
                          _selectedFilterOption.remove(option);
                        }
                      });
                    },
                    backgroundColor: taBackgroundColor,
                    selectedColor: taAccentColor,
                    checkmarkColor: _selectedFilterOption.contains(option) ? Colors.white : null,
                  ),
              ],
            ),
            const SizedBox(height: 10,),

            //filter using date range
            Text(
              'Tanggal Masuk',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 5,),

            //start date
            TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: _selectedStartDateController,
                readOnly: true,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                ),
                decoration: const InputDecoration(
                  labelText: 'Awal',
                ),
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2001),
                      lastDate: DateTime(2101)
                  );
                  if (picked != null && picked != _defaultSelectedStartDate) {
                    setState(() {
                      _isStartDateSelected = true;
                      _selectedFilterOption2.clear();
                      _defaultSelectedStartDate = DateTime(picked.year, picked.month, picked.day, 00, 00, 00);
                      _selectedFilterOption2.add(_defaultSelectedStartDate);
                      _selectedStartDateController.text = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(_defaultSelectedStartDate);
                    });
                  }
                }
            ),
            //end date
            const SizedBox(height: 10,),
            TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: _selectedEndDateController,
                readOnly: true,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                ),
                decoration: const InputDecoration(
                  labelText: 'Akhir (Opsional)',
                ),
                focusNode: _endDateFocusNode,
                onTap: () async {
                  if (!_isStartDateSelected){
                    _endDateFocusNode.unfocus();
                    Get.snackbar(
                        "Peringatan!",
                        "Tanggal Awal harus dipilih terlebih dahulu. Mohon cek kembali.",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.redAccent,
                        colorText: Colors.white
                    );
                    return;
                  }
                  final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2001),
                      lastDate: DateTime(2101));
                  if (picked != null && picked != _defaultSelectedEndDate) {
                    setState(() {
                      _defaultSelectedEndDate = DateTime(picked.year, picked.month, picked.day, 00, 00, 00);
                      // Remove item at index 1
                      if (_selectedFilterOption2.length > 2) {
                        _selectedFilterOption2.removeAt(1);
                      }
                      _selectedFilterOption2.add(_defaultSelectedEndDate);
                      _selectedEndDateController.text = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(_defaultSelectedEndDate);
                    });
                  }
                }
            ),
          ],
        ),
      ],
    );
  }

  Future<void> generatePDF() async {
    // Initialize the localization
    await initializeDateFormatting('id_ID', null);

    // Generate PDF and fetch a Logo
    final pdf = pw.Document();
    final ByteData image = await rootBundle.load(taMainLogo);
    Uint8List imageData = (image).buffer.asUint8List();

    // Specify the fields you want to include in the PDF
    List<String> fieldName = [
      'No', 'Nama', 'Jumlah',
      'Satuan', 'Jenis Barang', 'Tanggal Masuk',
      'Kadaluarsa', 'Asal Perolehan'
    ];
    List<String> fieldContentsFrom = [
      'Nama Barang', 'Stok',
      'Satuan', 'Kategori',
      'Tanggal Masuk', 'Tanggal Kadaluarsa',
      'Asal Perolehan'];

    DateTime dateNow = DateTime.now();
    String formattedDateNow = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(dateNow);

    // Set the number of rows you want to display on each page
    const int firstPageRow = 7;
    const int otherPagesRow = 8;

    // Calculate the number of pages needed for subsequent pages
    final int otherPagesCount = ((_allResults.length - firstPageRow) / otherPagesRow).ceil();

    // Table contents column widths
    Map<int, pw.TableColumnWidth> customColumnWidths = {
      0: const pw.FixedColumnWidth(16.0), // 'No' column
      1: const pw.FixedColumnWidth(51.0), // 'Nama' column
      2: const pw.FixedColumnWidth(30.0), // 'stok' column
      3: const pw.FixedColumnWidth(28.0), // 'Satuan' column
      4: const pw.FixedColumnWidth(47.0), // 'Jenis Barang' column
      5: const pw.FixedColumnWidth(53.0), // 'Tanggal Masuk' column
      6: const pw.FixedColumnWidth(40.0), // 'Kadaluarsa' column
      7: const pw.FixedColumnWidth(52.0), // 'Perolehan' column
      // Add more fields and their corresponding widths
    };

    //re-Align the ordering of all the items
    _allResults.sort((a, b) {
      // First, compare 'Kategori'
      int kategoriComparison = a['Kategori'].compareTo(b['Kategori']);
      if (kategoriComparison != 0) {
        return kategoriComparison;
      }
      // If 'Kategori' is the same, compare 'Nama Barang' in a case-insensitive manner
      return a['Nama Barang'].toLowerCase().compareTo(b['Nama Barang'].toLowerCase());
    });

    // First Page
    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          orientation: pw.PageOrientation.landscape,
          pageFormat: PdfPageFormat.a4.landscape,
        ),
        build: (context) {
          return [
            pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  //logos, titles
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.SizedBox(
                        height: 85,
                        width: 140,
                        child: pw.Image(
                            pw.MemoryImage(imageData),
                            height: 85,
                            width: 85
                        ),
                      ),
                      pw.Column(
                          children: [
                            pw.Text(
                              'PEMERINTAH KABUPATEN MALANG',
                              style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.normal),
                            ),
                            pw.Text(
                              'BADAN PENANGGULANGAN BENCANA DAERAH',
                              style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
                            ),
                            pw.Text(
                              'Jl. Trunojoyo Kav.8 Telp. (0341) 392220 fax. (0341) 392121 Kepanjen',
                              style: pw.TextStyle(fontSize: 16, fontStyle: pw.FontStyle.normal),
                            ),
                            pw.Text(
                              'Website : http://www.malangkab.go.id Email: bpbdkabupatenmalang@yahoo.co.id',
                              style: pw.TextStyle(fontSize: 13, fontStyle: pw.FontStyle.italic),
                            ),
                            pw.Text(
                              'KEPANJEN - 65163',
                              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
                            ),
                          ]
                      ),
                      pw.SizedBox(height:85,width: 45),
                    ],
                  ),
                  pw.Divider(thickness: 1),
                  pw.SizedBox(height: 15),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Laporan Logistik Masuk',
                        style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Text(
                        formattedDateNow,
                        style: pw.TextStyle(fontSize: 12, fontStyle: pw.FontStyle.italic),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 15),

                  // tables
                  if (_allResults.isNotEmpty)
                  //tables
                    pw.Table(
                      defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
                      border: pw.TableBorder.all(),
                      columnWidths: customColumnWidths,
                      children: [
                        pw.TableRow(
                          children: fieldName.map((fields) {
                            return pw.Padding(
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Text(
                                  fields,
                                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14),
                                  textAlign: pw.TextAlign.center
                              ),
                            );
                          }).toList(),
                        ),

                        // Data rows
                        ..._allResults.sublist(0, min(firstPageRow, _allResults.length)).asMap().entries.map((entry) {
                          int index = entry.key;
                          Map<String, dynamic> row = entry.value;

                          return pw.TableRow(
                            children: [
                              // 'No' column
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(8),
                                child: pw.Text(
                                    (index + 1).toString(),
                                    textAlign: pw.TextAlign.center
                                ),
                              ),
                              // Data columns
                              ...fieldContentsFrom.map((fieldName) {
                                final fieldValue = row[fieldName];

                                // Check if the field is a number and convert it to int
                                final formattedValue = fieldValue is num
                                    ? fieldValue.toInt().toString()
                                    : fieldValue is Timestamp
                                    ? DateFormat('dd/MM/yyyy', 'id_ID').format(fieldValue.toDate())
                                    : fieldValue.toString();

                                return pw.Padding(
                                  padding: const pw.EdgeInsets.all(8),
                                  child: pw.Text(formattedValue, textAlign: pw.TextAlign.center),
                                );
                              }).toList(),
                            ],
                          );
                        }).toList(),
                      ],
                    ),
                  if (_allResults.isEmpty)
                    pw.Table(
                      defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
                      border: pw.TableBorder.all(),
                      columnWidths: customColumnWidths,
                      children: [
                        pw.TableRow(
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Text(
                                  'Tabel Kosong',
                                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14),
                                  textAlign: pw.TextAlign.center
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                ]
            )
          ];
        },
      ),
    );

    // Subsequent pages
    for (int currentPage = 1; currentPage <= otherPagesCount; currentPage++) {
      // Calculate the start and end index for the current page
      int startIndex = firstPageRow + (currentPage - 1) * otherPagesRow;
      int endIndex = startIndex + otherPagesRow;

      // Ensure endIndex doesn't exceed the total number of rows
      endIndex = endIndex > _allResults.length ? _allResults.length : endIndex;

      // Subset of data for the current page
      List currentPageData = _allResults.sublist(startIndex, endIndex);

      pdf.addPage(
        pw.MultiPage(
          pageTheme: pw.PageTheme(
            orientation: pw.PageOrientation.landscape,
            pageFormat: PdfPageFormat.a4.landscape,
          ),
          build: (context) {
            return [
              pw.Table(
                defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
                border: pw.TableBorder.all(),
                columnWidths: customColumnWidths,
                children: [
                  pw.TableRow(
                    children: fieldName.map((fields) {
                      return pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                            fields,
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14),
                            textAlign: pw.TextAlign.center
                        ),
                      );
                    }).toList(),
                  ),

                  // Data rows
                  ...currentPageData.asMap().entries.map((entry) {
                    int index = entry.key;
                    Map<String, dynamic> row = entry.value;

                    return pw.TableRow(
                      children: [
                        // 'No' column
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                              (startIndex + index + 1).toString(),
                              textAlign: pw.TextAlign.center
                          ),
                        ),
                        // Data columns
                        ...fieldContentsFrom.map((fieldName) {
                          final fieldValue = row[fieldName];

                          // Check if the field is a number and convert it to int
                          final formattedValue = fieldValue is num
                              ? fieldValue.toInt().toString()
                              : fieldValue is Timestamp
                              ? DateFormat('dd/MM/yyyy', 'id_ID').format(fieldValue.toDate())
                              : fieldValue.toString();

                          return pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(formattedValue, textAlign: pw.TextAlign.center),
                          );
                        }).toList(),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ];
          },
        ),
      );
    }

    // Generate the pdf for previewing
    final output = await getExternalStorageDirectory();
    final file = File("${output?.path}/Laporan Logistik Masuk.pdf");

    final bytes = await pdf.save(); // Await here to get the actual bytes

    await file.writeAsBytes(bytes);

    final pdfPinchController = pdfx_show.PdfControllerPinch(
      document: pdfx_show.PdfDocument.openFile(file.path),
    );

    if(context.mounted){
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0), // Adjust the value as needed
            ),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 200,
              child: pdfx_show.PdfViewPinch(controller: pdfPinchController,),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text(
                        'Tutup',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize:12,
                            color: Colors.grey
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          Get.back();
                          // Save to 'Downloads' folder
                          DocumentFileSavePlus().saveMultipleFiles(
                            dataList: [bytes,],
                            fileNameList: ["Laporan Logistik Masuk.pdf",],
                            mimeTypeList: ["application/pdf",],
                          );
                          // Share the PDF file
                          Share.shareFiles([file.path]);
                        },
                        icon: const Icon(Icons.share_rounded, color: taPrimaryColor,)
                    ),
                  ],
                ),
              )
            ],
          );
        },
      );
    }
  }
}