import 'package:flutter/material.dart';
import 'package:gig/res/colors/app_color.dart';
import 'package:gig/res/components/custom_image_picker.dart';
import 'package:gig/res/components/input.dart';
import 'package:gig/res/components/chip_input_field.dart';
import 'package:gig/res/components/pdf_picker_widget.dart';
import 'package:get/get.dart';
import 'package:gig/view_models/controller/profile/add_profile_controller.dart';
import 'package:gig/view_models/controller/profile/get_profile_view_model.dart';

class AddProfileScreen extends StatefulWidget {
  const AddProfileScreen({super.key});

  @override
  State<AddProfileScreen> createState() => _AddProfileScreenState();
}

class _AddProfileScreenState extends State<AddProfileScreen> {
  final TextEditingController _chipController = TextEditingController();
  GetProfileViewModel? profileController;
  @override
  Widget build(BuildContext context) {
    final AddProfileController controller = Get.put(AddProfileController());

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.appBodyBG,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              controller.refreshStoredData();
            },
            tooltip: 'Refresh Profile Data',
          ),

          backgroundColor: AppColor.appBodyBG,
          title: const Text(
            'Edit Profile',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: () {
                controller.refreshStoredData();
              },
              tooltip: 'Refresh Profile Data',
            ),
          ],
        ),
        body: Obx(() {
          if (!controller.isDataLoaded.value) {
            return Center(
              child: CircularProgressIndicator(color: AppColor.primeColor),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Photo Picker
                CustomPhotoWidget(controller: controller),
                const SizedBox(height: 20),

                // Name Field
                CustomInputField(
                  controller: controller.nameController,
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
                  controller: controller.phoneNumberController,
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
                  controller: controller.addressController,
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
                const SizedBox(height: 20),

                // Email Field
                CustomInputField(
                  controller: controller.emailController,
                  fieldType: 'text',
                  hintText: "Email",
                  requiredField: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Skills Chips
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

                // PDF Picker
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
                            : () async {
                                await controller.postProfileData();
                                // Force instant update of profile screen from stored data
                                if (Get.isRegistered<GetProfileViewModel>()) {
                                  await Get.find<GetProfileViewModel>()
                                      .loadFromStoredData();
                                }
                                Get.back();
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
          );
        }),
      ),
    );
  }
}
