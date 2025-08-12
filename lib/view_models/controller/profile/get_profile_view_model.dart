import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:gig/repository/profile/profile_repository.dart';
import 'package:gig/utils/utils.dart';
import 'package:gig/data/app_exceptions.dart';

class GetProfileViewModel extends GetxController {
  final ProfileRepository _profileRepository = ProfileRepository();
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  RxBool loading = false.obs;
  RxMap<String, dynamic> profileData = <String, dynamic>{}.obs;
  RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Automatically fetch profile when controller is initialized
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    const storage = FlutterSecureStorage();

    try {
      loading.value = true;
      error.value = '';

      print('🔄 Fetching user profile...');

      dynamic response = await _profileRepository.getProfile();

      print('📋 Profile response: $response');

      if (response != null) {
        if (response['status'] == true) {
          // Make sure it's stored as proper JSON
          profileData.value = Map<String, dynamic>.from(
            response['data'] ?? response['user'] ?? {},
          );

          print('✅ Profile data loaded successfully');
          print('🌐 API Response Data: ${profileData.value.toString()}');
          print('🏠 Address from API: ${profileData.value['address']}');
          print('📖 Bio from API: ${profileData.value['bio']}');

          await storage.write(
            key: 'user_profile',
            value: jsonEncode(profileData.value),
          );
          print('🔐 Profile data stored in secure storage');
        } else {
          error.value = response['message'] ?? 'Failed to load profile';
          Utils.snakBar('Error', error.value);
        }
      } else {
        error.value = 'No response from server';
        Utils.snakBar('Error', error.value);
      }
    } catch (e) {
      loading.value = false;
      print('❌ Error fetching profile: $e');

      String errorMessage = 'Failed to load profile';
      if (e is InternetException) {
        errorMessage = 'Please check your internet connection';
      } else if (e is FetchDataException) {
        errorMessage = 'Server error. Please try again later';
      } else if (e is RequestTimeout) {
        errorMessage = 'Request timeout. Please try again';
      } else {
        errorMessage = e.toString();
      }

      error.value = errorMessage;
      Utils.snakBar('Error', errorMessage);
    } finally {
      loading.value = false;
    }
  }

  // Helper methods to get specific profile data
  String get userName => profileData['name'] ?? 'User Name';
  String get userEmail => profileData['email'] ?? 'user@example.com';
  String get userPhone =>
      profileData['phone_number'] ?? profileData['phone'] ?? '';
  String get userAddress => profileData['address'] ?? '';
  String get userBio =>
      profileData['bio'] ?? profileData['description'] ?? 'No bio available';
  String get profileImage {
    // Check for local file path first (from recent upload)
    String localPath = profileData['profile_image'] ?? '';
    if (localPath.isNotEmpty && localPath.startsWith('/')) {
      return localPath; // Return local file path
    }
    // Fall back to network URL from API
    return profileData['avatar'] ?? profileData['image_url'] ?? '';
  }
  String get resumeUrl => profileData['resume'] ?? profileData['cv'] ?? '';
  String get resumeName =>
      profileData['resume_name'] ?? profileData['cv_name'] ?? 'resume.pdf';
  List<dynamic> get userSkills => profileData['skills'] ?? [];

  // Refresh profile data
  Future<void> refreshProfile() async {
    await fetchProfile();
  }

  // Force immediate update from stored data (for instant UI updates)
  Future<void> loadFromStoredData() async {
    try {
      String? storedProfileData = await _storage.read(key: 'user_profile');
      
      if (storedProfileData != null && storedProfileData.isNotEmpty) {
        Map<String, dynamic> data = jsonDecode(storedProfileData);
        profileData.value = Map<String, dynamic>.from(data);
        print('✅ Profile data loaded from storage for instant update');
        print('🔍 Stored Data: ${data.toString()}');
        print('🏠 Address from storage: ${data['address']}');
        print('📖 Bio from storage: ${data['bio']}');
      } else {
        print('❌ No stored profile data found');
      }
    } catch (e) {
      print('❌ Error loading from stored data: $e');
    }
  }
}
