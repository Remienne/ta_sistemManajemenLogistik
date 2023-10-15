import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:the_app/constants/colors.dart';
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

  @override
  void initState() {
    super.initState();
    getRecords();
    _searchController.addListener(_onSearchChanged);
    // Your initialization code here
  }

  getRecords()async{
    var data = await FirebaseFirestore
        .instance
        .collection('logistics')
        .get();
    setState(() {
      _allResults = data.docs;
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
                padding: const EdgeInsets.only(top: 25, left: 15, right: 15, bottom: 20),
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
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.sort),
                      ),
                    ),
                  ],
                ),
              ),
              // item list
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: ListView.builder(
                      itemCount: _resultList.length,
                      itemBuilder: (c, index) {
                        DateTime date = (_resultList[index]['Tanggal Kadaluarsa']).toDate();
                        String formatted = DateFormat('EEEE, d MMMM yyyy').format(date);
                        return Card(
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
                                            child: FadeInImage.assetNetwork(
                                              placeholder: 'assets/images/no-photo.png',
                                              image: _resultList[index]['Link Gambar'],
                                              imageErrorBuilder: (context, error, stackTrace) =>
                                                  const Image(image: AssetImage('assets/images/no-photo.png'))
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
                        );
                      },
                    ),
                  )
              ),
            ],
          ),
          //fab
          Positioned(
            bottom: 16.0, // Adjust the position of the FAB as needed
            right: 16.0,
            child: FloatingActionButton(
                onPressed: () {
                  Get.off(() => const LogisticInput());
                },
                backgroundColor: taAccentColor,
                foregroundColor: Colors.white,
                child: Transform.scale(
                  scale: 1.2,
                  child: const Icon(Icons.add),
                )
            ),
          )
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
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