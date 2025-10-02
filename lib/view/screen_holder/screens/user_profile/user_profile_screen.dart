
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gig/res/components/bottom_banner_ads.dart';
import 'package:gig/res/routes/routes_name.dart';
import '../../../../res/colors/app_color.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
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
      profileController.refreshProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBodyBG,
      appBar: AppBar(
        backgroundColor: AppColor.appBodyBG,
        elevation: 0,
        centerTitle: true,
        leading: Icon(Icons.arrow_back, color: AppColor.whiteColor),
        title: Text(
          'Profile',
          style: TextStyle(
            color: AppColor.secondColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (profileController.loading.value) {
            return _buildLoading();
          }

          if (profileController.error.value.isNotEmpty) {
            return _buildError();
          }

          return RefreshIndicator(
            onRefresh: () => profileController.refreshProfile(),
            color: AppColor.primeColor,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildEditButton(),
                  _buildProfileHeader(profileController.userName),
                  const SizedBox(height: 30),
                  _buildSkillsSection(),
                  const SizedBox(height: 20),
                  BottomBannerAd(),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  /// 🔄 Loading State
  Widget _buildLoading() {
    return Center(child: CircularProgressIndicator(color: AppColor.primeColor));
  }

  /// ❌ Error State
  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 64),
          const SizedBox(height: 16),
          const Text(
            'Failed to load profile',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            profileController.error.value,
            style: const TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => profileController.refreshProfile(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primeColor,
            ),
            child: const Text('Retry', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    if (name.trim().isEmpty) return "?";

    // Split name into parts (first + last)
    List<String> parts = name.trim().split(" ");
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    } else {
      return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
          .toUpperCase();
    }
  }

  /// ✏️ Edit Profile Button
  Widget _buildEditButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.red),
          onPressed: () => Get.toNamed(RoutesName.profileViewScreen),
        ),
      ],
    );
  }

  /// 👤 Profile Header (image, name, email, bio, contact, resume)
  Widget _buildProfileHeader(String name) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: AppColor.primeColor,
          child: Text(
            _getInitials(name),
            style: TextStyle(
              color: AppColor.appBodyBG,
              fontWeight: FontWeight.bold,
              fontSize: 12 * 0.7,
            ),
          ),
        ),
        const SizedBox(height: 12),
        _buildUserInfo(),
        const SizedBox(height: 20),
        _buildContactIcons(),
        const SizedBox(height: 30),
        if (profileController.resumeUrl.isNotEmpty ||
            profileController.resumeName.isNotEmpty)
          _buildResumeBox(),
      ],
    );
  }

  // Widget _buildProfileImage() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       Expanded(
  //         child: Center(
  //           child: CustomPhotoWidget(
  //             radius: 50,
  //             backgroundColor: AppColor.primeColor,
  //             imageUrl: profileController.profileImage.isNotEmpty
  //                 ? profileController.profileImage
  //                 : null,
  //             onImagePicked: (File? imageFile) async {
  //               const storage = FlutterSecureStorage();
  //               if (imageFile != null) {
  //                 profileController.profileData.value = {
  //                   ...profileController.profileData.value,
  //                   'profile_image': imageFile.path,
  //                 };
  //                 await storage.write(
  //                   key: 'user_profile',
  //                   value: jsonEncode(profileController.profileData.value),
  //                 );
  //               } else {
  //                 profileController.profileData.value = {
  //                   ...profileController.profileData.value,
  //                   'profile_image': '',
  //                 };
  //                 await storage.write(
  //                   key: 'user_profile',
  //                   value: jsonEncode(profileController.profileData.value),
  //                 );
  //               }
  //             },
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildUserInfo() {
    return Column(
      children: [
        Text(
          profileController.userName,
          style: TextStyle(
            color: AppColor.primeColor,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          profileController.userEmail,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
        const SizedBox(height: 6),
        Obx(() {
          return Text(
            profileController.userBio.isNotEmpty
                ? profileController.userBio
                : profileController.userAddress.isNotEmpty
                ? profileController.userAddress
                : 'No description available',
            style: const TextStyle(color: Colors.white70, fontSize: 13),
            textAlign: TextAlign.center,
          );
        }),
      ],
    );
  }

  Widget _buildContactIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (profileController.userPhone.isNotEmpty) ...[
          Tooltip(
            message: profileController.userPhone,
            child: const Icon(Icons.phone, color: Colors.white),
          ),
          const SizedBox(width: 20),
        ],
        Tooltip(
          message: profileController.userEmail,
          child: const Icon(Icons.email, color: Colors.white),
        ),
        const SizedBox(width: 20),
        if (profileController.userAddress.isNotEmpty)
          Tooltip(
            message: profileController.userAddress,
            child: const Icon(Icons.location_on, color: Colors.white),
          ),
      ],
    );
  }

  Widget _buildResumeBox() {
    return GestureDetector(
      onTap: profileController.downloadPdf,
      child: Container(
        padding: const EdgeInsets.all(16),
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
                  const Text(
                    "My Resume",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    profileController.resumeName,
                    style: const TextStyle(color: Colors.black87),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(Icons.download, color: Colors.black),
          ],
        ),
      ),
    );
  }

  /// 🛠 Skills Section
  Widget _buildSkillsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Skills',
          style: TextStyle(
            color: AppColor.secondColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 16,
          children:
              (profileController.userSkills.isNotEmpty
                      ? profileController.userSkills
                      : [])
                  .take(10)
                  .map((skill) {
                    double skillPercent =
                        (0.6 +
                                (profileController.userSkills.indexOf(skill) *
                                    0.05))
                            .clamp(0.0, 1.0);
                    return _buildSkillBox(skill.toString(), skillPercent);
                  })
                  .toList(),
        ),
      ],
    );
  }

  Widget _buildSkillBox(String skill, double percent) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            skill,
            style: const TextStyle(color: Colors.black, fontSize: 13),
          ),
          const SizedBox(height: 6),
          LinearPercentIndicator(
            lineHeight: 6,
            percent: percent,
            backgroundColor: Colors.white,
            progressColor: Colors.orange,
            barRadius: const Radius.circular(6),
            animation: true,
          ),
        ],
      ),
    );
  }
}
