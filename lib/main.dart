// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sample_page/features/ForgetPassword.dart';
import 'package:sample_page/features/Login.dart';
import 'package:sample_page/features/ResetPassword.dart';
import 'package:sample_page/features/SignupScreen.dart';
import 'package:sample_page/features/SplashScreen.dart';
import 'package:sample_page/features/common/cutom_widget.dart';
import 'package:sample_page/features/onboarding_screen.dart';
import 'package:sample_page/features/verifyOtp.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false, 
          title: 'FarmerEats',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xffd5715b)),
            useMaterial3: true,
          ),
          home: VerifyOtp(),
        );
      },
    );
  }
}

