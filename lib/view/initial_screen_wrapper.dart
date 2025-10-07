import 'package:flutter/material.dart';
import 'package:gig/utils/utils.dart';
import 'package:gig/view/auth/login_screen.dart';
import 'package:gig/view/onboarding_screen/onboarding_screen.dart';
import 'package:gig/view/screen_holder/screen_holder_screen.dart';
import 'package:gig/view/splash_screen.dart';
import 'package:gig/view_models/controller/splash/splash_controller.dart';

class InitialScreenWrapper extends StatefulWidget {
  const InitialScreenWrapper({super.key});

  @override
  State<InitialScreenWrapper> createState() => _InitialScreenWrapperState();
}

class _InitialScreenWrapperState extends State<InitialScreenWrapper> {
  Widget? _initialScreen;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _determineInitialScreen();
  }

  Future<void> _determineInitialScreen() async {
    try {
      // 1️⃣ Check if this is the first launch
      bool isFirstLaunch = await SplashController.isFirstLaunch();
      print('🔍 Is first launch: $isFirstLaunch');

      if (isFirstLaunch) {
        // First launch — show Splash first
        print('🟢 First launch → Splash + Onboarding flow');
        _initialScreen = SplashScreen(
       
        );
      } else {
        // 2️⃣ Not first launch → check if user is logged in
        String? token = await Utils.readSecureData('auth_token');
        print('🔍 Token exists: ${token != null && token.isNotEmpty}');

        if (token != null && token.isNotEmpty) {
          // Logged in
          print('🟢 Logged in → Home screen');
          _initialScreen = const ScreenHolderScreen();
        } else {
          // Not logged in
          print('🟡 Not logged in → Login screen');
          _initialScreen = const Login();
        }
      }
    } catch (e) {
      // Fallback if something goes wrong
      print('❌ Error determining initial screen: $e');
      _initialScreen = const SplashScreen();
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF0F1828),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFFA0101)),
        ),
      );
    }

    return _initialScreen ?? const SplashScreen();
  }
}
