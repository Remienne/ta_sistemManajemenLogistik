import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_app/constants/colors.dart';
import 'package:the_app/constants/img_path.dart';
import 'package:the_app/repositories/authentication_repository.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _loading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  AuthenticationRepository authController = AuthenticationRepository.instance;

  handleSubmit() async{
    if(!_formKey.currentState!.validate()) return;

    final email = _email.value.text;
    final password = _password.value.text;

    setState(() => _loading = true);
    await authController.login(email, password);
    setState(() => _loading = false);
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    var vanish = MediaQuery.of(context).viewInsets.bottom == 0;

    return Scaffold(
        resizeToAvoidBottomInset : true,
        backgroundColor: taPrimaryColor,
        body: Stack(
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Your app logo here
                        const Image(
                          alignment: Alignment.center,
                          image: AssetImage(taSplashImage),
                          width: 100,
                          height: 100,
                        ),

                        const SizedBox(width: 20),

                        // Your app title here
                        Text(
                          'BPBD \nKABUPATEN MALANG',
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: screenHeight * 0.45,
                      margin: EdgeInsets.only(top: vanish ? screenHeight * 0.18 : screenHeight * 0.05),
                      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 40),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  margin: EdgeInsets.only(
                                      bottom: screenHeight * 0.03,
                                      left: screenWidth * 0.02
                                  ),
                                  child: Text(
                                    'Login',
                                    style: GoogleFonts.poppins(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                )
                            ),

                            // Username input field
                            TextFormField(
                              controller: _email,
                              validator: (value){
                                if (value == null || value.isEmpty){
                                  return 'Masukkan Email Anda!';
                                }
                                return null;
                              },
                              style: GoogleFonts.roboto(fontSize: 18,),
                              decoration: const InputDecoration(
                                hintText: 'Username',
                                contentPadding: EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 20),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(15)),
                                    borderSide: BorderSide(
                                        width: 1.5,
                                        color: Colors.black
                                    )
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Password input field
                            TextFormField(
                              controller: _password,
                              obscureText: true,
                              style: GoogleFonts.roboto(fontSize: 18,),
                              decoration: const InputDecoration(
                                hintText: 'Password',
                                contentPadding: EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 20),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(15)),
                                    borderSide: BorderSide(
                                        width: 1.5,
                                        color: Colors.black
                                    )
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Login button
                            SizedBox(
                              width:double.infinity, //width of button equal to parent widget
                              child:ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 20),
                                    backgroundColor: taAccentColor,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                    )
                                ),
                                onPressed: () => handleSubmit(),
                                child: _loading
                                ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                : Text(
                                  'Masuk',
                                  style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      color: Colors.white
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ),
                  ]
              ),
            ),
          ],
        )
    );
  }
}