import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:gig/models/profile/profile_model.dart';
import 'package:gig/repository/profile/profile_repository.dart';
import 'package:gig/utils/utils.dart';

class AddProfileController extends GetxController {
  final ProfileRepository _profileRepository = ProfileRepository();

  Rxn<File> imageFile = Rxn<File>(); // reactive nullable File
  RxList<String> selectedChips = <String>[].obs;
  Rx<File?> pdfFile = Rx<File?>(null);
  RxString pdfFileName = ''.obs;
  RxBool loading = false.obs;

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

  Future<void> postProfileData({
    required String name,
    required String phoneNumber,
    required String address,
    required String email,
  }) async {
    try {
      loading.value = true;

      // Validate required fields
      if (name.isEmpty) {
        Utils.snakBar("Error", "Name is required");
        return;
      }
      if (phoneNumber.isEmpty) {
        Utils.snakBar("Error", "Phone number is required");
        return;
      }
      if (address.isEmpty) {
        Utils.snakBar("Error", "Address is required");
        return;
      }
      if (email.isEmpty) {
        Utils.snakBar("Error", "Email is required");
        return;
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
    imageFile.value = null;
    selectedChips.clear();
    pdfFile.value = null;
    pdfFileName.value = '';
  }
}
