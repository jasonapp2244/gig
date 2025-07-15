// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:gig/res/colors/app_color.dart';
// import 'package:gig/res/routes/routes_name.dart';

// class GetStartedSecreen extends StatefulWidget {
//   const GetStartedSecreen({super.key});

//   @override
//   State<GetStartedSecreen> createState() => _GetStartedSecreenState();
// }

// class _GetStartedSecreenState extends State<GetStartedSecreen> {
//   @override
//   Widget build(BuildContext context) {
//     final screenSize = MediaQuery.of(context).size;
//     final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
//     final buttonPadding = isPortrait
//         ? EdgeInsets.symmetric(vertical: screenSize.height * 0.02, horizontal: screenSize.width * 0.1)
//         : EdgeInsets.symmetric(vertical: screenSize.height * 0.015, horizontal: screenSize.width * 0.05);

//     return Scaffold(
//       backgroundColor: AppColor.appBodyBG,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Container(
//             padding: EdgeInsets.symmetric(
//               horizontal: screenSize.width * 0.06,
//               vertical: screenSize.height * 0.02,
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 SizedBox(height: screenSize.height * 0.05),
//                 Text(
//                   'Let\'s Get Started!',
//                   style: TextStyle(
//                     fontSize: isPortrait
//                         ? screenSize.width * 0.08
//                         : screenSize.height * 0.06,
//                     color: AppColor.secondColor,
//                     fontWeight: FontWeight.w400,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(height: screenSize.height * 0.01),
//                 Text(
//                   'Lorem Ipsum is simply dummy text',
//                   style: TextStyle(
//                     fontSize: isPortrait
//                         ? screenSize.width * 0.035
//                         : screenSize.height * 0.025,
//                     color: AppColor.whiteColor,
//                     fontWeight: FontWeight.w400,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(height: screenSize.height * 0.05),

//                 // Social Login Buttons
//                 _buildSocialButton(
//                   context: context,
//                   iconPath: 'assets/images/login-icon1.png',
//                   text: 'Continue with google',
//                   padding: buttonPadding,
//                 ),
//                 SizedBox(height: screenSize.height * 0.015),
//                 _buildSocialButton(
//                   context: context,
//                   iconPath: 'assets/images/login-icon2.png',
//                   text: 'Continue with apple',
//                   padding: buttonPadding,
//                 ),
//                 SizedBox(height: screenSize.height * 0.015),
//                 _buildSocialButton(
//                   context: context,
//                   iconPath: 'assets/images/login-icon3.png',
//                   text: 'Continue with facebook',
//                   padding: buttonPadding,
//                 ),
//                 SizedBox(height: screenSize.height * 0.015),
//                 _buildSocialButton(
//                   context: context,
//                   iconPath: 'assets/images/login-icon4.png',
//                   text: 'Continue with twitter',
//                   padding: buttonPadding,
//                 ),
//                 SizedBox(height: screenSize.height * 0.05),

//                 // Sign Up Button
//                 _buildActionButton(
//                   context: context,
//                   text: 'Sign Up',
//                   backgroundColor: AppColor.primeColor,
//                   textColor: Colors.white,
//                   onTap: () => Get.toNamed(RoutesName.registerScreen),
//                   padding: buttonPadding,
//                 ),
//                 SizedBox(height: screenSize.height * 0.015),

//                 // Login Button
//                 _buildActionButton(
//                   context: context,
//                   text: 'Log in',
//                   backgroundColor: AppColor.whiteColor,
//                   textColor: Colors.black,
//                   onTap: () => Get.toNamed(RoutesName.loginScreen),
//                   padding: buttonPadding,
//                 ),
//                 SizedBox(height: screenSize.height * 0.05),

//                 // Privacy Policy
//                 Text(
//                   'Privacy Policy',
//                   style: TextStyle(
//                     fontSize: isPortrait
//                         ? screenSize.width * 0.035
//                         : screenSize.height * 0.025,
//                     color: Colors.grey,
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//                 SizedBox(height: screenSize.height * 0.02),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSocialButton({
//     required BuildContext context,
//     required String iconPath,
//     required String text,
//     required EdgeInsets padding,
//   }) {
//     final screenSize = MediaQuery.of(context).size;
//     final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

