import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sample_page/features/ApiService/ApiService.dart';
import 'package:sample_page/features/Login.dart';
import 'package:sample_page/features/common/cutom_widget.dart';
import 'package:sample_page/features/verifyOtp.dart';

class ForgetPassword extends StatelessWidget {
  ForgetPassword({Key? key}) : super(key: key);

  final TextEditingController phone = TextEditingController();

final  ApiService _apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "FarmerEats",
          style: GoogleFonts.beVietnamPro(
            fontWeight: .w400,
            color: const Color(0xff000000),
            fontSize: 16.sp,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            SizedBox(height: 60.h),
            Text(
              "Forgot Password?",
              style: GoogleFonts.beVietnamPro(
                fontWeight: .w700,
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
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                  ),
                ],
              ),
            ),

            SizedBox(height: 72.h),

            MyTextFormField(
              controller: phone,
              hintText: 'Phone Number',
              prefixIcon: Icons.phone_outlined,
            ),

            SizedBox(height: 32.h),

            MyButton(
              text: "Send  Code",
              color: Color(0xffd5715b),
              onTap: () async {
                // if (!phone.text.trim().startsWith("+")) {

                // }
                String phoness = "+${phone.text.trim()}";
                print("phoness $phoness");

               
                final value = await _apiService.phoneNumberExist(
                  MobileNumber: phoness,
                );

                if (value["success"] == true) {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (context) => VerifyOtp()));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(value["message"] ?? "error ")),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
