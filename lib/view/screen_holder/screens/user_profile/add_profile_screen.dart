import 'package:flutter/material.dart';
import 'package:gig/res/colors/app_color.dart';
import 'package:gig/res/components/custom_image_picker.dart';
import 'package:gig/res/components/input.dart';
import 'package:gig/res/components/chip_input_field.dart';
import 'package:gig/res/components/pdf_picker_widget.dart';
import 'package:get/get.dart';
import 'package:gig/res/routes/routes_name.dart';
import 'package:gig/view_models/controller/profile/add_profile_controller.dart';
import 'package:gig/view_models/controller/profile/get_profile_view_model.dart';

// class AddProfileScreen extends StatefulWidget {
//   const AddProfileScreen({super.key});

//   @override
//   State<AddProfileScreen> createState() => _AddProfileScreenState();
// }

// class _AddProfileScreenState extends State<AddProfileScreen> {
//   final TextEditingController _chipController = TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   GetProfileViewModel? profileController;
//   @override
//   Widget build(BuildContext context) {
//     final AddProfileController controller = Get.put(AddProfileController());

//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: AppColor.appBodyBG,
//         appBar: AppBar(
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back, color: Colors.white),
//             onPressed: () {
//               controller.refreshStoredData();
//             },
//             tooltip: 'Refresh Profile Data',
//           ),

//           backgroundColor: AppColor.appBodyBG,
//           title: const Text(
//             'Edit Profile',
//             style: TextStyle(color: Colors.white),
//           ),
//           iconTheme: const IconThemeData(color: Colors.white),
//           actions: [],
//         ),
//         body: Obx(() {
//           if (!controller.isDataLoaded.value) {
//             return Center(
//               child: CircularProgressIndicator(color: AppColor.primeColor),
//             );
//           }

//           return SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   // Photo Picker
//                   CustomPhotoWidget(controller: controller),
//                   const SizedBox(height: 20),

//                   // Name Field
//                   CustomInputField(
//                     controller: controller.nameController,
//                     fieldType: 'text',
//                     hintText: "Name",
//                     requiredField: true,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Name is required';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 20),

//                   // Phone Number Field
//                   CustomInputField(
//                     controller: controller.phoneNumberController,
//                     fieldType: 'text',
//                     hintText: "Phone Number",
//                     requiredField: true,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Phone number is required';
//                       }
//                       // Basic phone number validation (allows digits, spaces, dashes, parentheses)
//                       if (!RegExp(r'^[\d\s\-\(\)\+]+$').hasMatch(value)) {
//                         return 'Please enter a valid phone number';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 20),

//                   // Address Field
//                   CustomInputField(
//                     controller: controller.addressController,
//                     fieldType: 'text',
//                     hintText: "Address",
//                     requiredField: true,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Address is required';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 20),

//                   // Email Field
//                   CustomInputField(
//                     controller: controller.emailController,
//                     fieldType: 'text',
//                     hintText: "Email",
//                     requiredField: true,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Email is required';
//                       }
//                       // Basic email validation
//                       if (!RegExp(
//                         r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
//                       ).hasMatch(value)) {
//                         return 'Please enter a valid email address';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 20),

//                   // Skills Chips
//                   GetX<AddProfileController>(
//                     builder: (controller) {
//                       return ChipInputField(
//                         selectedChips: controller.selectedChips.toList(),
//                         onChipAdded: controller.addChip,
//                         onChipRemoved: controller.removeChip,
//                         textController: _chipController,
//                         hintText: 'Add skills, expertise, tags...',
//                       );
//                     },
//                   ),
//                   const SizedBox(height: 20),

//                   // PDF Picker
//                   GetX<AddProfileController>(
//                     builder: (controller) {
//                       return PdfPickerWidget(
//                         pdfFile: controller.pdfFile.value,
//                         pdfFileName: controller.pdfFileName.value,
//                         onPickPdf: controller.pickPdfFile,
//                         onRemovePdf: controller.clearPdfFile,
//                       );
//                     },
//                   ),
//                   const SizedBox(height: 20),

//                   // Save Button
//                   SizedBox(
//                     width: double.infinity,
//                     child: GetX<AddProfileController>(
//                       builder: (controller) {
//                         return ElevatedButton(
//                           onPressed: controller.loading.value
//                               ? null
//                               : () async {
//                                   // Validate form before proceeding
//                                   if (_formKey.currentState!.validate()) {
//                                     await controller.postProfileData();
//                                     // Force instant update of profile screen from stored data
//                                     if (Get.isRegistered<
//                                       GetProfileViewModel
//                                     >()) {
//                                       await Get.find<GetProfileViewModel>()
//                                           .loadFromStoredData();
//                                       Get.offAllNamed(
//                                         RoutesName.userProfileScreen,
//                                       );
//                                     }
//                                   }
//                                 },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: AppColor.primeColor,
//                             foregroundColor: Colors.white,
//                             padding: const EdgeInsets.symmetric(vertical: 16),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                           child: controller.loading.value
//                               ? const SizedBox(
//                                   height: 20,
//                                   width: 20,
//                                   child: CircularProgressIndicator(
//                                     color: Colors.white,
//                                     strokeWidth: 2,
//                                   ),
//                                 )
//                               : const Text(
//                                   'Save Profile',
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }

