import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:the_app/constants/colors.dart';
import 'package:the_app/constants/img_path.dart';
import 'package:the_app/repositories/authentication_repository.dart';

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
            onPressed: () => Alert(
              context: context,
              type: AlertType.warning,
              title: "PERINGATAN!",
              desc: "Apakah anda yakin ingin logout?",
              buttons: [
                DialogButton(
                  onPressed: () {
                    AuthenticationRepository().logout();
                  },
                  color: taPrimaryColor,
                  child: const Text(
                    "Ya",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                DialogButton(
                  onPressed: () => Get.back(),
                  color: Colors.white,
                  child: const Text(
                    "Tidak",
                    style: TextStyle(color: taPrimaryColor),
                  ),
                ),
              ],
            ).show(),
            icon: const Icon(Icons.logout, color: Colors.white,),
          )
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