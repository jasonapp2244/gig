import 'package:get/get.dart';
import 'package:gig/utils/utils.dart';

class HomeViewModel extends GetxController {
  RxString userName = 'User'.obs;
  RxString userEmail = 'user@example.com'.obs;
  RxString profileImage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  Future<void> loadUserData() async {
    try {
      // Load user data from secure storage
      String? name = await Utils.readSecureData('user_name');
      String? email = await Utils.readSecureData('user_email');
      String? avatar = await Utils.readSecureData('user_avatar');

      if (name != null && name.isNotEmpty) {
        userName.value = name;
      }
      
      if (email != null && email.isNotEmpty) {
        userEmail.value = email;
      }
      
      if (avatar != null && avatar.isNotEmpty) {
        profileImage.value = avatar;
      }

      print('✅ Loaded user data: $name, $email');
    } catch (e) {
      print('❌ Error loading user data: $e');
    }
  }

  Future<void> refreshUserData() async {
    await loadUserData();
  }
}

