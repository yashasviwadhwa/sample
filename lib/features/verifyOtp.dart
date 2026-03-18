import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:sample_page/features/ApiService/ApiService.dart';
import 'package:sample_page/features/Login.dart';
import 'package:sample_page/features/ResetPassword.dart';
import 'package:sample_page/features/common/cutom_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyOtp extends StatelessWidget {
  VerifyOtp({Key? key}) : super(key: key);

  final ApiService _apiService = ApiService();
  final TextEditingController _pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56.w,
      height: 50.h,
      textStyle: GoogleFonts.beVietnamPro(
        fontSize: 22.sp,
        color: const Color(0xff261C12),
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: const Color(0xffeeedec),
        borderRadius: BorderRadius.circular(8.r),
      ),
    );

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
              "Verify OTP",
              style: GoogleFonts.beVietnamPro(
                fontWeight: FontWeight.w700,
                fontSize: 32.sp,
                color: const Color(0xff261C12),
              ),
            ),
            SizedBox(height: 24.h),
            RichText(
              text: TextSpan(
                text: "Remember your pasword?",
                style: GoogleFonts.beVietnamPro(
                  fontWeight: FontWeight.w500,
                  color: const Color(0xffb3b3b3),
                  fontSize: 14.sp,
                ),
                children: [
                  TextSpan(
                    text: " Login",
                    style: GoogleFonts.beVietnamPro(
                      fontWeight: FontWeight.w500,
                      color: const Color(0xffd5715b),
                      fontSize: 14.sp,
                    ),
                     recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      }
                  ),
                ],
              ),
            ),
            SizedBox(height: 72.h),
            Center(
              child: Pinput(
                length: 5,
                controller: _pinController,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    border: Border.all(color: Colors.blue),
                  ),
                ),
                errorPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    border: Border.all(color: Colors.red),
                  ),
                ),
                onCompleted: (pin) => debugPrint(pin),
              ),
            ),
            SizedBox(height: 32.h),
            MyButton(
              text: "Submit",
              onTap: () async {
                final otp = _pinController.text;
                if (otp.isEmpty) {
                  return ;
                }
                final result = await _apiService.verifyOtp(otp: otp);

                if (result['success'] == "true") {
                  final SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.setString('user_token', result['token'].toString    ());

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      width: 250.w,
                      behavior: SnackBarBehavior.floating,
                      content: Text(result["message"]),
                    ),
                  );

                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ResetPassword()));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      width: 100.w,
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.red,
                      content: Text(result["message"] ?? "Invalid OTP"),
                    ),
                  );
                }
              },
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {},
                  child: Text(
                    "Resend Code",
                    style: GoogleFonts.beVietnamPro(
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff000000),
                      fontSize: 14.sp,
                      decoration: TextDecoration.underline,
                      decorationColor: const Color(0xff000000),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}