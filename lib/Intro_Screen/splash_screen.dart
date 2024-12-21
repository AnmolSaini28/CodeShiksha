import 'package:codequest/Authentication%20Page/auth_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  static const String Home = 'otp_screen';
  static const String Auth = 'Auth';

  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    // Create the animation
    _animation = Tween<double>(begin: -10.0, end: 10.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Check if the user is opening the app for the first time
    _checkFirstTimeUser();
  }

  Future<void> _checkFirstTimeUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Get the value of 'isFirstTime' or default to true
    bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

    // Delay for 3 seconds and navigate
    Future.delayed(const Duration(seconds: 10), () {
      if (isFirstTime) {
        Navigator.pushReplacementNamed(context, Splash.Auth);
        prefs.setBool('isFirstTime', false);
      } else {
        Navigator.pushReplacementNamed(context, Splash.Home);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.black, Colors.black87, Colors.black38],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 50),
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0.0, _animation.value),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/image1.png',
                        height: 300,
                        width: 300,
                      ),
                      Image.asset(
                        'assets/image2.png',
                        height: 300,
                        width: 300,
                      ),
                    ],
                  ),
                );
              },
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60),
                  topRight: Radius.circular(60),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Discover The Best Coding Booster Partner🌋",
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Deep Dive into the heart of Problem Solving",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, Splash.Auth);
                      },
                      child: Text(
                        "Explore Now 🚀",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
