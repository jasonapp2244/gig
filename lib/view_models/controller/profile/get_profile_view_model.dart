import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:gig/repository/profile/profile_repository.dart';
import 'package:gig/res/colors/app_color.dart';
import 'package:gig/utils/utils.dart';
import 'package:gig/data/app_exceptions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

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

      print(' Fetching user profile...');

      dynamic response = await _profileRepository.getProfile();

      print(' Profile response: $response');

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
          error.value = response['message'] ?? 'Failed to load profile';
          Utils.snakBar('Error', error.value);
        }
      } else {
        error.value = 'No response from server';
        Utils.snakBar('Error', error.value);
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

  /// Download PDF resume
  Future<void> downloadPdf() async {
    try {
      // Check if resume URL exists
      if (resumeUrl.isEmpty) {
        Get.snackbar(
          'Error',
          'No resume available for download',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Request appropriate permissions based on Android version
      bool hasPermission = false;

      if (Platform.isAndroid) {
        print(' Checking Android permissions...');

        // For Android 13+ (API 33+), we need photos and videos permission
        var photosStatus = await Permission.photos.request();
        print(' Photos permission: ${photosStatus.isGranted}');

        if (photosStatus.isGranted) {
          hasPermission = true;
        } else {
          var storageStatus = await Permission.storage.request();
          print(' Storage permission: ${storageStatus.isGranted}');

          if (storageStatus.isGranted) {
            hasPermission = true;
          } else {
            var manageStatus = await Permission.manageExternalStorage.request();
            print(' Manage external storage: ${manageStatus.isGranted}');

            if (manageStatus.isGranted) {
              hasPermission = true;
            }
          }
        }

        print(' Final permission status: $hasPermission');
      } else {
        // For iOS, we don't need special permissions for app documents
        hasPermission = true;
        print(' iOS - no special permissions needed');
      }

      if (!hasPermission) {
        Get.snackbar(
          'Permission Required',
          'Storage permission is needed to download the resume. Please grant permission in settings.',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: Duration(seconds: 5),
        );
        return;
      }

      // Show loading indicator
      Get.dialog(
        Center(child: CircularProgressIndicator(color: AppColor.primeColor)),
        barrierDismissible: false,
      );

      // Get the download directory
      Directory? directory;
      if (Platform.isAndroid) {
        print(' Finding Android download directory...');

        // Try multiple possible download directories
        List<String> possiblePaths = [
          '/storage/emulated/0/Download',
          '/storage/emulated/0/Downloads',
          '/sdcard/Download',
          '/sdcard/Downloads',
        ];

        for (String path in possiblePaths) {
          Directory testDir = Directory(path);
          bool exists = await testDir.exists();
          print(' Checking $path: ${exists ? 'EXISTS' : 'NOT FOUND'}');

          if (exists) {
            directory = testDir;
            print('✅ Using directory: $path');
            break;
          }
        }

        // If no download directory found, use app documents directory
        if (directory == null) {
          directory = await getApplicationDocumentsDirectory();
          print(' Fallback to app documents: ${directory.path}');
        }
      } else {
        directory = await getApplicationDocumentsDirectory();
        print(' iOS using app documents: ${directory.path}');
      }

      // Create filename
      String fileName = resumeName.isNotEmpty
          ? resumeName
          : 'resume_${DateTime.now().millisecondsSinceEpoch}.pdf';

      // Download the file
      final response = await http.get(Uri.parse(resumeUrl));

      if (response.statusCode == 200) {
        // Save the file
        final file = File('${directory.path}/$fileName');
        await file.writeAsBytes(response.bodyBytes);

        // Close loading dialog
        Get.back();

        // Show success message
        String downloadLocation = directory.path.contains('Download')
            ? 'Downloads folder'
            : 'App Documents folder';

        Get.snackbar(
          'Success',
          'Resume downloaded to $downloadLocation',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );

        print('✅ PDF downloaded successfully: ${file.path}');
      } else {
        // Close loading dialog
        Get.back();

        Get.snackbar(
          'Error',
          'Failed to download resume: ${response.statusCode}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      // Close loading dialog if open
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      print('❌ Error downloading PDF: $e');
      Get.snackbar(
        'Error',
        'Failed to download resume: $e',
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

  String get resumeUrl => profileData['resume'] ?? profileData['cv'] ?? '';
  String get resumeName =>
      profileData['resume_name'] ?? profileData['cv_name'] ?? 'resume.pdf';
  String get profileImage {
    // Check for local file path first (from recent upload)
    String? localPath = profileData['profile_image'] ?? '';

    // Base URL for server images (includes the profile_images folder)
    const String baseUrl =
        'http://192.168.18.159/gig_mob_app/public/storage/profile_images/';

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
