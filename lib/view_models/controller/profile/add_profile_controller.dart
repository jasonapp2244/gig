import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:gig/models/profile/profile_model.dart';
import 'package:gig/repository/profile/profile_repository.dart';
import 'package:gig/utils/utils.dart';
import 'package:gig/view_models/controller/home/home_view_model.dart';
import 'package:gig/view_models/controller/profile/get_profile_view_model.dart';

class AddProfileController extends GetxController {
  final ProfileRepository _profileRepository = ProfileRepository();
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  // Text controllers for form fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  Rxn<File> imageFile = Rxn<File>(); // reactive nullable File
  RxList<String> selectedChips = <String>[].obs;
  Rx<File?> pdfFile = Rx<File?>(null);
  RxString pdfFileName = ''.obs;
  RxBool loading = false.obs;
  RxBool isDataLoaded = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Load stored profile data when controller is initialized
    loadStoredProfileData();
    // Also ensure GetProfileViewModel is loaded
    _ensureProfileViewModelLoaded();
  }

  /// Ensure GetProfileViewModel is loaded to get existing profile data
  Future<void> _ensureProfileViewModelLoaded() async {
    try {
      if (Get.isRegistered<GetProfileViewModel>()) {
        final profileController = Get.find<GetProfileViewModel>();
        await profileController.loadFromStoredData();
      }
    } catch (e) {
      print('Note: Could not load GetProfileViewModel: $e');
    }
  }

  @override
  void onClose() {
    // Dispose text controllers
    nameController.dispose();
    phoneNumberController.dispose();
    addressController.dispose();
    emailController.dispose();
    super.onClose();
  }

  /// Load stored profile data and auto-fill form fields
  Future<void> loadStoredProfileData() async {
    try {
      print('🔄 Loading stored profile data...');

      // Get stored profile data
      String? storedProfileData = await _storage.read(key: 'user_profile');

      if (storedProfileData != null && storedProfileData.isNotEmpty) {
        Map<String, dynamic> profileData = jsonDecode(storedProfileData);

        print(' Found stored profile data: $profileData');
        print(' Address from stored data: ${profileData['address_one']}');
        print(' Address fallback from stored data: ${profileData['address']}');

        // Auto-fill text fields
        nameController.text = profileData['name'] ?? '';
        phoneNumberController.text =
            profileData['phone_number'] ?? profileData['phone'] ?? '';
        addressController.text =
            profileData['address_one'] ?? profileData['address'] ?? '';
        emailController.text = profileData['email'] ?? '';

        // Auto-fill skills/chips
        if (profileData['skills'] != null) {
          selectedChips.clear();
          if (profileData['skills'] is String) {
            // If skills is a comma-separated string
            List<String> skillsList = (profileData['skills'] as String)
                .split(',')
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .toList();
            selectedChips.addAll(skillsList);
          } else if (profileData['skills'] is List) {
            // If skills is already a list
            List<String> skillsList = (profileData['skills'] as List)
                .map((e) => e.toString().trim())
                .where((e) => e.isNotEmpty)
                .toList();
            selectedChips.addAll(skillsList);
          }
        }

        // Auto-fill PDF filename if exists
        if (profileData['cv_name'] != null ||
            profileData['resume_name'] != null) {
          pdfFileName.value =
              profileData['cv_name'] ?? profileData['resume_name'] ?? '';
          print(' PDF filename auto-filled: ${pdfFileName.value}');
        }

        // Auto-fill PDF URL if exists (for download functionality)
        if (profileData['cv'] != null || profileData['resume'] != null) {
          String pdfUrl = profileData['cv'] ?? profileData['resume'] ?? '';
          if (pdfUrl.isNotEmpty) {
            print(' PDF URL found: $pdfUrl');
            // Store PDF URL for download functionality
            await _storage.write(key: 'user_pdf_url', value: pdfUrl);
          }
        }

        // Auto-fill local PDF file if exists
        if (profileData['cv'] != null &&
            profileData['cv'].toString().isNotEmpty) {
          String pdfPath = profileData['cv'].toString();
          if (pdfPath.startsWith('/') && File(pdfPath).existsSync()) {
            // It's a local file path, set it as the current PDF
            pdfFile.value = File(pdfPath);
            print(' Local PDF file auto-filled: $pdfPath');
          }
        }

        // Auto-fill profile image if exists (local file path)
        if (profileData['profile_image'] != null &&
            profileData['profile_image'].toString().isNotEmpty) {
          String imagePath = profileData['profile_image'].toString();
          if (imagePath.startsWith('/')) {
            // It's a local file path, set it as the current image
            imageFile.value = File(imagePath);
          }
        }

        isDataLoaded.value = true;
        print(' Profile data auto-filled successfully');
        print(' Address controller text: ${addressController.text}');
      } else {
        print('ℹ No stored profile data found');
        isDataLoaded.value = true;
      }
    } catch (e) {
      print(' Error loading stored profile data: $e');
      isDataLoaded.value = true;
    }
  }

  /// Refresh stored data from secure storage
  Future<void> refreshStoredData() async {
    isDataLoaded.value = false;
    await loadStoredProfileData();
  }

  /// Update stored profile data immediately after successful API update
  Future<void> _updateStoredProfileData() async {
    try {
      Map<String, dynamic> updatedData = {
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'phone_number': phoneNumberController.text.trim(),
        'address_one': addressController.text.trim(),
        'skills': selectedChips.toList(),
        'cv_name': pdfFileName.value.isNotEmpty ? pdfFileName.value : null,
        'cv': pdfFile.value?.path ?? '', // Store local PDF path
        'profile_image': imageFile.value?.path ?? '', // Store local image path
      };

      await _storage.write(key: 'user_profile', value: jsonEncode(updatedData));

      // Also update individual user fields for home screen
      await _storage.write(key: 'user_name', value: nameController.text.trim());
      await _storage.write(
        key: 'user_email',
        value: emailController.text.trim(),
      );
      await _storage.write(
        key: 'user_phone',
        value: phoneNumberController.text.trim(),
      );

      print(' Stored profile data updated immediately');
    } catch (e) {
      print(' Error updating stored profile data: $e');
    }
  }

  pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path); // notify listeners
    }
  }

  addChip(String chipValue) {
    if (chipValue.isNotEmpty && !selectedChips.contains(chipValue)) {
      selectedChips.add(chipValue);
    }
  }

  removeChip(String chipValue) {
    selectedChips.remove(chipValue);
  }

  clearAllChips() {
    selectedChips.clear();
  }

  pickPdfFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        pdfFile.value = File(result.files.single.path!);
        pdfFileName.value = result.files.single.name;
        print('PDF picked: ${pdfFileName.value}');
      }
    } catch (e) {
      print('Error picking PDF: $e');
    }
  }

  clearPdfFile() {
    pdfFile.value = null;
    pdfFileName.value = '';
    print('PDF cleared');
  }

  Future<void> postProfileData() async {
    try {
      loading.value = true;

      // Get values from controllers
      String name = nameController.text.trim();
      String phoneNumber = phoneNumberController.text.trim();
      String address = addressController.text.trim();
      String email = emailController.text.trim();

      // Validate required fields
      if (name.isEmpty) {
        return Utils.snakBar("Error", "Name is required");
      }
      if (phoneNumber.isEmpty) {
        return Utils.snakBar("Error", "Phone number is required");
      }
      if (address.isEmpty) {
        return Utils.snakBar("Error", "Address is required");
      }
      if (email.isEmpty) {
        return Utils.snakBar("Error", "Email is required");
      }

      // Create profile model
      ProfileModel profileData = ProfileModel(
        name: name,
        phoneNumber: phoneNumber,
        address: address,
        profileImagePath: imageFile.value?.path,
        pdfFilePath: pdfFile.value?.path,
        pdfFileName: pdfFileName.value.isNotEmpty ? pdfFileName.value : null,
        skills: selectedChips.toList(),
        email: email,
      );

      print('Submitting profile data: $profileData');

      // Submit to API
      dynamic response = await _profileRepository.updateProfile(
        profileData,
        profileImage: imageFile.value,
        pdfFile: pdfFile.value,
      );

      print('Profile update response: $response');

      Utils.snakBar("Success", "Profile updated successfully!");

      // Update stored profile data in secure storage for instant access
      await _updateStoredProfileData();

      // Update home screen data if controller exists
      try {
        if (Get.isRegistered<HomeViewModel>()) {
          Get.find<HomeViewModel>().refreshUserData();
        }
      } catch (e) {
        print('Note: HomeViewModel not found for refresh');
      }

      // Update profile view screen if controller exists (instant update from storage)
      try {
        if (Get.isRegistered<GetProfileViewModel>()) {
          await Get.find<GetProfileViewModel>().loadFromStoredData();
        }
      } catch (e) {
        print('Note: GetProfileViewModel not found for refresh');
      }

      // Optionally clear form or navigate
      // clearForm();
    } catch (error) {
      print('Error posting profile data: $error');
      Utils.snakBar("Error", "Failed to update profile: $error");
    } finally {
      loading.value = false;
    }
  }

  void clearForm() {
    nameController.clear();
    phoneNumberController.clear();
    addressController.clear();
    emailController.clear();
    imageFile.value = null;
    selectedChips.clear();
    pdfFile.value = null;
    pdfFileName.value = '';
  }
}
