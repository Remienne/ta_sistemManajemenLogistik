import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:the_app/constants/colors.dart';
import 'package:the_app/features/logisticMain/controllers/logistic_page_controller.dart';
import 'logistic_input.dart';

class LogisticPage extends StatelessWidget {
  static const routeName = '/logistic';
  LogisticPage({super.key});

  final TextEditingController _searchController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LogisticPageController());
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
              FutureBuilder(
                future: controller.getItemList(),
                builder: (context, snapshot){
                  if(snapshot.connectionState == ConnectionState.done){
                    if(snapshot.hasData){
                      return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (c, index) {
                                DateTime date = (snapshot.data![index].dateEnd).toDate();
                                String formatted = DateFormat('EEEE, d MMMM yyyy').format(date);
                                debugPrint(formatted);
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
                                                  child: Image.network(snapshot.data![index].imgPath,
                                                      errorBuilder: (context, error, stackTrace) {
                                                        return const Image(image: AssetImage('assets/images/no-photo.png'));
                                                      }
                                                  ),
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
                                                    snapshot.data![index].name,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: GoogleFonts.poppins(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize:18,
                                                    ),
                                                  ),
                                                  Text(
                                                    snapshot.data![index].category,
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
              )
            ],
          ),
          //fab
          Positioned(
            bottom: 16.0, // Adjust the position of the FAB as needed
            right: 16.0,
            child: FloatingActionButton(
              onPressed: () {
                if(context.mounted) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LogisticInput())
                  );
                }
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