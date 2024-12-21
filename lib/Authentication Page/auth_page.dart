import 'package:codequest/HomePage/HomePage.dart';
import 'package:codequest/Intro_Screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:email_otp/email_otp.dart';
import 'package:pinput/pinput.dart';
import '../Animation/FadeAnimation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth extends StatefulWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  Color myColor = const Color(0xffFFC3A6);
  EmailOTP myauth = EmailOTP();
  final TextEditingController email = TextEditingController();
  final TextEditingController _otpController1 = TextEditingController();
  final TextEditingController _otpController2 = TextEditingController();
  final TextEditingController _otpController3 = TextEditingController();
  final TextEditingController _otpController4 = TextEditingController();

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign in with Google
  Future<User?> _signInWithGoogle() async {
    try {
      // Trigger the Google sign-in flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in
        return null;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      return userCredential.user;
    } catch (e) {
      print("Error signing in with Google: $e");
      return null;
    }
  }

  // Sign out from Google
  Future<void> _signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 72,
      height: 72,
      textStyle: const TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade400),
      ),
    );
    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(
        color: const Color(0xFF0B2B4F),
      ),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 30),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              // colors: [myColor, Colors.purple.shade200],
              colors: [Colors.black, Colors.black87, Colors.black38]),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 50),
            FadeInUp(
              duration: const Duration(milliseconds: 1000),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Register Yourself",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                              color: Colors.white, fontSize: 32),
                        )),
                    const SizedBox(
                      height: 5,
                    ),
                    Text("Welcome Back ",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                              color: Colors.white, fontSize: 22),
                        )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: FadeInUp(
                        duration: const Duration(milliseconds: 1200),
                        child: Column(
                          children: <Widget>[
                            const SizedBox(height: 15),
                            Text(
                              "We need to verify you before getting started !",
                              style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              )),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            FadeInUp(
                              duration: const Duration(milliseconds: 1400),
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      child: TextField(
                                        controller:
                                            email, // Assuming you have defined this TextEditingController
                                        keyboardType: TextInputType
                                            .emailAddress, // Email-specific keyboard
                                        decoration: InputDecoration(
                                          labelText: "Email",
                                          labelStyle: const TextStyle(
                                              color: Colors
                                                  .black), // Label color customization
                                          hintText: "Enter Email Address",
                                          hintStyle: const TextStyle(
                                              color: Colors.grey),
                                          prefixIcon: const Icon(Icons.email,
                                              color: Colors
                                                  .black), // Prefix email icon
                                          suffixIcon: IconButton(
                                            onPressed: () async {
                                              // Add your OTP logic here
                                              /* Example:
          myauth.setConfig(
            appEmail: "codequestcn@gmail.com",
            appName: "Email OTP",
            userEmail: email.text,
            otpLength: 4,
            otpType: OTPType.digitsOnly,
          );
          if (await myauth.sendOTP()) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("OTP has been sent")),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Oops, OTP send Failed")),
            );
          }
          */
                                            },
                                            icon: const Icon(Icons.send,
                                                color: Colors.black),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                10), // Rounded border
                                            borderSide: const BorderSide(
                                                color: Colors.black),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                                color: Colors.orange,
                                                width: 2), // Highlighted border
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                                color: Colors.red,
                                                width: 2), // Error border
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                                color: Colors.red, width: 2),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 40),
                                    /*Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 5),
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.grey),
                                              ),
                                            ),
                                            child: TextFormField(
                                              controller: _otpController1,
                                              keyboardType:
                                                  TextInputType.number,
                                              textAlign: TextAlign.center,
                                              maxLength: 1,
                                              onChanged: (value) {
                                                if (value.length == 1) {
                                                  FocusScope.of(context)
                                                      .nextFocus();
                                                }
                                                if (value.isEmpty) {
                                                  FocusScope.of(context)
                                                      .previousFocus();
                                                }
                                              },
                                              decoration: const InputDecoration(
                                                counterText:
                                                    "", // Hide character counter
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 5),
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.grey),
                                              ),
                                            ),
                                            child: TextFormField(
                                              controller: _otpController2,
                                              keyboardType:
                                                  TextInputType.number,
                                              textAlign: TextAlign.center,
                                              maxLength: 1,
                                              onChanged: (value) {
                                                if (value.length == 1) {
                                                  FocusScope.of(context)
                                                      .nextFocus();
                                                }
                                                if (value.isEmpty) {
                                                  FocusScope.of(context)
                                                      .previousFocus();
                                                }
                                              },
                                              decoration: const InputDecoration(
                                                counterText:
                                                    "", // Hide character counter
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 5),
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.grey),
                                              ),
                                            ),
                                            child: TextFormField(
                                              controller: _otpController3,
                                              keyboardType:
                                                  TextInputType.number,
                                              textAlign: TextAlign.center,
                                              maxLength: 1,
                                              onChanged: (value) {
                                                if (value.length == 1) {
                                                  FocusScope.of(context)
                                                      .nextFocus();
                                                }
                                                if (value.isEmpty) {
                                                  FocusScope.of(context)
                                                      .previousFocus();
                                                }
                                              },
                                              decoration: const InputDecoration(
                                                counterText:
                                                    "", // Hide character counter
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 5),
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.grey),
                                              ),
                                            ),
                                            child: TextFormField(
                                              controller: _otpController4,
                                              keyboardType:
                                                  TextInputType.number,
                                              textAlign: TextAlign.center,
                                              maxLength: 1,
                                              onChanged: (value) {
                                                if (value.length == 1) {
                                                  FocusScope.of(context)
                                                      .nextFocus();
                                                }
                                                if (value.isEmpty) {
                                                  FocusScope.of(context)
                                                      .previousFocus();
                                                }
                                              },
                                              decoration: const InputDecoration(
                                                counterText:
                                                    "", // Hide character counter
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ), */
                                    Pinput(
                                      controller: _otpController1,
                                      length: 4,
                                      defaultPinTheme: defaultPinTheme,
                                      focusedPinTheme: focusedPinTheme,
                                      submittedPinTheme: submittedPinTheme,
                                      onChanged: (value) {
                                        setState(() {});
                                      },
                                      onCompleted: (pin) {
                                        setState(() {});
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            FadeInUp(
                              duration: const Duration(milliseconds: 1600),
                              child: Container(
                                height: 50,
                                margin: const EdgeInsets.symmetric(),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.blue,
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, Splash.Auth);
                                    /*if (myauth.verifyOTP(otp: _otpController1.text +
                                        _otpController2.text +
                                        _otpController3.text +
                                        _otpController4.text) == true) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text("OTP is verified")),
                                      );
                                      // Navigate to the next screen or perform the desired action
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => HomePage(),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text("Invalid OTP"),
                                        ),
                                      );
                                    }*/
                                  },
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      backgroundColor: Colors.black,
                                      fixedSize: const Size(300, 30)),
                                  child: Text(
                                    "Verify OTP",
                                    style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    )),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            FadeInUp(
                              duration: const Duration(milliseconds: 1800),
                              child: Text("Continue with Social Media",
                                  style: GoogleFonts.poppins(
                                    textStyle:
                                        const TextStyle(color: Colors.grey),
                                  )),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            FadeInUp(
                              duration: const Duration(milliseconds: 2000),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: Colors.black),
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          User? user =
                                              await _signInWithGoogle();
                                          if (user != null) {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const HomePage(),
                                              ),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content: Text(
                                                      "Google Sign-In failed")),
                                            );
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            backgroundColor: Colors.black),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              'assets/google_logo.png',
                                              height: 20,
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              "Google",
                                              style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              )),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 30,
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          colors: [myColor, Colors.purple],
                                        ),
                                        color: Colors.black,
                                      ),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          // Add your button click logic here
                                        },
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            backgroundColor: Colors.black),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              'assets/github_lo.png',
                                              height: 28,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              "Github",
                                              style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              )),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
