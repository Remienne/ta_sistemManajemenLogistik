import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';
import 'package:share/share.dart';
import 'package:the_app/constants/colors.dart';
import 'package:the_app/constants/img_path.dart';
import 'package:the_app/features/logisticMain/views/logistic_details_page.dart';
import 'logistic_input.dart';
import 'package:pdf/widgets.dart' as pw;

class LogisticIn extends StatefulWidget {
  const LogisticIn({super.key});

  @override
  State<LogisticIn> createState() => _LogisticInState();
}

class _LogisticInState extends State<LogisticIn> {
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
                          String formatted = DateFormat('EEEE, d MMMM yyyy').format(expirationDate);

                          // Check if the current item is expired
                          if (isExpired) {
                            // Expired item UI
                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    Get.to(() => LogisticDetailsPage(data: _resultList[index]));
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
                                                          tag: _resultList[index]['Link Gambar'],
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
                                    Get.to(() => LogisticDetailsPage(data: _resultList[index]));
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
                                                          tag: _resultList[index]['Link Gambar'],
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
                                                      formatted,
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
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: taAccentColor,
        foregroundColor: Colors.white,
        activeBackgroundColor: Colors.white,
        activeForegroundColor: Colors.black,
        elevation: 0,
        overlayOpacity: 0,
        children: [
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
      ),
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

  final TextEditingController _searchController = TextEditingController();

  List _allResults =[]; //temporary array list for storing values from firebase

  List _resultList =[]; //second temporary array list to fetch the values from _allResults[],
  // and then the value of this list would be used to show the final results of the data lists

  List<String> _filterOptions = []; // temporary string list for storing filter options

  final List<String> _selectedFilterOption = []; // New variable for selected filter option/s

  bool _isLoading = true; //loading state

  bool areFiltersApplied() {
    return _selectedFilterOption.isNotEmpty;
  } //filter options selected checker

  bool _shouldUpdateSortButtonColor = false; //sort button active checker

  Color _sortButtonColor = Colors.white; // Default color of the sorting button
  Color _sortIconColor = Colors.black; // Default color of the sorting button

  getRecords()async{
    setState(() {
      _isLoading = true;
    });

    Query<Map<String, dynamic>> query = FirebaseFirestore.instance.collection('logistikMasuk');

    var logisticData = await query
        .orderBy('Kategori')
        .orderBy('Nama Barang')
        .get();

    List<Map<String, dynamic>> logisticResults = [];
    for (var doc in logisticData.docs) {
      logisticResults.add(doc.data());
    }

    setState(() {
      _allResults = logisticResults;
      _isLoading = false;
    });
    _searchResultList();

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

  Future<void> generatePDF() async {
    // Generate PDF and fetch a Logo
    final pdf = pw.Document();
    final ByteData image = await rootBundle.load(taSplashImage);
    Uint8List imageData = (image).buffer.asUint8List();

    // Specify the fields you want to include in the PDF
    List<String> fieldName = ['No', 'Nama', 'Jumlah', 'Satuan', 'Jenis Barang', 'Kadaluarsa', 'Asal Perolehan'];
    List<String> fieldContentsFrom = ['Nama Barang', 'Stok', 'Satuan', 'Kategori'];

    DateTime dateNow = DateTime.now();
    String formattedDateNow = DateFormat('EEEE, d MMMM yyyy').format(dateNow);

    // Set the number of rows you want to display on each page
    const int rowsPerPage = 8;

    // Calculate the number of pages needed
    final int pageCount = (_allResults.length / rowsPerPage).ceil();

    for (int currentPage = 0; currentPage < pageCount; currentPage++) {
      pdf.addPage(
        pw.MultiPage(
          build: (context) {
            // Calculate the start and end index for the current page
            int startIndex = currentPage * rowsPerPage;
            int endIndex = (currentPage + 1) * rowsPerPage;

            // Ensure endIndex doesn't exceed the total number of rows
            endIndex = endIndex > _allResults.length ? _allResults.length : endIndex;

            // Subset of data for the current page
            List currentPageData = _allResults.sublist(startIndex, endIndex);

            // Table contents column widths
            Map<int, pw.TableColumnWidth> customColumnWidths = {
              0: const pw.FixedColumnWidth(30.0), // 'No' column
              1: const pw.FixedColumnWidth(55.0), // 'Nama' column
              2: const pw.FixedColumnWidth(42.0), // 'stok' column
              3: const pw.FixedColumnWidth(40.0), // 'Satuan' column
              4: const pw.FixedColumnWidth(53.0), // 'Jenis Barang' column
              5: const pw.FixedColumnWidth(60.0), // 'Tanggal' column
              6: const pw.FixedColumnWidth(60.0), // 'Perolehan' column
              // Add more fields and their corresponding widths
            };

            return [
              pw.Column(
                  children: [
                    //logos, titles
                    if(currentPage == 0) ...[
                      pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Row(
                            children: [
                              pw.Image(
                                  pw.MemoryImage(imageData),
                                  height: 70,
                                  width: 70
                              ),
                              pw.SizedBox(width: 20),
                              pw.Column(
                                  children: [
                                    pw.SizedBox(height: 20),
                                    pw.Text(
                                      'PEMERINTAH KABUPATEN MALANG',
                                      style: pw.TextStyle(fontSize: 16.5, fontWeight: pw.FontWeight.normal),
                                    ),
                                    pw.Text(
                                      'BADAN PENANGGULANGAN BENCANA DAERAH',
                                      style: pw.TextStyle(fontSize: 16.5, fontWeight: pw.FontWeight.bold),
                                    ),
                                    pw.Text(
                                      'Jl. Trunojoyo Kav.8 Telp. (0341) 392220 fax. (0341) 392121 Kepanjen',
                                      style: pw.TextStyle(fontSize: 12, fontStyle: pw.FontStyle.normal),
                                    ),
                                    pw.Text(
                                      'Website : http://www.malangkab.go.id Email: bpbdkabupatenmalang@yahoo.co.id',
                                      style: pw.TextStyle(fontSize: 9, fontStyle: pw.FontStyle.italic),
                                    ),
                                    pw.Text(
                                      'KEPANJEN - 65163',
                                      style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
                                    ),
                                  ]
                              ),
                              pw.SizedBox(width: 20),
                            ],
                          ),
                          pw.Divider(thickness: 1),
                          pw.SizedBox(height: 20),
                          pw.Column(
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
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                          ),
                        ],
                      ),
                    ],

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
                                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                                  textAlign: pw.TextAlign.center
                              ),
                            );
                          }).toList(),
                        ),

                        // Data rows
                        ...currentPageData.asMap().entries.map((entry) {
                          int index = entry.key;
                          Map<String, dynamic> row = entry.value;

                          DateTime expiryDate = (row['Tanggal Kadaluarsa']).toDate();
                          String formattedExpiryDate = DateFormat('EEEE, d MMMM yyyy').format(expiryDate);

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
                                final formattedValue = fieldValue is num ? fieldValue.toInt().toString() : fieldValue.toString();

                                return pw.Padding(
                                  padding: const pw.EdgeInsets.all(8),
                                  child: pw.Text(formattedValue, textAlign: pw.TextAlign.center),
                                );
                              }).toList(),
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(8),
                                child: pw.Text(formattedExpiryDate, textAlign: pw.TextAlign.center),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(8),
                                child: pw.Text(row['Asal Perolehan'], textAlign: pw.TextAlign.center),
                              ),
                            ],
                          );
                        }).toList(),
                      ],
                    ),
                  ]
              )
            ];
          },
        ),
      );
    }

    // Save the PDF to Documents directory
    final output = await getApplicationDocumentsDirectory();
    final file = File("${output.path}/Laporan Logistik Masuk.pdf");

    final bytes = await pdf.save(); // Await here to get the actual bytes

    await file.writeAsBytes(bytes);

    final pdfPinchController = PdfControllerPinch(
      document: PdfDocument.openFile(file.path),
    );

    if(context.mounted){
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 400,
              child: PdfViewPinch(controller: pdfPinchController,),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Tutup Pratinjau'),
              ),
              TextButton(
                onPressed: () {
                  Get.back();// Close the preview
                  // Share the PDF file
                  Share.shareFiles([file.path]);
                },
                child: const Text('Bagikan'),
              ),
            ],
          );
        },
      );
    }
  }

  void _showFilterPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Kategori'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0), // Adjust the value as needed
              ),
              content: _buildFilterContents(setState),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedFilterOption.clear();
                    });
                    debugPrint('Selected options: $_selectedFilterOption');
                  },
                  child: Text(
                    'Hapus',
                    style: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                      fontSize:14,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: (){
                    setState(() {
                      getRecords();
                      _shouldUpdateSortButtonColor = true;
                      _updateSortButtonColor();
                    });
                    Get.back();
                    debugPrint('Selected options: $_selectedFilterOption');
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: taAccentColor,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      )
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
                const SizedBox(width: 5,)
              ],
            );
          },
        );
      },
    );
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

  Widget _buildFilterContents(StateSetter setState) {
    return Wrap(
      spacing: 8.0,
      children: [
        for (String option in _filterOptions)
          FilterChip(
            label: Text(
              option,
              style: TextStyle(
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
    );
  }


}