import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class AddProfileController extends GetxController {
  Rxn<File> imageFile = Rxn<File>(); // reactive nullable File
  RxList<String> selectedChips = <String>[].obs;
  Rx<File?> pdfFile = Rx<File?>(null);
  RxString pdfFileName = ''.obs;

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
}
