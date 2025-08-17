import 'package:get/get.dart';
import 'package:gig/res/routes/routes_name.dart';
import 'package:gig/utils/utils.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _checkAuthAndNavigate();
  }

  void _checkAuthAndNavigate() async {
    // Wait for splash duration
    await Future.delayed(const Duration(seconds: 3));

    // Check if user is already logged in
    String? token = await Utils.readSecureData('auth_token');

    if (token != null && token.isNotEmpty) {
      // User is logged in - go directly to home screen
      Get.offAllNamed(RoutesName.screenHolderScreen);
    } else {
      // User is not logged in - go to onboarding
      Get.offAllNamed(RoutesName.onBoardingScreen);
    }
  }
}
