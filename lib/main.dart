import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:the_app/repositories/authentication_repository.dart';
import 'package:the_app/utils/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp().then((value) {
    Get.put(AuthenticationRepository());
  });

  await initializeDateFormatting('id_ID', null);

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      themeMode: ThemeMode.light,
      theme: TheAppTheme.lightTheme,
      darkTheme: TheAppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: const CircularProgressIndicator(),
    );
  }
}

