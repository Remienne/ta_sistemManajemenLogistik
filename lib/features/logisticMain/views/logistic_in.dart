import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:the_app/constants/colors.dart';
import 'package:the_app/features/logisticMain/views/logistic_details_page.dart';
import 'package:the_app/features/pdfReport/show_report.dart';
import 'logistic_input.dart';

class LogisticIn extends StatefulWidget {
  const LogisticIn({super.key});

  @override
  State<LogisticIn> createState() => _LogisticInState();
}

class _LogisticInState extends State<LogisticIn> {
  final TextEditingController _searchController = TextEditingController();

  List _allResults =[];

  List _resultList =[];

  List<String> _filterOptions = []; // catch from firebase

  final List<String> _selectedFilterOption = []; // New variable for selected filter option

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getRecords();
    _searchController.addListener(_onSearchChanged);
  }

  getRecords()async{
    setState(() {
      _isLoading = true;
    });

    Query<Map<String, dynamic>> query = FirebaseFirestore.instance.collection('logistics');

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

    var logisticData = await query
        .orderBy('Tanggal Kadaluarsa')
        .get();

    List<Map<String, dynamic>> logisticResults = [];
    for (var doc in logisticData.docs) {
      logisticResults.add(doc.data());
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Your code when dependencies change
  }

  @override
  void dispose() {
    // Your cleanup code here
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

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
                          color: _selectedFilterOption == [] ? taAccentColor : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.sort, color: _selectedFilterOption == [] ? Colors.white : Colors.black),
                      ),
                    ),
                  ],
                ),
              ),

              // item list
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
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
              Get.off(() => ShowReport());
            },
          ),
        ],
      ),
    );
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
              content: _buildFilterChips(setState),
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

  Widget _buildFilterChips(StateSetter setState) {
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