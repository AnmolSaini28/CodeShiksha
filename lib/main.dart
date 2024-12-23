import 'package:codequest/Authentication%20Page/auth_page.dart';
import 'package:codequest/Drawer.dart';
import 'package:codequest/HomePage/HomePage.dart';
import 'package:codequest/Intro_Screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'splash_screen',
      routes: {
        'splash_screen': (context) => const Splash(),
        'Auth': (context) => const Auth(),
        'otp_screen': (context) => const HomePage(),
        'Drawer': (context) => const SliderMenu(),
      },
    );
  }
}
