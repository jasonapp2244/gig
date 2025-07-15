// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:gig/res/colors/app_color.dart';
// import 'package:gig/res/routes/routes_name.dart';

// class OnboardingScreen extends StatefulWidget {
//   const OnboardingScreen({super.key});

//   @override
//   State<OnboardingScreen> createState() => _OnboardingScreenState();
// }

// class _OnboardingScreenState extends State<OnboardingScreen> {
//   final PageController _controller = PageController();
//   int _currentIndex = 0;

//   final List<Map<String, dynamic>> _pages = [
//     {
//       'image': 'assets/images/onboarding-img1.png',
//       'title': 'Task Management',
//       'subtitle': "Let's create a space for your workflows.",
//     },
//     {
//       'image': 'assets/images/onboarding-img2.png',
//       'title': 'Task Management',
//       'subtitle': "Work more Structured and Organized",
//     },
//     {
//       'image': 'assets/images/onboarding-img3.png',
//       'title': 'Task Management',
//       'subtitle': "Manage your Tasks quickly for Results",
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       backgroundColor: AppColor.appBodyBG,
//       body: SafeArea(
//         child: PageView.builder(
//           controller: _controller,
//           onPageChanged: (index) {
//             setState(() {
//               _currentIndex = index;
//             });
//           },
//           itemCount: _pages.length,
//           itemBuilder: (context, index) {
//             return buildPage(_pages[index], index, screenHeight, screenWidth);
//           },
//         ),
//       ),
//     );
//   }

//   Widget buildPage(
//     Map<String, dynamic> data,
//     int index,
//     double screenHeight,
//     double screenWidth,
//   ) {
//     final isLastPage = index == _pages.length - 1;
//     final isFirstPage = index == 0;

//     return SingleChildScrollView(
//       child: ConstrainedBox(
//         constraints: BoxConstraints(minHeight: screenHeight),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             // Image Section
//             Container(
//               height: screenHeight * 0.45,
//               padding: EdgeInsets.symmetric(
//                 horizontal: screenWidth * 0.05,
//                 vertical: screenHeight * 0.02,
//               ),
//               child: Image.asset(data['image'], fit: BoxFit.contain),
//             ),

//             // Text Content Section
//             Container(
//               padding: EdgeInsets.symmetric(
//                 horizontal: screenWidth * 0.08,
//                 vertical: screenHeight * 0.02,
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     data['title'],
//                     style: TextStyle(
//                       fontSize: screenWidth * 0.045, // Responsive font size
//                       fontWeight: FontWeight.w500,
//                       color: AppColor.primeColor,
//                     ),
//                   ),
//                   SizedBox(height: screenHeight * 0.01),
//                   data['subtitle'].contains('space')
//                       ? RichText(
//                           text: TextSpan(
//                             text: "Let's create a ",
//                             style: TextStyle(
//                               color: AppColor.whiteColor,
//                               fontSize:
//                                   screenWidth * 0.08, // Responsive font size
//                               fontWeight: FontWeight.w400,
//                             ),
//                             children: [
//                               TextSpan(
//                                 text: 'space',
//                                 style: TextStyle(
//                                   color: AppColor.primeColor,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                               TextSpan(
//                                 text: ' for your workflows.',
//                                 style: TextStyle(
//                                   color: AppColor.whiteColor,
//                                   fontSize:
//                                       screenWidth *
//                                       0.08, // Responsive font size
//                                   fontWeight: FontWeight.w400,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         )
//                       : Text(
//                           data['subtitle'],
//                           style: TextStyle(
//                             color: AppColor.whiteColor,
//                             fontSize:
//                                 screenWidth * 0.08, // Responsive font size
//                             fontWeight: FontWeight.w400,
//                           ),
//                         ),
//                 ],
//               ),
//             ),

//             // Spacer to push content up
//             SizedBox(height: screenHeight * 0.02),

//             // Dots Indicator
//             Container(
//               padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: List.generate(_pages.length, (i) {
//                   return AnimatedContainer(
//                     duration: const Duration(milliseconds: 300),
//                     margin: EdgeInsets.symmetric(
//                       horizontal: screenWidth * 0.01,
//                     ),
//                     width: _currentIndex == i
//                         ? screenWidth * 0.08
//                         : screenWidth * 0.03,
//                     height: screenHeight * 0.01,
//                     decoration: BoxDecoration(
//                       color: _currentIndex == i ? Colors.white : Colors.grey,
//                       borderRadius: BorderRadius.circular(screenWidth * 0.02),
//                     ),
//                   );
//                 }),
//               ),
//             ),

