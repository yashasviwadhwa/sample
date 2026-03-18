import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:sample_page/features/Model/signUpmodel.dart';

class ApiService {
  // FIXED URL: Moved /user before /register as per standard API routing
  static const String registrationUrl =
      "https://sowlab.com/assignment/user/register";

  Future<bool> registerFarmer(SignupModel data, File? file) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(registrationUrl));

      // 1. Map text fields
      final jsonMap = data.toJson();
      jsonMap.forEach((key, value) {
        if (value != null && key != "business_hours") {
          request.fields[key] = value.toString();
        }
      });

      // 2. Encode nested business_hours object as a JSON String
      if (data.businessHours != null) {
        request.fields['business_hours'] = jsonEncode(
          data.businessHours!.toJson(),
        );
      }

      // 3. Attach the registration proof file
      if (file != null) {
        // Ensure the field name is exactly 'registration_proof'
        request.files.add(
          await http.MultipartFile.fromPath('registration_proof', file.path),
        );
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Success: ${response.body}");
        return true;
      } else {
        // This will now print the actual API error instead of HTML
        print("API Error (${response.statusCode}): ${response.body}");
        return false;
      }
    } catch (e) {
      print("Request Exception: $e");
      return false;
    }
  }

  Future<Map<String, dynamic>> loginFarmer({
    required String email,
    required String password,
    required String deviceToken,
    required String socialId,
    String type = "email",
  }) async {
    try {
      const String loginUrl = "https://sowlab.com/assignment/user/login";
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {"Content-Type": "applicaton/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
          "role": "farmer",
          "device_token": deviceToken,
          "type": type,
          "social_id": socialId,
        }),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data["success"] == true) {
        print("Login Successful: ${data['message']}");
        return data;
      } else {
        print("Login Failed: ${data['message']}");
        return data;
      }
    } catch (e) {
      print("Login Error: $e");
      return {"success": false, "message": "Connection error"};
    }
  }

  Future<Map<String, dynamic>> phoneNumberExist({
    required String  MobileNumber,
  }) async {
    try {
      const String loginUrl =
          "https://sowlab.com/assignment/user/forgot-password";

          print("mobile $MobileNumber");
      final response = await http.post(
        Uri.parse("${loginUrl}"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"mobile": MobileNumber}),
      );
      final data=jsonDecode(response.body);

      if (response.statusCode==200 && data["success"]==true) {
        return data;
      }
      else {
         print("Login Failed: ${data['message']}");
        return data;
      }

    } catch (e) {
       print("Login Error: $e");
      return {"success": false, "message": "Connection error"};
    }
  }
  Future<Map<String, dynamic>> verifyOtp({
  required String otp,
}) async {
  try {
    final response = await http.post(
      Uri.parse("https://sowlab.com/assignment/user/verify-otp"), // Ensure this is the correct endpoint from your docs
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "otp": otp,
      }),
    );

    return jsonDecode(response.body);
  } catch (e) {
    return {"success": "false", "message": "Connection error"};
  }
}

Future<Map<String, dynamic>> resetPassword({
  required String token,
  required String password,
  required String cpassword,
}) async {
  try {
    final response = await http.post(
      Uri.parse("https://sowlab.com/assignment/user/reset-password"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "token": token,
        "password": password,
        "cpassword": cpassword,
      }),
    );
    return jsonDecode(response.body);
  } catch (e) {
    return {"success": "false", "message": "Connection error"};
  }
}
}
