import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_app/constants/colors.dart';
import 'package:the_app/constants/img_path.dart';
import 'package:the_app/constants/text_strings.dart';
import 'package:the_app/repositories/authentication_repository.dart';

class LoginPage extends StatefulWidget {
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

    final errorMessage = await authController.login(email, password);

    setState(() => _loading = false);

    if (errorMessage != null) {
      // Show a Snackbar with the error message
      Get.snackbar(
        "PERINGATAN!",
        errorMessage,
        duration: const Duration(milliseconds: 1500),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } else {
      // Successful login, navigate to the next screen
      await Future.delayed(const Duration(seconds: 1));
      // Navigate to the next screen
    }

    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    var vanish = MediaQuery.of(context).viewInsets.bottom == 0;
    AutovalidateMode autoValidateMode = AutovalidateMode.disabled;

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
                    //titles
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Your app logo here
                        const Image(
                          alignment: Alignment.center,
                          image: AssetImage(taMainLogo),
                          width: 100,
                          height: 100,
                        ),

                        const SizedBox(width: 20),

                        // Your app title here
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              taAppName,
                              style: GoogleFonts.montserrat(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              taAppDesc,
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    //form
                    Container(
                      height: screenHeight * 0.45,
                      margin: EdgeInsets.only(top: vanish ? screenHeight * 0.18 : screenHeight * 0.05),
                      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 26),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Form(
                        autovalidateMode: autoValidateMode,
                        key: _formKey,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
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
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      bottom: screenHeight * 0.03,
                                      right: screenWidth * 0.02
                                  ),
                                  child: Tooltip(
                                      textAlign: TextAlign.center,
                                      waitDuration: const Duration(seconds: 10),
                                      triggerMode: TooltipTriggerMode.tap,
                                      message: ''
                                          '\nApabila terjadi kendala dalam proses login,'
                                          '\nmohon cek kembali apakah internet'
                                          '\nsudah terhubung, lalu cek kembali '
                                          '\ninformasi akun login Anda.'
                                          '\nUntuk bantuan lebih mohon hubungi admin.'
                                          '\n',
                                      child:Icon(Icons.help, color: Colors.grey.shade700,),
                                  )
                                )

                              ],
                            ),
                            // Username input field
                            TextFormField(
                              controller: _email,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value){
                                if (value == null || value.isEmpty){
                                  return 'Masukkan email Anda!';
                                }
                                if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$').hasMatch(value)) {
                                  return 'Masukkan alamat email yang valid';
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
                              validator: (value){
                                if (value == null || value.isEmpty){
                                  return 'Masukkan password Anda!';
                                }
                                return null;
                              },
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
                                onPressed: () {
                                  autoValidateMode = AutovalidateMode.onUserInteraction;
                                  handleSubmit();
                                } ,
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
                            ),
                          ],
                        ),
                      )
                    ),
                    Container(
                      width: screenWidth,
                      decoration: BoxDecoration(
                        border: Border.all(width: 0, color: Colors.white),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          'Versi 1.9',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      )
                    )
                  ]
              ),
            ),
          ],
        )
    );
  }
}