//             // Buttons Section
//             Container(
//               padding: EdgeInsets.symmetric(
//                 horizontal: screenWidth * 0.08,
//                 vertical: screenHeight * 0.04,
//               ),
//               child: isLastPage
//                   ? SizedBox(
//                       width: double.infinity,
//                       height: screenHeight * 0.07,
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: AppColor.primeColor,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(
//                               screenWidth * 0.03,
//                             ),
//                           ),
//                         ),
//                         onPressed: () {
//                           Get.toNamed(RoutesName.getStartedScreen);
//                         },
//                         child: Text(
//                           'Get Started',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: screenWidth * 0.04,
//                           ),
//                         ),
//                       ),
//                     )
//                   : Row(
//                       children: [
//                         Expanded(
//                           child: SizedBox(
//                             height: screenHeight * 0.07,
//                             child: OutlinedButton(
//                               style: OutlinedButton.styleFrom(
//                                 side: const BorderSide(color: Colors.black),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(
//                                     screenWidth * 0.03,
//                                   ),
//                                 ),
//                                 backgroundColor: Colors.white,
//                               ),
//                               onPressed: () {
//                                 _controller.jumpToPage(_pages.length - 1);
//                               },
//                               child: Text(
//                                 'Skip',
//                                 style: TextStyle(
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: screenWidth * 0.04,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),

//                         SizedBox(width: screenWidth * 0.03),
//                         Expanded(
//                           child: SizedBox(
//                             height: screenHeight * 0.07,
//                             child: ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: AppColor.primeColor,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(
//                                     screenWidth * 0.03,
//                                   ),
//                                 ),
//                               ),
//                               onPressed: () {
//                                 _controller.nextPage(
//                                   duration: const Duration(milliseconds: 300),
//                                   curve: Curves.easeIn,
//                                 );
//                               },
//                               child: Text(
//                                 'Continue',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: screenWidth * 0.04,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

///----------------mutaaal code---/
library;


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gig/res/colors/app_color.dart';
import 'package:gig/res/routes/routes_name.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'image': 'assets/images/onboarding-img1.png',
      'title': 'Task Management',
      'subtitle': "Let's create a space for your workflows.",
    },
    {
      'image': 'assets/images/onboarding-img2.png',
      'title': 'Task Management',
      'subtitle': "Work more Structured and Organized",
    },
    {
      'image': 'assets/images/onboarding-img3.png',
      'title': 'Task Management',
      'subtitle': "Manage your Tasks quickly for Results",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBodyBG,
      body: PageView.builder(
        controller: _controller,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemCount: _pages.length,
        itemBuilder: (context, index) {
          return buildPage(_pages[index], index);
        },
      ),
    );
  }

  Widget buildPage(Map<String, dynamic> data, int index) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(data['image'], fit: BoxFit.contain),
          const SizedBox(height: 20),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              spacing: 10,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['title'],
                  style:  GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColor.primeColor,
                  ),
                ),
                // const SizedBox(height: 8),
                data['subtitle'].contains('space')
                    ? RichText(
                        text: TextSpan(
                          text: "Let's create a ",
                          style: GoogleFonts.poppins(
                            color: AppColor.whiteColor,
                            fontSize: 35,
                            fontWeight: FontWeight.w400,
                          ),
                          children: [
                            TextSpan(
                              text: 'space',
                              style: GoogleFonts.poppins(
                                color: AppColor.primeColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text: ' for your workflows.',
                              style: GoogleFonts.poppins(
                                color: AppColor.whiteColor,
                                fontSize: 35,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Text(
                        data['subtitle'],
                        style: GoogleFonts.poppins(
                          color: AppColor.whiteColor,
                          fontSize: 35,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Bullets
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_pages.length, (i) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentIndex == i ? 30 : 10,
                height: 10,
                decoration: BoxDecoration(
                  color: _currentIndex == i ? Colors.white : Colors.grey,
                  borderRadius: BorderRadius.circular(5),
                ),
              );
            }),
          ),

          const SizedBox(height: 30),

          // Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _currentIndex == 2
                ? Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColor.primeColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Get.toNamed(RoutesName.getStartedScreen);
                      },
                      child: Text(
                        'Get Started',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  )
                : Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextButton(
                            onPressed: () {
                              _controller.jumpToPage(_pages.length - 1);
                            },
                            child: Text(
                              'Skip',
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColor.primeColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextButton(
                            onPressed: () {
                              _controller.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeIn,
                              );
                            },
                            child:  Text(
                              'Continue',
                              style: GoogleFonts.poppins(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
