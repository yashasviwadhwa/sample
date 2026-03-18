class SignupModel {
  String? fullName;
  String? email;
  String? phone;
  String? password;
  String? role;
  String? businessName;
  String? informalName;
  String? address;
  String? city;
  String? state;
  String? zipCode; 
  String? registrationProof;
  BusinessHours? businessHours;
  String? deviceToken;
  String? type;
  String? socialId;

  SignupModel({
    this.fullName,
    this.email,
    this.phone,
    this.password,
    this.role,
    this.businessName,
    this.informalName,
    this.address,
    this.city,
    this.state,
    this.zipCode,
    this.registrationProof,
    this.businessHours,
    this.deviceToken,
    this.type,
    this.socialId,
  });

  factory SignupModel.fromJson(Map<String, dynamic> json) {
    return SignupModel(
      fullName: json["full_name"]?.toString(),
      email: json["email"]?.toString(),
      phone: json["phone"]?.toString(),
      password: json["password"]?.toString(),
      role: json["role"]?.toString(),
      businessName: json["business_name"]?.toString(),
      informalName: json["informal_name"]?.toString(),
      address: json["address"]?.toString(),
      city: json["city"]?.toString(),
      state: json["state"]?.toString(),
      zipCode: json["zip_code"]?.toString(), 
      registrationProof: json["registration_proof"]?.toString(),
      businessHours: json["business_hours"] != null
          ? BusinessHours.fromJson(json["business_hours"])
          : null,
      deviceToken: json["device_token"]?.toString(),
      type: json["type"]?.toString(),
      socialId: json["social_id"]?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "full_name": fullName,
      "email": email,
      "phone": phone,
      "password": password,
      "role": role,
      "business_name": businessName,
      "informal_name": informalName,
      "address": address,
      "city": city,
      "state": state,
      // If your API requires zip_code to be an actual integer:
      "zip_code": int.tryParse(zipCode ?? "") ?? zipCode, 
      "registration_proof": registrationProof,
      "business_hours": businessHours?.toJson(),
      "device_token": deviceToken,
      "type": type,
      "social_id": socialId,
    };
  }
}

class BusinessHours {
  List<String>? mon, tue, wed, thu, fri, sat, sun;

  BusinessHours({
    this.mon,
    this.tue,
    this.wed,
    this.thu,
    this.fri,
    this.sat,
    this.sun,
  });

  factory BusinessHours.fromJson(Map<String, dynamic> json) => BusinessHours(
        // Using _safeList to ensure we always get List<String>
        mon: _safeList(json["mon"]),
        tue: _safeList(json["tue"]),
        wed: _safeList(json["wed"]),
        thu: _safeList(json["thu"]),
        fri: _safeList(json["fri"]),
        sat: _safeList(json["sat"]),
        sun: _safeList(json["sun"]),
      );

  Map<String, dynamic> toJson() => {
        "mon": mon,
        "tue": tue,
        "wed": wed,
        "thu": thu,
        "fri": fri,
        "sat": sat,
        "sun": sun,
      };

  /// BRIDGE: Converts your UI Map (M, T, W, Th, F, S, Su) 
  /// to the API Model keys (mon, tue, wed, thu, fri, sat, sun)
  factory BusinessHours.fromUiMap(Map<String, List<String>> uiMap) {
    return BusinessHours(
      mon: uiMap["M"],
      tue: uiMap["T"],
      wed: uiMap["W"],
      thu: uiMap["Th"],
      fri: uiMap["F"],
      sat: uiMap["S"],
      sun: uiMap["Su"],
    );
  }

  /// TRYPARSE HELPER: Ensures the list contains only strings 
  /// and handles cases where the API might return null or dynamic lists.
  static List<String>? _safeList(dynamic jsonList) {
    if (jsonList == null || jsonList is! List) return null;
    return jsonList.map((item) => item.toString()).toList();
  }
}