import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:gig/repository/profile/profile_repository.dart';
import 'package:gig/utils/utils.dart';
import 'package:gig/data/app_exceptions.dart';
import 'package:gig/res/app_url/app_url.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';

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

      // Check if token exists before making API call
      String? token = await Utils.readSecureData('auth_token');
      if (token == null || token.isEmpty) {
        error.value = 'Authentication token not found. Please login again.';
        Utils.snakBar('Error', error.value);
        return;
      }

      print('🔑 Token exists: ${token.substring(0, 10)}...');
      print('🌐 API URL: ${AppUrl.getProfileApi}');

      dynamic response = await _profileRepository.getProfile();

      print('📡 Profile response received');
      print('📡 Response type: ${response.runtimeType}');
      print('📡 Profile response: $response');

      if (response != null) {
        if (response['status'] == true) {
          // Make sure it's stored as proper JSON
          profileData.value = Map<String, dynamic>.from(
            response['data'] ?? response['user'] ?? {},
          );

          print(' Profile data loaded successfully');
          print(' API Response Data: ${profileData.value.toString()}');
          print(' Address from API: ${profileData.value['address_one']}');
          print(' Address fallback: ${profileData.value['address']}');
          print(' Bio from API: ${profileData.value['bio']}');
          print(' Resume URL from API: ${profileData.value['cv']}');
          print(' Resume name from API: ${profileData.value['cv_name']}');

          await storage.write(
            key: 'user_profile',
            value: jsonEncode(profileData.value),
          );
          print(' Profile data stored in secure storage');
        } else {
          String apiError = response['message'] ?? 'Failed to load profile';
          error.value = 'Server Error: $apiError';
          print('❌ API Error: $apiError');
          Utils.snakBar('Profile Error', apiError);
        }
      } else {
        error.value =
            'No response from server. Please check your internet connection.';
        print('❌ No response received from profile API');
        Utils.snakBar('Network Error', error.value);
      }
    } catch (e) {
      loading.value = false;
      print(' Error fetching profile: $e');

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

  Future<bool> _checkStoragePermission() async {
    if (Platform.isAndroid) {
      if (await Permission.manageExternalStorage.isGranted) {
        return true;
      }

      final status = await Permission.manageExternalStorage.request();

      if (status.isGranted) {
        return true;
      }

      // ❗️ Special permissions (like manageExternalStorage) do not always show dialogs
      // Show custom dialog or redirect to app settings
      if (status.isDenied || status.isPermanentlyDenied) {
        Get.defaultDialog(
          title: 'Storage Permission Required',
          middleText:
              'Please grant storage permission from app settings to download files.',
          confirm: ElevatedButton(
            onPressed: () {
              openAppSettings();
              Get.back();
            },
            child: const Text("Open Settings"),
          ),
          cancel: TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
        );
      }

      return false;
    } else {
      // For iOS or other platforms
      return true;
    }
  }

  Future<void> downloadPdf() async {
    try {
      if (resumeUrl.isEmpty) {
        Get.snackbar(
          'Error',
          'No resume URL provided',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      if (Platform.isAndroid) {
        bool hasPermission = await _checkStoragePermission();

        if (!hasPermission) {
          return; // _checkStoragePermission already shows dialog
        }
      }

      // Use public Download folder (requires MANAGE_EXTERNAL_STORAGE on Android 11+)
      final downloadsDir = Directory('/storage/emulated/0/Download/MyApp');

      if (!downloadsDir.existsSync()) {
        downloadsDir.createSync(recursive: true);
      }

      final fileName = "resume_${DateTime.now().millisecondsSinceEpoch}.pdf";
      final filePath = "${downloadsDir.path}/$fileName";

      await Dio().download(resumeUrl, filePath);

      Get.snackbar(
        'Success',
        'Saved to: $filePath',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Download failed: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Helper methods to get specific profile data
  String get userName => profileData['name'] ?? 'User Name';
  String get userEmail => profileData['email'] ?? 'user@example.com';
  String get userPhone =>
      profileData['phone_number'] ?? profileData['phone'] ?? '';
  String get userAddress =>
      profileData['address_one'] ?? profileData['address'] ?? '';
  String get userBio =>
      profileData['bio'] ?? profileData['description'] ?? 'No bio available';
  String baseUrlResume = 'https://gig.devonlinetestserver.com/api/cv/';

  // Fall back to server path from API (just the filename)
  String get resumeUrl {
    String? fileName = profileData['resume'] ?? profileData['cv'] ?? '';
    if (fileName != null && fileName.isNotEmpty) {
      // Otherwise, prepend base URL with profile_images folder
      String fullUrl = '$baseUrlResume$fileName';
      print(' URL: $fullUrl');
      return fullUrl;
    }
    return '';
  }

  //String get resumeUrl => profileData['resume'] ?? profileData['cv'] ?? '';
  String get resumeName =>
      profileData['resume_name'] ?? profileData['cv_name'] ?? 'resume.pdf';
  String get profileImage {
    // Check for local file path first (from recent upload)
    String? localPath = profileData['profile_image'] ?? '';

    // Base URL for server images (includes the profile_images folder)
    const String baseUrl =
        'https://lavender-buffalo-882516.hostingersite.com/gig_app/storage/app/public/profile_images/';

    // Fall back to server path from API (just the filename)
    String? fileName = profileData['avatar'] ?? localPath ?? '';

    if (fileName != null && fileName.isNotEmpty) {
      // Otherwise, prepend base URL with profile_images folder
      String fullUrl = '$baseUrl$fileName';
      print(' URL: $fullUrl');
      return fullUrl;
    }

    return ''; // Default empty if no image
  }

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
        print(' Profile data loaded from storage for instant update');
        print(' Stored Data: ${data.toString()}');
        print(' Address from storage: ${data['address_one']}');
        print(' Address fallback from storage: ${data['address']}');
        print(' Bio from storage: ${data['bio']}');
        print(' Resume URL from storage: ${data['cv']}');
        print(' Resume name from storage: ${data['cv_name']}');
      } else {
        print('❌ No stored profile data found');
      }
    } catch (e) {
      print('❌ Error loading from stored data: $e');
    }
  }
}
