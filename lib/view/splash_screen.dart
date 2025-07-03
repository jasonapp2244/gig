import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gig/res/colors/app_color.dart';
import 'package:gig/view/onboarding_screen/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => OnboardingScreen()),
      );
    });
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



// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';


// import '../res/colors/app_color.dart';
// import '../res/routes/routes_name.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     Timer(Duration(seconds: 3), () {
//       Get.offAllNamed(RoutesName.onBoardingScreen);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColor.appBodyBG,
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           // Image.asset('assets/images/background.jpg', fit: BoxFit.cover,),
//           Center(
//             child: Image.asset('assets/images/splash_image.svg',)
//           ),
//         ],
//       ),
//     );
//   }
// }
