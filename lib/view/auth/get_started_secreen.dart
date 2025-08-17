import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gig/res/colors/app_color.dart';
import 'package:gig/res/components/button.dart';
import 'package:gig/res/routes/routes_name.dart';
import 'package:gig/view/privacy_policy.dart';

// class GetStartedSecreen extends StatefulWidget {
//   const GetStartedSecreen({super.key});

//   @override
//   State<GetStartedSecreen> createState() => _GetStartedSecreenState();
// }

// class _GetStartedSecreenState extends State<GetStartedSecreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColor.appBodyBG,
//       body: Container(
//         padding: EdgeInsets.only(top: 0, bottom: 0, left: 25, right: 25),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Let’s Get Started!',
//               style: TextStyle(
//                 fontSize: 24,
//                 color: AppColor.secondColor,
//                 fontWeight: FontWeight.bold,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             Text(
//               'Lorem Ipsum is simply dummy text',
//               style: TextStyle(
//                 fontSize: 12,
//                 color: AppColor.whiteColor,
//                 fontWeight: FontWeight.w400,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 40),

//             Container(
//               padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
//               decoration: BoxDecoration(
//                 color: AppColor.grayColor,
//                 border: Border.all(color: Colors.white24, width: 1),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Row(
//                 children: [
//                   // Image.asset('assets/images/login-icon2.png'),
//                   SvgPicture.asset(
//                     'assets/images/devicon_google.svg',
//                     fit: BoxFit.contain,
//                   ),
//                   SizedBox(width: 5),
//                   Text(
//                     'Continue with google',
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: AppColor.whiteColor,
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 10),
//             Container(
//               padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
//               decoration: BoxDecoration(
//                 color: AppColor.grayColor,
//                 border: Border.all(color: Colors.white24, width: 1),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Row(
//                 children: [
//                   // Image.asset('assets/images/login-icon2.png'),
//                   Container(
//                     width: 20,
//                     height: 20,
//                     child: SvgPicture.asset(
//                       'assets/images/apple.svg',
//                       fit: BoxFit.contain,
//                     ),
//                   ),
//                   SizedBox(width: 5),
//                   Text(
//                     'Continue with apple',
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: AppColor.whiteColor,
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 10),
//             Container(
//               padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
//               decoration: BoxDecoration(
//                 color: AppColor.grayColor,
//                 border: Border.all(color: Colors.white24, width: 1),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Row(
//                 children: [
//                   // Image.asset('assets/images/login-icon3.png'),
//                   Container(
//                     width: 20,
//                     height: 20,
//                     child: SvgPicture.asset(
//                       'assets/images/facebook.svg',
//                       fit: BoxFit.contain,
//                     ),
//                   ),
//                   SizedBox(width: 3),
//                   Text(
//                     'Continue with facebook',
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: AppColor.whiteColor,
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 10),
//             Container(
//               padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
//               decoration: BoxDecoration(
//                 color: AppColor.grayColor,
//                 border: Border.all(color: Colors.white24, width: 1),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Row(
//                 children: [
//                   // Image.asset('assets/images/login-icon4.png'),
//                   SvgPicture.asset(
//                     'assets/images/twitter.svg',
//                     fit: BoxFit.contain,
//                   ),
//                   SizedBox(width: 5),
//                   Text(
//                     'Continue with twitter',
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: AppColor.whiteColor,
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             SizedBox(height: 40),
//             Button(
//               color: AppColor.primeColor,
//               title: "Sign Up",
//               textColor: AppColor.whiteColor,
//               onTap: () {
//                 Get.toNamed(RoutesName.registerScreen);
//               },
//             ),
//             SizedBox(height: 10),
//             Button(
//               color: AppColor.whiteColor,
//               title: "Log In",
//               textColor: AppColor.blackColor,
//               onTap: () {
//                 Get.toNamed(RoutesName.loginScreen);
//               },
//             ),

//             SizedBox(height: 40),
//             InkWell(
//               onTap: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => PrivacyPolicy()),
//               ),
//               child: Text(
//                 'Privacy Policy',
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.grey,
//                   fontWeight: FontWeight.w400,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
class GetStartedSecreen extends StatefulWidget {
  const GetStartedSecreen({super.key});

  @override
  State<GetStartedSecreen> createState() => _GetStartedSecreenState();
}

class _GetStartedSecreenState extends State<GetStartedSecreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBodyBG,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildHeader(),
            const SizedBox(height: 40),
            _buildSocialButtons(),
            const SizedBox(height: 40),
            _buildActionButtons(),
            const SizedBox(height: 40),
            _buildPrivacyPolicy(context),
          ],
        ),
      ),
    );
  }

  /// ----------------- HEADER -----------------
  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          'Let’s Get Started!',
          style: TextStyle(
            fontSize: 24,
            color: AppColor.secondColor,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          'Lorem Ipsum is simply dummy text',
          style: TextStyle(
            fontSize: 12,
            color: AppColor.whiteColor,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// ----------------- SOCIAL BUTTONS -----------------
  Widget _buildSocialButtons() {
    return Column(
      children: [
        _socialButton(
          icon: 'assets/images/devicon_google.svg',
          text: 'Continue with google',
        ),
        const SizedBox(height: 10),
        _socialButton(
          icon: 'assets/images/apple.svg',
          text: 'Continue with apple',
          iconSize: 20,
        ),
        const SizedBox(height: 10),
        _socialButton(
          icon: 'assets/images/facebook.svg',
          text: 'Continue with facebook',
          iconSize: 20,
        ),
        const SizedBox(height: 10),
        _socialButton(
          icon: 'assets/images/twitter.svg',
          text: 'Continue with twitter',
        ),
      ],
    );
  }

  Widget _socialButton({
    required String icon,
    required String text,
    double iconSize = 22,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
      decoration: BoxDecoration(
        color: AppColor.grayColor,
        border: Border.all(color: Colors.white24, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: iconSize,
            height: iconSize,
            child: SvgPicture.asset(icon, fit: BoxFit.contain),
          ),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: AppColor.whiteColor,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  /// ----------------- SIGNUP & LOGIN BUTTONS -----------------
  Widget _buildActionButtons() {
    return Column(
      children: [
        Button(
          color: AppColor.primeColor,
          title: "Sign Up",
          textColor: AppColor.whiteColor,
          onTap: () => Get.toNamed(RoutesName.registerScreen),
        ),
        const SizedBox(height: 10),
        Button(
          color: AppColor.whiteColor,
          title: "Log In",
          textColor: AppColor.blackColor,
          onTap: () => Get.toNamed(RoutesName.loginScreen),
        ),
      ],
    );
  }

  /// ----------------- PRIVACY POLICY -----------------
  Widget _buildPrivacyPolicy(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => PrivacyPolicy()),
      ),
      child: Text(
        'Privacy Policy',
        style: const TextStyle(
          fontSize: 16,
          color: Colors.grey,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
