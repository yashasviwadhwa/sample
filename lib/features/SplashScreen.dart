import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sample_page/features/Login.dart';
import 'package:sample_page/features/homeScreen.dart';
import 'package:sample_page/features/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    // Wait for at least 2-3 seconds so users see your logo
    await Future.delayed(const Duration(seconds: 3));

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isFirstTime = prefs.getBool('is_first_time') ?? true;
    final String? token = prefs.getString('user_token');

    if (!mounted) return;

    Widget nextScreen;
    if (isFirstTime) {
      nextScreen = const OnboardingScreen();
    } else if (token != null && token.isNotEmpty) {
      nextScreen = const HomeScreen();
    } else {
      nextScreen = LoginPage();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => nextScreen),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl:
                  "https://images.unsplash.com/photo-1646888754879-5350aecac0f8?w=600&auto=format&fit=crop&q=60",
              fit: BoxFit.cover,
            ),
          ),
          // Dark Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.3),
                    Colors.black.withValues(alpha: 0.7),
                  ],
                ),
              ),
            ),
          ),
          // Animated Logo Content
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 120.h,
                    width: 120.h,
                    decoration: const BoxDecoration(
                      color: Colors.white, // Background to make the logo visible
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(20.w),
                    child: Image.network(
                      "https://img.freepik.com/premium-vector/frm-letter-logo-design-technology-company-frm-logo-design-black-white-color-combination-frm-logo-frm-vector-frm-design-frm-icon-frm-alphabet-frm-typography-logo-design_229120-149924.jpg",
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    "FRM TECH",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "Innovating the Future",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14.sp,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Bottom Loader
          Positioned(
            bottom: 60.h,
            left: 0,
            right: 0,
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                strokeWidth: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}