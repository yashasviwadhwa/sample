import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sample_page/features/ApiService/ApiService.dart';
import 'package:sample_page/features/Login.dart';
import 'package:sample_page/features/common/cutom_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResetPassword extends StatelessWidget {
  ResetPassword({Key? key}) : super(key: key);

  final TextEditingController newer = TextEditingController();
  final TextEditingController old = TextEditingController();
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
              "Reset Password",
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
                      },
                  ),
                ],
              ),
            ),
            SizedBox(height: 72.h),
            MyTextFormField(
              controller: newer,
              hintText: 'New Password',
              prefixIcon: Icons.lock_outline,
              isPassword: true,
            ),
            SizedBox(height: 24.h),
            MyTextFormField(
              controller: old,
              hintText: 'Confirm New Password',
              prefixIcon: Icons.lock_outline,
              isPassword: true,
            ),
            SizedBox(height: 32.h),
            MyButton(
              text: "Submit",
              onTap: () async {
                final password = newer.text.trim();
                final cpassword = old.text.trim();
                if (password.isEmpty || cpassword.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please fill all fields")),
                  );
                  return;
                }

                if (password != cpassword) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Passwords do not match")),
                  );
                  return;
                }

                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                final String? savedToken = prefs.getString('user_token');

                print("savesasastoken $savedToken");

                final result = await _apiService.resetPassword(
                  token: savedToken ?? "",
                  password: password,
                  cpassword: cpassword,
                );

                if (result['success'] == "true") {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(result['message'])));
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (route) => false,
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(result['message'] ?? "Reset failed"),
                    ),
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
