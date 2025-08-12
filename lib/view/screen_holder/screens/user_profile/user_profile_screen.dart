import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gig/res/routes/routes.dart';
import 'package:gig/res/routes/routes_name.dart';
import '../../../../res/colors/app_color.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../../../res/components/custom_photo_widget.dart';
import '../../../../view_models/controller/profile/get_profile_view_model.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late final GetProfileViewModel profileController;

  @override
  void initState() {
    super.initState();
    profileController = Get.put(GetProfileViewModel());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('🔄 UserProfileScreen: Refreshing profile data...');
      profileController.refreshProfile();
    });
  }

  @override
  void didUpdateWidget(UserProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Refresh when widget updates (like when returning from another screen)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      profileController.loadFromStoredData();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // This is called when the screen becomes visible again
    WidgetsBinding.instance.addPostFrameCallback((_) {
      profileController.loadFromStoredData();
    });
  }

  @override
  Widget build(BuildContext context) {
    Get.put(GetProfileViewModel());
    return Scaffold(
      backgroundColor: AppColor.appBodyBG,
      body: SafeArea(
        child: Obx(() {
          if (profileController.loading.value) {
            return Center(
              child: CircularProgressIndicator(color: AppColor.primeColor),
            );
          }

          if (profileController.error.value.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 64),
                  SizedBox(height: 16),
                  Text(
                    'Failed to load profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    profileController.error.value,
                    style: TextStyle(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => profileController.refreshProfile(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primeColor,
                    ),
                    child: Text('Retry', style: TextStyle(color: Colors.black)),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => profileController.refreshProfile(),
            color: AppColor.primeColor,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Image + Edit Icon
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        color: Colors.red,
                        onPressed: () {
                          Get.toNamed(RoutesName.profileViewScreen);
                        },
                      ),
                    ],
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Center(
                              child: CustomPhotoWidget(
                                radius: 50,
                                backgroundColor: AppColor.primeColor,
                                imageUrl:
                                    profileController.profileImage.isNotEmpty
                                    ? profileController.profileImage
                                    : null,
                                                               onImagePicked: (File? imageFile) async {
                                 if (imageFile != null) {
                                   print(
                                     'Profile image picked: ${imageFile.path}',
                                   );
                                   // Save the image path to profile data immediately
                                   profileController.profileData.value = {
                                     ...profileController.profileData.value,
                                     'profile_image': imageFile.path,
                                   };
                                   
                                   // Save to secure storage
                                   const storage = FlutterSecureStorage();
                                   await storage.write(
                                     key: 'user_profile',
                                     value: jsonEncode(profileController.profileData.value),
                                   );
                                   print('✅ Profile image saved to storage');
                                 } else {
                                   print('Profile image removed');
                                   // Remove image from profile data
                                   profileController.profileData.value = {
                                     ...profileController.profileData.value,
                                     'profile_image': '',
                                   };
                                   
                                   // Update secure storage
                                   const storage = FlutterSecureStorage();
                                   await storage.write(
                                     key: 'user_profile',
                                     value: jsonEncode(profileController.profileData.value),
                                   );
                                 }
                               },
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),

                      // User Name
                      Text(
                        profileController.userName,
                        style: TextStyle(
                          color: AppColor.primeColor,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6),

                      // Email
                      Text(
                        profileController.userEmail,
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      SizedBox(height: 6),

                      // Bio or Address
                      Obx(() {
                        print(
                          '📍 Profile Image: ${profileController.profileImage}',
                        );
                        print(
                          '📍 User Address: ${profileController.userAddress}',
                        );
                        print('📍 User Bio: ${profileController.userBio}');

                        return Text(
                          profileController.userBio.isNotEmpty
                              ? profileController.userBio
                              : profileController.userAddress.isNotEmpty
                              ? profileController.userAddress
                              : 'No description available',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                          textAlign: TextAlign.center,
                        );
                      }),
                      SizedBox(height: 20),

                      // Contact Icons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (profileController.userPhone.isNotEmpty) ...[
                            Tooltip(
                              message: profileController.userPhone,
                              child: Icon(Icons.phone, color: Colors.white),
                            ),
                            SizedBox(width: 20),
                          ],
                          Tooltip(
                            message: profileController.userEmail,
                            child: Icon(Icons.email, color: Colors.white),
                          ),
                          SizedBox(width: 20),
                          if (profileController.userAddress.isNotEmpty)
                            Tooltip(
                              message: profileController.userAddress,
                              child: Icon(
                                Icons.location_on,
                                color: Colors.white,
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 30),

                      // Resume Box
                      if (profileController.resumeUrl.isNotEmpty ||
                          profileController.resumeName.isNotEmpty)
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColor.primeColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "My Resume",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      profileController.resumeName,
                                      style: TextStyle(color: Colors.black87),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              Icon(Icons.download, color: Colors.black),
                            ],
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 30),

                  // Skills Section
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Skills',
                      style: TextStyle(
                        color: AppColor.secondColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    runSpacing: 16,
                    children:
                        (profileController.userSkills.isNotEmpty
                                ? profileController.userSkills
                                : [
                                    "General Skills",
                                    "Problem Solving",
                                    "Communication",
                                  ])
                            .take(10)
                            .map((skill) {
                              double skillPercent =
                                  (0.6 +
                                          (profileController.userSkills.indexOf(
                                                skill,
                                              ) *
                                              0.05))
                                      .clamp(0.0, 1.0);
                              return buildSkillBox(
                                skill.toString(),
                                skillPercent,
                              );
                            })
                            .toList(),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget buildSkillBox(String skill, double percent) {
    return Container(
      width: 100,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(skill, style: TextStyle(color: Colors.white, fontSize: 13)),
          SizedBox(height: 6),
          LinearPercentIndicator(
            lineHeight: 6,
            percent: percent,
            backgroundColor: Colors.white30,
            progressColor: Colors.orange,
            barRadius: Radius.circular(6),
            animation: true,
          ),
        ],
      ),
    );
  }
}
