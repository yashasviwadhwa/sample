// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final IconData? prefixIcon;
  final Widget? suffix;
  final bool isPassword;

  const MyTextFormField({
    super.key,
    this.controller,
    required this.hintText,
    this.prefixIcon,
    this.suffix,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, size: 20.sp, color: const Color(0xff261C12))
            : null,
        suffixIcon: suffix != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 16.w),
                    child: suffix,
                  ),
                ],
              )
            : null,
        hintText: hintText,
        hintStyle: GoogleFonts.beVietnamPro(
          fontWeight: FontWeight.w400,
          color: const Color(0x4D000000),
          fontSize: 14.sp,
        ),
        filled: true,
        fillColor: const Color(0xffeeedec),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  final String text;
  final Color  color;
  
  final void Function()? onTap;
    const MyButton({
       this.onTap,
    super.key,
    required this.text,
    this.color=const Color(0xffd5715b),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
        backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.r),
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          style: GoogleFonts.beVietnamPro(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 18.sp,
          ),
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String imagePath;
  final VoidCallback onTap;

  const CustomButton({super.key, required this.imagePath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30.r),
      child: Container(
        height: 52.h,
        width: 96.w,
        decoration: BoxDecoration(
          
          border: Border.all(color: Colors.grey.shade300, width: 1.w),
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: Center(
          child: Image.asset( 
            imagePath,
            width: 24.w,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons. beach_access),
          ),
        ),
      ),
    );
  }
}


  

  class MyDropdownField extends StatelessWidget {
  final String hintText;
  final List<String> items;
  final String? value;
  final Function(String?) onChanged;

  const MyDropdownField({
    Key? key,
    required this.hintText,
    required this.items,
    this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item, style: GoogleFonts.beVietnamPro(fontSize: 14.sp)),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.beVietnamPro(color: Colors.grey, fontSize: 14.sp),
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide.none,
        ),
      ),
      icon: const Icon(Icons.keyboard_arrow_down),
    );
  }
}