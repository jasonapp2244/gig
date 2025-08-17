import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gig/res/colors/app_color.dart';
import 'package:gig/view_models/controller/splash/splash_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize the splash controller which will handle authentication check
    Get.put(SplashController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBodyBG,
      body: Center(
        child: SvgPicture.asset(
          'assets/images/Layer_1.svg',
          width: MediaQuery.of(context).size.width * 0.6, // Responsive size
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
