import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      //  duration: const Duration(seconds: 10),
    );
    //..forward();
  }

  //dispose the controller

  @override
  void dispose() {
    super.dispose();

    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,

            child: Container(
              color: Color(0xFFFF7A00),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                        'assets/images/maps_animation.json',
                        controller: _controller,
                        repeat: true,

                        height: 200,
                        width: 200,
                        onLoaded: (composition) {
                          _controller
                            ..duration = composition.duration
                            ..repeat();
                        },
                      ),
                  
                    const SizedBox(height: 8),
                    Text(
                      'WanderAI',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Smarter Travel Starts Here',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'AI-powered itineraries at your fingertips.',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            flex: 1,

            child: Container(
              padding: const EdgeInsets.all(24),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => context.push('/plan-trip-screen'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00A3FF),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 56),
                    ),
                    child: const Text('Get Started'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE0F7FF),
                      foregroundColor: const Color(0xFF00A3FF),
                      minimumSize: const Size(double.infinity, 56),
                    ),
                    child: const Text('Log In'),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          // App Name
          // const Text(
          //   'My Awesome App',
          //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          // ),
          // const SizedBox(height: 10),
          // Loading Indicator
          // const CircularProgressIndicator(),
        ],
      ),
    );
  }
}
