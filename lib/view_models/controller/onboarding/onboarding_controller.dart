import 'package:get/get.dart';
import 'package:gig/res/routes/routes_name.dart';
import 'package:gig/utils/utils.dart';

class OnboardingController extends GetxController {
  void _checkAuthAndNavigate() async {
    // Wait for splash duration
    await Future.delayed(Duration(seconds: 3));

    // Check auth token
    String? token = await Utils.readSecureData('auth_token');

    if (token != null && token.isNotEmpty) {
      // User is logged in - go to home
      Get.offAllNamed(RoutesName.screenHolderScreen);
    } else {
      // User needs onboarding/login
      Get.offAllNamed(RoutesName.loginScreen);
    }
  }
}
