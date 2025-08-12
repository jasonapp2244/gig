class ProfileModel {
  final String? name;
  final String? phoneNumber;
  final String? address;
  final String? profileImagePath;
  final String? pdfFilePath;
  final String? pdfFileName;
  final List<String>? skills;
  final String? email;

  ProfileModel({
    this.name,
    this.phoneNumber,
    this.address,
    this.profileImagePath,
    this.pdfFilePath,
    this.pdfFileName,
    this.skills,
    this.email,
  });

  // Convert to JSON for API
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone_number': phoneNumber,
      'address': address,
      'profile_image': profileImagePath,
      'cv': pdfFilePath,
      'cv_filename': pdfFileName,
      'email': email,
      'skills': skills?.join(','), // Convert list to comma-separated string
    };
  }

  // Create from JSON (enhanced for GET API response)
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    List<String>? skillsList;
    
    // Handle different skill data formats
    if (json['skills'] != null) {
      if (json['skills'] is String) {
        skillsList = (json['skills'] as String).split(',').map((e) => e.trim()).toList();
      } else if (json['skills'] is List) {
        skillsList = (json['skills'] as List).map((e) => e.toString()).toList();
      }
    }

    return ProfileModel(
      name: json['name'] ?? json['full_name'],
      phoneNumber: json['phone_number'] ?? json['phone'],
      address: json['address'] ?? json['location'],
      profileImagePath: json['profile_image'] ?? json['avatar'] ?? json['image_url'],
      pdfFilePath: json['cv'] ?? json['resume'] ?? json['cv_url'],
      pdfFileName: json['cv_filename'] ?? json['resume_name'] ?? json['cv_name'],
      email: json['email'],
      skills: skillsList,
    );
  }

  // Convert to Map for form data (multipart)
  Map<String, String> toFormData() {
    Map<String, String> formData = {};

    if (name != null) formData['name'] = name!;
    if (phoneNumber != null) formData['phone_number'] = phoneNumber!;
    if (address != null) formData['address'] = address!;
    if (pdfFileName != null) formData['cv_filename'] = pdfFileName!;
    if (email != null) formData['email'] = email!;
    if (skills != null && skills!.isNotEmpty) {
      formData['skills'] = skills!.join(',');
    }

    return formData;
  }

  @override
  String toString() {
    return 'ProfileModel(name: $name, phoneNumber: $phoneNumber, address: $address, skills: $skills, pdfFileName: $pdfFileName,email:$email)';
  }
}
