import 'package:get/get.dart';
import 'package:gig/res/routes/routes_name.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController {
  static const String _isFirstLaunchKey = 'is_first_launch';

  @override
  void onInit() {
    super.onInit();
    _checkFirstLaunchAndNavigate();
  }

  void _checkFirstLaunchAndNavigate() async {
    // This method is only called when splash screen is shown (first launch)
    // Show splash screen for 3 seconds on first launch only
    await Future.delayed(const Duration(seconds: 3));
    await _setFirstLaunchComplete();

    // On first launch, always go to onboarding screen
    // (regardless of authentication status)
    Get.offAllNamed(RoutesName.onBoardingScreen);
  }

  Future<void> _setFirstLaunchComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isFirstLaunchKey, false);
  }

  // Method to reset first launch (useful for testing or app reset)
  Future<void> resetFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isFirstLaunchKey, true);
  }

  // Static method to check first launch from anywhere in the app
  static Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isFirstLaunchKey) ?? true;
  }

  // Static method to mark first launch as complete from anywhere in the app
  static Future<void> markFirstLaunchComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isFirstLaunchKey, false);
  }

  // Static method to reset first launch flag (useful for testing or app reset)
  static Future<void> resetFirstLaunchFlag() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isFirstLaunchKey, true);
  }
}
