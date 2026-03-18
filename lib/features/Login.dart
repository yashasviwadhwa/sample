import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sample_page/features/ApiService/ApiService.dart';
import 'package:sample_page/features/ForgetPassword.dart';
import 'package:sample_page/features/SignupScreen.dart';
import 'package:sample_page/features/common/cutom_widget.dart';
import 'package:sample_page/features/homeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService _apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "FarmerEats",
          style: GoogleFonts.beVietnamPro(
            fontWeight: FontWeight.w400,
            color: const Color(0xff000000),
            fontSize: 16.sp,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 60.h),
            Text(
              "Welcome back!",
              style: GoogleFonts.beVietnamPro(
                fontWeight: FontWeight.w700,
                fontSize: 32.sp,
                color: const Color(0xff261C12),
              ),
            ),
            SizedBox(height: 24.h),
            RichText(
              text: TextSpan(
                text: "New here? ",
                style: GoogleFonts.beVietnamPro(
                  fontWeight: FontWeight.w500,
                  color: const Color(0xffb3b3b3),
                  fontSize: 14.sp,
                ),
                children: [
                  TextSpan(
                    text: "Create Account",
                    style: GoogleFonts.beVietnamPro(
                      fontWeight: FontWeight.w500,
                      color: const Color(0xffd5715b),
                      fontSize: 14.sp,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MultiStepSignup(),
                          ),
                        );
                      },
                  ),
                ],
              ),
            ),
            SizedBox(height: 72.h),

            MyTextFormField(
              controller: _emailController,
              hintText: 'Email Address',
              prefixIcon: Icons.alternate_email_outlined,
            ),

            SizedBox(height: 24.h),

            MyTextFormField(
              controller: _passwordController,
              hintText: 'Password',
              prefixIcon: Icons.lock_outline,
              isPassword: true,
              suffix: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => ForgetPassword()),
                  );
                },
                child: Text(
                  "Forgot? ",
                  style: GoogleFonts.beVietnamPro(
                    color: const Color(0xffd5715b),
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),

            SizedBox(height: 32.h),

            MyButton(
              text: "Login",
              onTap: () async {
                final result = await _apiService.loginFarmer(
                  email: _emailController.text.trim(),
                  password: _passwordController.text.trim(),
                  deviceToken: "0imfnc8mVLWwsAawjYr4Rx-Af50DDqtlx",
                  socialId: "0imfnc8mVLWwsAawjYr4Rx-Af50DDqtlx",
                );

                if (result['success'] == true) {
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();

                  await prefs.setString('user_token', result['token']);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      width: 230.w,
                      behavior: SnackBarBehavior.floating,
                      content: Text(result["message"]),
                    ),
                  );
                  Navigator.push(context,MaterialPageRoute(builder: (context)=>HomeScreen()));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      width: 250.w,
                      behavior: SnackBarBehavior.floating,
                      content: Text(result['message'] ?? "Login failed"),
                    ),
                  );
                }
              },
            ),

            SizedBox(height: 22.h),
            Center(
              child: Text(
                "or Login With",
                style: GoogleFonts.beVietnamPro(
                  fontWeight: FontWeight.w500,
                  color: const Color(0x4D261C12),
                  fontSize: 12.sp,
                ),
              ),
            ),
            SizedBox(height: 32.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButton(
                  imagePath: "assets/Images/google.png",
                  onTap: () async {
                    final result = await _apiService.loginFarmer(
                      email: "johndoe@mail.com",
                      password: "12345678",
                      deviceToken: "0imfnc8mVLWwsAawjYr4Rx-Af50DDqtlx",
                      socialId: "0imfnc8mVLWwsAawjYr4Rx-Af50DDqtlx",
                      type: "google",
                    );

                    if (result['success'] == true) {
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();

                      await prefs.setString('user_token', result['token']);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          width: 230.w,
                          behavior: SnackBarBehavior.floating,
                          content: Text(result["message"]),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          width: 250.w,
                          behavior: SnackBarBehavior.floating,
                          content: Text(result['message'] ?? "Login failed"),
                        ),
                      );
                    }
                  },
                ),
                CustomButton(
                  imagePath: "assets/Images/apple.png",
                  onTap: () async {
                    final result = await _apiService.loginFarmer(
                       email: "johndoe@mail.com",
                      password: "12345678",
                      deviceToken: "0imfnc8mVLWwsAawjYr4Rx-Af50DDqtlx",
                      socialId: "0imfnc8mVLWwsAawjYr4Rx-Af50DDqtlx",
                      type: "apple",
                    );

                    if (result['success'] == true) {
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();

                      await prefs.setString('user_token', result['token']);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          width: 230.w,
                          behavior: SnackBarBehavior.floating,
                          content: Text(result["message"]),
                        ),
                      );

                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          width: 250.w,
                          behavior: SnackBarBehavior.floating,
                          content: Text(result['message'] ?? "Login failed"),
                        ),
                      );
                    }
                  },
                ),
                CustomButton(
                  imagePath: "assets/Images/facebook.png",
                  onTap: () async {
                    final result = await _apiService.loginFarmer(
                    email: "johndoe@mail.com",
                      password: "12345678",
                      deviceToken: "0imfnc8mVLWwsAawjYr4Rx-Af50DDqtlx",
                      socialId: "0imfnc8mVLWwsAawjYr4Rx-Af50DDqtlx",
                      type: "facebook",
                    );
                    if (result['success'] == true) {
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();

                      await prefs.setString('user_token', result['token']);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          width: 230.w,
                          behavior: SnackBarBehavior.floating,
                          content: Text(result["message"]),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          width: 250.w,
                          behavior: SnackBarBehavior.floating,
                          content: Text(result['message'] ?? "Login failed"),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
