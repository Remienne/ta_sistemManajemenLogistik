import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:the_app/constants/colors.dart';
import 'package:the_app/constants/img_path.dart';
import 'package:the_app/repositories/authentication_repository.dart';

import 'logisitc_help.dart';
import 'logistic_out.dart';
import 'logistic_in.dart';

int _selectedIndex = 0;

class LogisticMain extends StatefulWidget {
  const LogisticMain({super.key});

  @override
  State<LogisticMain> createState() => _LogisticMainState();
}

class _LogisticMainState extends State<LogisticMain> {


  final List<Widget> _pages = [
    const LogisticIn(),
    const LogisticOut(),
  ];

  @override
  void initState() {
    super.initState();
    DefaultCacheManager manager = DefaultCacheManager();
    manager.emptyCache(); //clears all data in cache.
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
          margin: EdgeInsets.only(left: screenWidth * 0.02),
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
          PopupMenuButton<String>(
            color: Colors.white,
            onSelected: (value) {
              if (value == 'logout') {
                Alert(
                  context: context,
                  type: AlertType.warning,
                  title: "PERINGATAN!",
                  desc: "Apakah anda yakin ingin keluar?",
                  buttons: [
                    DialogButton(
                      onPressed: () {
                        AuthenticationRepository().logout();
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
              else if (value == 'help') {
                // Navigate to help page
                Get.to(const LogisticHelp());
              }
              else if (value == 'about') {
                // Navigate to about page
                _showOptionsPopup(context);
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'logout',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.logout, color: Colors.grey.shade700,),
                      const SizedBox(width: 20,),
                      const Text('Keluar'),
                    ],
                  )
                ),
                PopupMenuItem<String>(
                  value: 'help',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.help, color: Colors.grey.shade700,),
                      const SizedBox(width: 20,),
                      const Text('Bantuan'),
                    ],
                  )
                ),
                PopupMenuItem<String>(
                  value: 'about',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.info, color: Colors.grey.shade700,),
                      const SizedBox(width: 20,),
                      const Text('Tentang'),
                    ],
                  )
                ),
              ];
            },
          ),
        ],
      ),

      backgroundColor: taBackgroundColor,

      body: _pages[_selectedIndex],

      bottomNavigationBar: CustomBottomNavigationBar(
        onTabSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  void _showOptionsPopup(BuildContext context) {
    Get.dialog(
        WillPopScope(
          onWillPop: () async => true,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Tentang',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Icon(Icons.info, size: 15, color: Colors.grey.shade700,),
                  ],
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0), // Adjust the value as needed
                ),
                content: Wrap(
                  spacing: 2,
                  children: [
                    //appname and spacings
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center ,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 10,)
                          ],
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center ,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'LogPal',
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Logistik & Peralatan',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Text(
                              'Versi 1.10.2',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center ,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 10,)
                          ],
                        )
                      ],
                    ),

                    //2 logos
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(taSubLogo, height: 80, width: 80),
                        Image.asset(taMainLogo, height: 80, width: 80)
                      ],
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center ,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 10,)
                          ],
                        )
                      ],
                    ),

                    //copyright
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center ,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '\u00a9 Muhammad Rizqy Mahardika',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.grey,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center ,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 10,)
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        Get.back();
                      });
                    },
                    child: Text(
                      'Tutup',
                      style: GoogleFonts.poppins(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.normal,
                        fontSize:14,
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

}

class CustomBottomNavigationBar extends StatelessWidget {
  final Function(int) onTabSelected;

  const CustomBottomNavigationBar({Key? key, required this.onTabSelected})
      : super(key: key);

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
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(inGrey, width: 30, height: 30,),
            activeIcon: Image.asset(inWhite, width: 35, height: 35,),
            label: 'Logistik Masuk',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(outGrey, width: 30, height: 30,),
            activeIcon: Image.asset(outWhite, width: 35, height: 35,),
            label: 'Logistik Keluar',
          ),
        ],
        selectedItemColor: Colors.white, // Customize selected item color
        unselectedItemColor: Colors.grey, // Customize unselected item color
        backgroundColor: Colors.transparent, // Make background transparent
        elevation: 0,
        currentIndex: _selectedIndex,
        onTap: onTabSelected,
      ),
    );
  }
}