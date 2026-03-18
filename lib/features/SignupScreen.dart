import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
// Note: Ensure these imports match your actual file structure
import 'package:sample_page/features/ApiService/ApiService.dart';
import 'package:sample_page/features/common/cutom_widget.dart';
import 'package:sample_page/features/Model/signUpmodel.dart';

class MultiStepSignup extends StatefulWidget {
  const MultiStepSignup({Key? key}) : super(key: key);

  @override
  State<MultiStepSignup> createState() => _MultiStepSignupState();
}

class _MultiStepSignupState extends State<MultiStepSignup> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 5;

  // Controllers - Grouped for easier management
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final businessNameController = TextEditingController();
  final informalNameController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final zipController = TextEditingController();

  bool isLoading = false;
  String? selectedState;
  File? _selectedFile;
  String activeDay = "M";

  final Map<String, List<String>> businessHours = {
    "M": [],
    "T": [],
    "W": [],
    "Th": [],
    "F": [],
    "S": [],
    "Su": [],
  };

  final List<String> statesList = [
    "New York",
    "California",
    "Florida",
    "Texas",
    "Washington",
  ];

  @override
  void dispose() {
    // ALWAYS dispose controllers to prevent memory leaks
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    businessNameController.dispose();
    informalNameController.dispose();
    addressController.dispose();
    cityController.dispose();
    zipController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  // ================= NAVIGATION =================

  void _nextPage() {
    if (_currentStep < _totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  // ================= LOGIC =================

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png', 'jpeg'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  // FIX: Using the Model factory we created instead of formatBusinessHours
  Future<void> _submitSignup() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Passwords do not match")));
      return;
    }

    setState(() => isLoading = true);

    try {
      final signupModel = SignupModel(
        fullName: fullNameController.text,
        email: emailController.text,
        phone: phoneController.text,
        password: passwordController.text,
        businessName: businessNameController.text,
        informalName: informalNameController.text,
        address: addressController.text,
        city: cityController.text,
        state: selectedState,
        zipCode: zipController.text,
        businessHours: BusinessHours.fromUiMap(businessHours),
        type: "email",
        socialId: "0imfnc8mVLWwsAawjYr4Rx-Af50DDqtlx", // Added here
        deviceToken: "0imfnc8mVLWwsAawjYr4Rx-Af50DDqtlx", // Also used here
      );

      bool success = await ApiService().registerFarmer(
        signupModel,
        _selectedFile,
      );

      if (success) {
        _nextPage();
      } else {
        throw Exception("Registration failed");
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  // ================= BUILDERS =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _currentStep < 4
          ? AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: false,
              title: Text(
                "FarmerEats",
                style: GoogleFonts.beVietnamPro(
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
            )
          : null,
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) => setState(() => _currentStep = index),
              children: [
                _buildStepOne(),
                _buildStepTwo(),
                _buildStepThree(),
                _buildStepFour(),
                _buildSuccessPage(),
              ],
            ),
          ),
          if (_currentStep < 4) _buildBottomNavigation(),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
        child: Row(
          children: [
            _currentStep == 0
                ? TextButton(
                    onPressed: _previousPage,
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  )
                : IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: _previousPage,
                  ),
            const Spacer(),
            SizedBox(
              width: 200.w,
              child: MyButton(
                text: _currentStep == 3
                    ? (isLoading ? "Please wait..." : "Signup")
                    : "Continue",
                onTap: () {
                  if (_currentStep == 3) {
                    if (!isLoading) _submitSignup();
                  } else {
                    _nextPage();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Step 1 & 2 use _formWrapper for consistency
  Widget _buildStepOne() => _formWrapper("Signup 1 of 4", "Welcome!", [
    MyTextFormField(controller: fullNameController, hintText: "Full Name"),
    MyTextFormField(controller: emailController, hintText: "Email Address"),
    MyTextFormField(controller: phoneController, hintText: "Phone Number"),
    MyTextFormField(
      controller: passwordController,
      hintText: "Password",
      isPassword: true,
    ),
    MyTextFormField(
      controller: confirmPasswordController,
      hintText: "Confirm Password",
      isPassword: true,
    ),
  ]);

  Widget _buildStepTwo() => _formWrapper("Signup 2 of 4", "Farm Info", [
    MyTextFormField(
      controller: businessNameController,
      hintText: "Business Name",
    ),
    MyTextFormField(
      controller: informalNameController,
      hintText: "Informal Name",
    ),
    MyTextFormField(controller: addressController, hintText: "Street Address"),
    MyTextFormField(controller: cityController, hintText: "City"),
    Row(
      children: [
        Expanded(
          child: MyDropdownField(
            hintText: "State",
            items: statesList,
            value: selectedState,
            onChanged: (val) => setState(() => selectedState = val),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: MyTextFormField(
            controller: zipController,
            hintText: "Zip Code",
          ),
        ),
      ],
    ),
  ]);

  Widget _buildStepThree() {
    return _formWrapper("Signup 3 of 4", "Verification", [
      const Text(
        "Attached proof of Department of Agriculture registrations i.e. Florida Fresh, USDA Approved, USDA Organic",
      ),
      SizedBox(height: 20.h),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Attach proof of registration",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          GestureDetector(
            onTap: _pickFile,
            child: const CircleAvatar(
              radius: 25,
              backgroundColor: Color(0xffD5715B),
              child: Icon(Icons.camera_alt, color: Colors.white),
            ),
          ),
        ],
      ),
      if (_selectedFile != null)
        Container(
          margin: EdgeInsets.only(top: 20.h),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            leading: const Icon(Icons.file_present),
            title: Text(
              _selectedFile!.path.split('/').last,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: () => setState(() => _selectedFile = null),
            ),
          ),
        ),
    ]);
  }

  Widget _buildStepFour() {
    List<String> times = [
      "8:00am - 10:00am",
      "10:00am - 1:00pm",
      "1:00pm - 4:00pm",
      "4:00pm - 7:00pm",
      "7:00pm - 10:00pm",
    ];

    return _formWrapper("Signup 4 of 4", "Business Hours", [
      Text(
        "Choose the hours your farm is open for pickups. This will allow customers to order deliveries.",
        style: TextStyle(fontSize: 14.sp, color: Colors.grey[600], height: 1.5),
      ),
      SizedBox(height: 30.h),

      // DAY SELECTOR: Ensuring they spread out evenly like the image
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: businessHours.keys.map((day) => _dayCircle(day)).toList(),
      ),

      SizedBox(height: 30.h),

      // TIME CHIPS: Using Wrap with specific alignment to match the grid look
      Wrap(
        spacing: 12.w, // Horizontal space between chips
        runSpacing: 12.h, // Vertical space between rows
        children: times.map((t) => _timeChip(t)).toList(),
      ),
    ]);
  }

  Widget _dayCircle(String day) {
    bool isActive = activeDay == day;
    bool hasHours = businessHours[day]!.isNotEmpty;

    return GestureDetector(
      onTap: () => setState(() => activeDay = day),
      child: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          // Design Match: Selected is Coral, filled is Light Grey, empty is White border
          color: isActive
              ? const Color(0xffD5715B)
              : (hasHours ? Colors.grey[200] : Colors.transparent),
          border: Border.all(
            color: isActive ? Colors.transparent : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(10.r), // Slightly rounded corners
        ),
        child: Center(
          child: Text(
            day,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.grey[500],
              fontWeight: FontWeight.w500,
              fontSize: 16.sp,
            ),
          ),
        ),
      ),
    );
  }

  Widget _timeChip(String time) {
    bool isSelected = businessHours[activeDay]!.contains(time);

    return GestureDetector(
      onTap: () => setState(() {
        isSelected
            ? businessHours[activeDay]!.remove(time)
            : businessHours[activeDay]!.add(time);
      }),
      child: Container(
        width: 155.w,
        padding: EdgeInsets.symmetric(vertical: 18.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xffF8C569) : Colors.grey[100],
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Center(
          child: Text(
            time,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle_outline,
            size: 100,
            color: Colors.green,
          ),
          SizedBox(height: 20.h),
          const Text(
            "You're all done!",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const Text("Hang tight while we review your info."),
          SizedBox(height: 30.h),
          MyButton(text: "Got it!", onTap: () => Navigator.pop(context)),
        ],
      ),
    );
  }

  Widget _formWrapper(String step, String title, List<Widget> children) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(step, style: const TextStyle(color: Colors.grey)),
          SizedBox(height: 8.h),
          Text(
            title,
            style: GoogleFonts.beVietnamPro(
              fontSize: 32.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 25.h),
          ...children.map(
            (e) => Padding(
              padding: EdgeInsets.only(bottom: 15.h),
              child: e,
            ),
          ),
        ],
      ),
    );
  }
}
