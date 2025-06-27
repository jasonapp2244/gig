import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../res/colors/app_color.dart';
import '../res/routes/routes_name.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Get.offAllNamed(RoutesName.onBoardingScreen);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBodyBG,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Image.asset('assets/images/background.jpg', fit: BoxFit.cover,),
          Center(
            child: Image.asset('assets/images/logo.png',)
          ),
        ],
      ),
    );
  }
}