//     return Container(
//       padding: padding,
//       decoration: BoxDecoration(
//         color: AppColor.grayColor,
//         border: Border.all(color: Colors.white24, width: 1),
//         borderRadius: BorderRadius.circular(screenSize.width * 0.03),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Image.asset(
//             iconPath,
//             width: isPortrait ? screenSize.width * 0.06 : screenSize.height * 0.04,
//             height: isPortrait ? screenSize.width * 0.06 : screenSize.height * 0.04,
//           ),
//           SizedBox(width: screenSize.width * 0.02),
//           Flexible(
//             child: Text(
//               text,
//               style: TextStyle(
//                 fontSize: isPortrait
//                     ? screenSize.width * 0.035
//                     : screenSize.height * 0.025,
//                 color: Colors.white24,
//                 fontWeight: FontWeight.w400,
//               ),
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildActionButton({
//     required BuildContext context,
//     required String text,
//     required Color backgroundColor,
//     required Color textColor,
//     required VoidCallback onTap,
//     required EdgeInsets padding,
//   }) {
//     final screenSize = MediaQuery.of(context).size;

//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         width: double.infinity,
//         padding: padding,
//         decoration: BoxDecoration(
//           color: backgroundColor,
//           borderRadius: BorderRadius.circular(screenSize.width * 0.03),
//         ),
//         alignment: Alignment.center,
//         child: Text(
//           text,
//           style: TextStyle(
//             fontSize: screenSize.width * 0.04,
//             color: textColor,
//             fontWeight: FontWeight.w400,
//           ),
//         ),
//       ),
//     );
//   }
// }

//---------------Mutaal---------------------------/

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gig/res/colors/app_color.dart';
import 'package:gig/res/components/button.dart';
import 'package:gig/res/routes/routes_name.dart';
import 'package:gig/view/privacy_policy.dart';

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
        padding: EdgeInsets.only(top: 0, bottom: 0, left: 25, right: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
            SizedBox(height: 40),
            //  Container(
            //   padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
            //   decoration: BoxDecoration(
            //     color: AppColor.grayColor,
            //     border: Border.all(color: Colors.white24, width: 1),
            //     borderRadius: BorderRadius.circular(10),
            //   ),
            //   child: Row(
            //     children: [
            //       // Image.asset('assets/images/login-icon3.png'),
            //       SvgPicture.asset(
            //         'assets/images/google.svg',
            //         fit: BoxFit.contain,
            //       ),
            //       SizedBox(width: 3),
            //       Text(
            //         'Continue with facebook',
            //         style: TextStyle(
            //           fontSize: 16,
            //           color: AppColor.whiteColor,
            //           fontWeight: FontWeight.w400,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
              decoration: BoxDecoration(
                color: AppColor.grayColor,
                border: Border.all(color: Colors.white24, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  // Image.asset('assets/images/login-icon2.png'),
                  SvgPicture.asset(
                    'assets/images/devicon_google.svg',
                    fit: BoxFit.contain,
                  ),
                  SizedBox(width: 5),
                  Text(
                    'Continue with google',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColor.whiteColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
             Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
              decoration: BoxDecoration(
                color: AppColor.grayColor,
                border: Border.all(color: Colors.white24, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  // Image.asset('assets/images/login-icon2.png'),
                  SvgPicture.asset(
                    'assets/images/apple.svg',
                    fit: BoxFit.contain,
                  ),
                  SizedBox(width: 5),
                  Text(
                    'Continue with apple',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColor.whiteColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
              decoration: BoxDecoration(
                color: AppColor.grayColor,
                border: Border.all(color: Colors.white24, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  // Image.asset('assets/images/login-icon3.png'),
                  SvgPicture.asset(
                    'assets/images/facebook.svg',
                    fit: BoxFit.contain,
                  ),
                  SizedBox(width: 3),
                  Text(
                    'Continue with facebook',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColor.whiteColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
              decoration: BoxDecoration(
                color: AppColor.grayColor,
                border: Border.all(color: Colors.white24, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  // Image.asset('assets/images/login-icon4.png'),
                  SvgPicture.asset(
                    'assets/images/twitter.svg',
                    fit: BoxFit.contain,
                  ),
                  SizedBox(width: 5),
                  Text(
                    'Continue with twitter',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColor.whiteColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 40),
            Button(
              color: AppColor.primeColor,
              title: "Sign Up",
              textColor: AppColor.whiteColor,
              onTap: () {
                Get.toNamed(RoutesName.registerScreen);
              },
            ),
            SizedBox(height: 10),
            Button(
              color: AppColor.whiteColor,
              title: "Log In",
              textColor: AppColor.blackColor,
              onTap: () {
                Get.toNamed(RoutesName.loginScreen);
              },
            ),
            // InkWell(
            //   onTap: () {
            //     Get.toNamed(RoutesName.loginScreen);
            //   },
            //   child: Container(
            //     padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
            //     decoration: BoxDecoration(
            //       color: AppColor.whiteColor,
            //       borderRadius: BorderRadius.circular(10),
            //     ),
            //     alignment: Alignment.center,
            //     child: Text(
            //       'Log in',
            //       style: TextStyle(
            //         fontSize: 16,
            //         color: Colors.black,
            //         fontWeight: FontWeight.w400,
            //       ),
            //     ),
            //   ),
            // ),
            SizedBox(height: 40),
            InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PrivacyPolicy()),
              ),
              child: Text(
                'Privacy Policy',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
