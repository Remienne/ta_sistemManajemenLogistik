import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_app/features/logisticMain/views/logistic_input.dart';
import 'package:the_app/utils/theme/theme.dart';
import 'features/authentication/views/login_page.dart';
import 'features/logisticMain/views/logistic_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      // home: StreamBuilder<User?>(
      //   stream: FirebaseAuth.instance.authStateChanges(),
      //   builder: (context, snapshot){
      //     if (snapshot.hasData){
      //       return LogisticPage();
      //     }else {
      //       return const LoginPage();
      //     }
      //   },
      // ),
      // home: LogisticPage(),
      initialRoute: LogisticPage.routeName,
      routes: {
        LoginPage.routeName: (context) => const LoginPage(),
        LogisticPage.routeName: (context) => LogisticPage(),
        LogisticInput.routeName: (context) => const LogisticInput(),
      },
    );
  }
}

