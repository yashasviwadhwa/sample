import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sample_page/features/Login.dart';
import 'package:sample_page/features/common/cutom_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _pageCurrent = 0;

  final List<Map<String, dynamic>> data = [
    {
      "title": "Quality",
      "desc":
          "Sell your farm fresh products directly to consumers, cutting out the middleman and reducing emissions of the global supply chain.",
      "image": "assets/Images/Group_44.png",
      "color": const Color(0xff5ea25f),
    },
    {
      "title": "Convenient",
      "desc":
          "Our team of delivery drivers will make sure your orders are picked up on time and promptly delivered to your customers.",
      "image": "assets/Images/Group.png",
      "color": const Color(0xffd5715b),
    },
    {
      "title": "Local",
      "desc":
          "We love the earth and know you do too! Join us in reducing our local carbon footprint one order at a time.",
      "image": "assets/Images/Group_46.png",
      "color": const Color(0xfff8c569),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _controller,
        onPageChanged: (index) => setState(() {
          _pageCurrent = index;
        }),
        itemCount: data.length,
        itemBuilder: (context, index) => Stack(
          children: [
            Positioned.fill(child: Container(color: data[index]['color'])),
            Positioned(
              top: 32.h,
              left: -10.w,
              right: 0,
              child: Image.asset(
                data[index]['image'],
                height: 300.h,
                fit: BoxFit.contain,
              ),
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(bottom: 40.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(52.r),
                      topRight: Radius.circular(52.r),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 35.h),
                      Text(
                        data[index]['title'],
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff261C12),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.w),
                        child: Text(
                          data[index]['desc'],
                          textAlign: TextAlign.center,
                          style: GoogleFonts.beVietnamPro(
                            height: 1.6,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff261C12),
                          ),
                        ),
                      ),
                      SizedBox(height: 30.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(data.length, (dotIndex) {
                          bool isActive = _pageCurrent == dotIndex;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: EdgeInsets.symmetric(horizontal: 4.w),
                            height: 8.h,
                            width: isActive ? 18.w : 8.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: const Color(
                                0xff261C12,
                              ).withOpacity(isActive ? 1.0 : 0.2),
                            ),
                          );
                        }),
                      ),
                      SizedBox(height: 40.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30.w),
                        child: MyButton(
                          text: "Join the movement!",
                          color: data[index]['color'],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      InkWell(
                        onTap: () async {
                          final SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.setBool(
                            'is_first_time',
                            false,
                          ); // This is the key!

                          if (!context.mounted) return;
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        },
                        child: Text(
                          "Login",
                          style: GoogleFonts.beVietnamPro(
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                            color: const Color(0xff261C12),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
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
