import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:gig/view_models/controller/profile/add_profile_controller.dart';

class CustomPhotoWidget extends StatelessWidget {
  final AddProfileController? controller;

  const CustomPhotoWidget({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Obx(() {
          final file = controller?.imageFile.value;
          return GestureDetector(
            onTap: controller?.pickImage,
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.orange,
              child: file == null
                  ? const Icon(
                      Icons.add_photo_alternate,
                      color: Colors.white,
                      size: 35,
                    )
                  : ClipOval(
                      child: Image.file(
                        file,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
          );
        }),
        const SizedBox(height: 8),
        const Text(
          "Add photo",
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
      ],
    );
  }
}
