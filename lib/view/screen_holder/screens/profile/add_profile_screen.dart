import 'package:flutter/material.dart';
import 'package:gig/res/colors/app_color.dart';
import 'package:gig/res/components/custom_image_picker.dart';
import 'package:gig/res/components/input.dart';
import 'package:gig/res/components/chip_input_field.dart';
import 'package:gig/res/components/pdf_picker_widget.dart';
import 'package:get/get.dart';
import 'package:gig/view_models/controller/profile/add_profile_controller.dart';

class AddProfileScreen extends StatelessWidget {
  AddProfileScreen({super.key});

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _chipController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final AddProfileController controller = Get.put(AddProfileController());

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.appBodyBG,
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 10,
            top: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Photo Picker
              CustomPhotoWidget(controller: controller),
              const SizedBox(height: 20),

              // Name Field
              CustomInputField(
                controller: _nameController,
                fieldType: 'text',
                hintText: "Name",
                requiredField: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Phone Number Field
              CustomInputField(
                controller: _phoneNumberController,
                fieldType: 'text',
                hintText: "Phone Number",
                requiredField: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Phone number is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Address Field
              CustomInputField(
                controller: _addressController,
                fieldType: 'text',
                hintText: "Address",
                requiredField: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Address is required';
                  }
                  return null;
                },
              ),

              CustomInputField(
                controller: _emailController,
                fieldType: 'text',
                hintText: "Email",
                requiredField: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Address is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              GetX<AddProfileController>(
                builder: (controller) {
                  return ChipInputField(
                    selectedChips: controller.selectedChips.toList(),
                    onChipAdded: controller.addChip,
                    onChipRemoved: controller.removeChip,
                    textController: _chipController,
                    hintText: 'Add skills, expertise, tags...',
                  );
                },
              ),
              const SizedBox(height: 20),
              GetX<AddProfileController>(
                builder: (controller) {
                  return PdfPickerWidget(
                    pdfFile: controller.pdfFile.value,
                    pdfFileName: controller.pdfFileName.value,
                    onPickPdf: controller.pickPdfFile,
                    onRemovePdf: controller.clearPdfFile,
                  );
                },
              ),

              const SizedBox(height: 20),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: GetX<AddProfileController>(
                  builder: (controller) {
                    return ElevatedButton(
                      onPressed: controller.loading.value
                          ? null
                          : () {
                              controller.postProfileData(
                                name: _nameController.text.trim(),
                                phoneNumber: _phoneNumberController.text.trim(),
                                address: _addressController.text.trim(),
                                email: _emailController.text.trim(),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primeColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: controller.loading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Save Profile',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