class AddProfileScreen extends StatefulWidget {
  const AddProfileScreen({super.key});

  @override
  State<AddProfileScreen> createState() => _AddProfileScreenState();
}

class _AddProfileScreenState extends State<AddProfileScreen> {
  final TextEditingController _chipController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GetProfileViewModel? profileController;

  @override
  Widget build(BuildContext context) {
    final AddProfileController controller = Get.put(AddProfileController());

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.appBodyBG,
        appBar: _buildAppBar(controller),
        body: Obx(() {
          if (!controller.isDataLoaded.value) {
            return Center(
              child: CircularProgressIndicator(color: AppColor.primeColor),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildPhotoPicker(controller),
                  const SizedBox(height: 20),
                  _buildNameField(controller),
                  const SizedBox(height: 20),
                  _buildPhoneField(controller),
                  const SizedBox(height: 20),
                  _buildAddressField(controller),
                  const SizedBox(height: 20),
                  _buildEmailField(controller),
                  const SizedBox(height: 20),
                  _buildSkillChips(controller),
                  const SizedBox(height: 20),
                  _buildPdfPicker(controller),
                  const SizedBox(height: 20),
                  _buildSaveButton(controller),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  /// -------------------- Widget Methods --------------------

  PreferredSizeWidget _buildAppBar(AddProfileController controller) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          controller.refreshStoredData();
        },
        tooltip: 'Refresh Profile Data',
      ),
      backgroundColor: AppColor.appBodyBG,
      title: const Text('Edit Profile', style: TextStyle(color: Colors.white)),
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }

  Widget _buildPhotoPicker(AddProfileController controller) {
    return CustomPhotoWidget(controller: controller);
  }

  Widget _buildNameField(AddProfileController controller) {
    return CustomInputField(
      controller: controller.nameController,
      fieldType: 'text',
      hintText: "Name",
      requiredField: true,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Name is required';
        return null;
      },
    );
  }

  Widget _buildPhoneField(AddProfileController controller) {
    return CustomInputField(
      controller: controller.phoneNumberController,
      fieldType: 'text',
      hintText: "Phone Number",
      requiredField: true,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Phone number is required';
        if (!RegExp(r'^[\d\s\-\(\)\+]+$').hasMatch(value)) {
          return 'Please enter a valid phone number';
        }
        return null;
      },
    );
  }

  Widget _buildAddressField(AddProfileController controller) {
    return CustomInputField(
      controller: controller.addressController,
      fieldType: 'text',
      hintText: "Address",
      requiredField: true,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Address is required';
        return null;
      },
    );
  }

  Widget _buildEmailField(AddProfileController controller) {
    return CustomInputField(
      controller: controller.emailController,
      fieldType: 'text',
      hintText: "Email",
      requiredField: true,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Email is required';
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        return null;
      },
    );
  }

  Widget _buildSkillChips(AddProfileController controller) {
    return GetX<AddProfileController>(
      builder: (controller) {
        return ChipInputField(
          selectedChips: controller.selectedChips.toList(),
          onChipAdded: controller.addChip,
          onChipRemoved: controller.removeChip,
          textController: _chipController,
          hintText: 'Add skills, expertise, tags...',
        );
      },
    );
  }

  Widget _buildPdfPicker(AddProfileController controller) {
    return GetX<AddProfileController>(
      builder: (controller) {
        return PdfPickerWidget(
          pdfFile: controller.pdfFile.value,
          pdfFileName: controller.pdfFileName.value,
          onPickPdf: controller.pickPdfFile,
          onRemovePdf: controller.clearPdfFile,
        );
      },
    );
  }

  Widget _buildSaveButton(AddProfileController controller) {
    return SizedBox(
      width: double.infinity,
      child: GetX<AddProfileController>(
        builder: (controller) {
          return ElevatedButton(
            onPressed: controller.loading.value
                ? null
                : () async {
                    if (_formKey.currentState!.validate()) {
                      await controller.postProfileData();

                      if (Get.isRegistered<GetProfileViewModel>()) {
                        await Get.find<GetProfileViewModel>()
                            .loadFromStoredData();
                        Get.offAllNamed(RoutesName.userProfileScreen);
                      }
                    }
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
          );
        },
      ),
    );
  }
}
