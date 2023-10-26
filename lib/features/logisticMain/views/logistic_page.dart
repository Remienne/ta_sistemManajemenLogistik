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
import 'package:the_app/repositories/authentication_repository.dart';
import 'logistic_input.dart';

class LogisticPage extends StatefulWidget {
  static const routeName = '/logistic';
  const LogisticPage({super.key});

  @override
  State<LogisticPage> createState() => _LogisticPageState();
}

class _LogisticPageState extends State<LogisticPage> {
  final TextEditingController _searchController = TextEditingController();

  List _allResults =[];

  List _resultList =[];

  List<String> filterOptions = []; // Declare this outside your widget class

  String _selectedSortingOption = 'Default'; // New variable for selected sorting option
  bool _isFilterChipVisible = false; // New variable to control visibility

  @override
  void initState() {
    super.initState();
    getRecords();
    _searchController.addListener(_onSearchChanged);
  }

  getRecords()async{
    var logisticData = await FirebaseFirestore
        .instance
        .collection('logistics')
        .orderBy("Tanggal Kadaluarsa")
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
    filterOptions = uniqueCategories.toList();

    setState(() {
      _allResults = logisticResults;
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

    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
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
        actions: [
          IconButton(
            onPressed: () => AuthenticationRepository().logout(),
            icon: const Icon(Icons.logout),
          )
        ],
      ),

      backgroundColor: taBackgroundColor,

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
                        _toggleFilterChipVisibility();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _isFilterChipVisible ? taAccentColor : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.sort, color: _isFilterChipVisible ? Colors.white : Colors.black),
                      ),
                    ),
                  ],
                ),
              ),

              // FilterChips
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
                child: _isFilterChipVisible
                    ? Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 8),
                        child: Wrap(
                          spacing: 8.0, // Adjust spacing as needed
                          children: [
                            for (int i = 0; i < filterOptions.length; i++)
                              FilterChip(
                                label: Text(
                                  filterOptions[i],
                                  style: TextStyle(
                                    color: _selectedSortingOption == filterOptions[i] ? Colors.white : null,
                                  ),
                                ),
                                selected: _selectedSortingOption == filterOptions[i],
                                onSelected: (selected) {
                                  _updateSortingOption(filterOptions[i]);
                                },
                                backgroundColor: Colors.white,
                                selectedColor: taAccentColor,
                                checkmarkColor: _selectedSortingOption == filterOptions[i] ? Colors.white : null,
                              ),
                            if (filterOptions.isNotEmpty) // Ensure the list is not empty
                              IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _clearSortingOption();
                                },
                              ),
                          ],
                        ),
                      )
                    : Container(padding: const EdgeInsets.only(top: 20)),
              ),

              // item list
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: ListView.builder(
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
                        } else {
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
      bottomNavigationBar: const CustomBottomNavigationBar(),
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

  // Function to update the selected sorting option
  void _updateSortingOption(String option) {
    setState(() {
      _selectedSortingOption = option;
      // Call your sorting function here based on the selected option
      // sortData(option);
    });
  }

  void _clearSortingOption() {
    setState(() {
      _selectedSortingOption = 'Default';
    });
  }

  // Function to show the sorting options
  void _showSortingOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Sort By',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ListTile(
                title: const Text('Option 1'),
                onTap: () {
                  Navigator.pop(context);
                  _updateSortingOption('Option 1');
                },
              ),
              ListTile(
                title: const Text('Option 2'),
                onTap: () {
                  Navigator.pop(context);
                  _updateSortingOption('Option 2');
                },
              ),
              // Add more options as needed
            ],
          ),
        );
      },
    );
  }

  // Function to toggle FilterChip visibility
  void _toggleFilterChipVisibility() {
    setState(() {
      _isFilterChipVisible = !_isFilterChipVisible;
    });
  }

}

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return Container(
      height: screenHeight * 0.08,
      decoration: const BoxDecoration(
        color: taAccentColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      child: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.white, // Customize selected item color
        unselectedItemColor: Colors.grey, // Customize unselected item color
        backgroundColor: Colors.transparent, // Make background transparent
        elevation: 0,
      ),
    );
  }
}