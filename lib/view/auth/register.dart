//  Container(
//             padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
//             decoration: BoxDecoration(
//               color: AppColor.grayColor,
//               border: Border.all(color: Colors.white24, width: 1),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Row(
//               children: [
//                 // Image.asset('assets/images/login-icon3.png'),
//                 SvgPicture.asset(
//                   'assets/images/facebook.svg',
//                   fit: BoxFit.contain,
//                 ),
//                 SizedBox(width: 3),
//                 Text(
//                   'Continue with facebook',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: AppColor.whiteColor,
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//               ],
//             ),
//           ),

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gig/res/components/button.dart';
import 'package:gig/res/routes/routes_name.dart';
import 'package:gig/view/screen_holder/screen_holder_screen.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../res/colors/app_color.dart';
import '../../res/components/input.dart';
import '../../view_models/controller/auth/login_view_model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final LoginVM = Get.put(LoginVewModel());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBodyBG,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(
                  top: 0,
                  bottom: 0,
                  left: 25,
                  right: 25,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15),
                    Text(
                      'Join Task App Today',
                      style: TextStyle(
                        fontSize: 24,
                        color: AppColor.secondColor,
                        fontWeight: FontWeight.w600,
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
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 30),
                          Text(
                            "Email",
                            style: GoogleFonts.poppins(
                              color: AppColor.textColor,
                              fontSize: 16,
                            ),
                          ),
                          CustomInputField(
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: AppColor.textColor,
                            ),
                            controller: LoginVM.emailController.value,
                            fieldType: 'email',
                            hintText: "Email",
                            requiredField: true,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Name is required';
                              }
                              return 'Name is Required';
                            },
                          ),
                          SizedBox(height: 15),
                          Text(
                            "Password",
                            style: GoogleFonts.poppins(
                              color: AppColor.textColor,
                              fontSize: 16,
                            ),
                          ),
                          CustomInputField(
                            prefixIcon: Icon(
                              Icons.password,
                              color: AppColor.textColor,
                            ),
                            controller: LoginVM.passwordController.value,
                            fieldType: 'password',
                            hintText: "Password",
                            requiredField: true,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Password is required';
                              }
                              return 'Password is Required';
                            },
                          ),
                          SizedBox(height: 15),
                          Text(
                            "Confirm Password",
                            style: GoogleFonts.poppins(
                              color: AppColor.textColor,
                              fontSize: 16,
                            ),
                          ),
                          CustomInputField(
                            prefixIcon: Icon(
                              Icons.password,
                              color: AppColor.textColor,
                            ),
                            controller: LoginVM.confirmpasswordController.value,
                            fieldType: "confirm password",
                            hintText: "Confirm Password",
                            requiredField: true,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Confirm Password is required';
                              }
                              return 'Confirm Password is Required';
                            },
                          ),

                          // Obx(
                          //   () => RoundButton(
                          //     width: double.infinity,
                          //     height: 50,
                          //     title: 'Sign In',
                          //     loading: LoginVM.loading.value,
                          //     buttonColor: AppColor.primeColor,
                          //     onPress: () {
                          //       Get.toNamed(RoutesName.subscriptionScreen);
                          //       if (_formKey.currentState!.validate()) {
                          //         LoginVM.loginApi();
                          //       }
                          //     },
                          //   ),
                          // ),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an account? ',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Get.toNamed(RoutesName.registerScreen);
                                },
                                child: Text(
                                  'Log In',
                                  style: GoogleFonts.poppins(
                                    color: AppColor.primeColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Divider(
                                  color: Colors.grey,
                                  thickness: 1.5,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                                child: Text(
                                  "or",
                                  style: GoogleFonts.poppins(
                                    color: AppColor.textColor,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: Colors.grey,
                                  thickness: 1.5,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 40,
                            ),
                            decoration: BoxDecoration(
                              color: AppColor.grayColor,
                              border: Border.all(
                                color: Colors.white24,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                // Image.asset('assets/images/login-icon3.png'),
                                Padding(
                                  padding: const EdgeInsets.symmetric( vertical: 7.0),
                                  child: SvgPicture.asset(
                                    'assets/images/devicon_google.svg',width: 22,height: 22,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(width: 3),
                                Text(
                                  'Continue wit google',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColor.whiteColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 12),
                          Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 40,
                            ),
                            decoration: BoxDecoration(
                              color: AppColor.grayColor,
                              border: Border.all(
                                color: Colors.white24,
                                width: 1,
                              ),
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

                          SizedBox(height: 28),
                          Button(
                            color: AppColor.primeColor,
                            title: "Sign In",
                            textColor: AppColor.whiteColor,
                            onTap: () {
                              //Version 2.0.0
                              // Get.toNamed(RoutesName.subscriptionScreen);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ScreenHolderScreen(),
                                ),
                              );
                              if (_formKey.currentState!.validate()) {
                                LoginVM.loginApi();
                              }
                            }, 
                          ),
                          Row(children: []),
                          SizedBox(height: 30),

                          // InkWell(
                          //   onTap: () {
                          //     Get.toNamed(RoutesName.forgetPassword);
                          //   },
                          //   child: Text(
                          //     'Forget Password?',
                          //     style: TextStyle(
                          //       color: AppColor.primeColor,
                          //       fontFamily: AppFonts.appFont,
                          //       fontSize: 16,
                          //       fontWeight: FontWeight.w900,
                          //     ),
                          //   ),
                          // ),
                          // SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (Get.isSnackbarOpen) {
      Get.back();
    }
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
    super.dispose();
  }
}









// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:gig/res/components/button.dart';
// import 'package:gig/res/routes/routes_name.dart';
// import 'package:gig/view/screen_holder/screen_holder_screen.dart';
// import 'package:gig/view_models/controller/auth/register_view_model.dart';
// import '../../res/colors/app_color.dart';
// import '../../res/components/input.dart';
// import '../../res/fonts/app_fonts.dart';

// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({super.key});

//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   final registerVM = Get.put(RegisterVewModel());
//   final _formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColor.appBodyBG,
//       body: SafeArea(
//         child: Stack(
//           children: [
//             Positioned(
//               top: 10,
//               left: 20,
//               child: InkWell(
//                 onTap: () {
//                   // Get.toNamed(RoutesName.loginScreen);
//                   Navigator.pop(context);
//                 },
//                 child: Icon(Icons.arrow_back, color: AppColor.primeColor),
//               ),
//             ),
//             Container(
//               padding: EdgeInsets.only(top: 0, bottom: 0, left: 25, right: 25),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Join Task App Today',
//                     style: TextStyle(
//                       fontSize: 24,
//                       color: AppColor.secondColor,
//                       fontWeight: FontWeight.w600,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   Text(
//                     'Lorem Ipsum is simply dummy text',
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: AppColor.whiteColor,
//                       fontWeight: FontWeight.w400,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   Form(
//                     key: _formKey,
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         SizedBox(height: 30),
//                         CustomInputField(
//                           controller: registerVM.nameController.value,
//                           fieldType: 'text',
//                           hintText: "Name",
//                           requiredField: true,
//                           validator: (value) {
//                             if (value!.isEmpty) {
//                               return 'Name is required';
//                             }
//                             return 'Name is Required';
//                           },
//                         ),
//                         SizedBox(height: 15),
//                         CustomInputField(
//                           controller: registerVM.emailController.value,
//                           fieldType: 'email',
//                           hintText: "Email",
//                           requiredField: true,
//                           validator: (value) {
//                             if (value!.isEmpty) {
//                               return 'Email is required';
//                             }
//                             return 'Email is Required';
//                           },
//                         ),
//                         SizedBox(height: 15),
//                         CustomInputField(
//                           controller: registerVM.passwordController.value,
//                           fieldType: 'password',
//                           hintText: "Password",
//                           requiredField: true,
//                           validator: (value) {
//                             if (value!.isEmpty) {
//                               return 'Password is required';
//                             }
//                             return 'Password is Required';
//                           },
//                         ),
//                         SizedBox(height: 15),
//                         Button(color: AppColor.primeColor, title: "Sign Up", textColor: AppColor.whiteColor, onTap: (){
//                           Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>ScreenHolderScreen()));
//                         }),

//                         //OTP Screen

//                         // Obx(
//                         //   () => RoundButton(
//                         //     width: double.infinity,
//                         //     height: 50,
//                         //     title: 'Sign Up',
//                         //     loading: registerVM.loading.value,
//                         //     buttonColor: AppColor.primeColor,
//                         //     onPress: () {
//                         //       Get.toNamed(RoutesName.otpScreen);
//                         //       if (_formKey.currentState!.validate()) {
//                         //         registerVM.registerApi();
//                         //       }
//                         //     },
//                         //   ),
//                         // ),
//                         SizedBox(height: 30),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               'Already have an account? ',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontFamily: AppFonts.appFont,
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w400,
//                               ),
//                             ),
//                             InkWell(
//                               onTap: () {
//                                 Get.toNamed(RoutesName.loginScreen);
//                               },
//                               child: Text(
//                                 'Sign In',
//                                 style: TextStyle(
//                                   color: AppColor.primeColor,
//                                   fontFamily: AppFonts.appFont,
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w900,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     if (Get.isSnackbarOpen) {
//       Get.back();
//     }
//     if (Get.isDialogOpen ?? false) {
//       Get.back();
//     }
//     super.dispose();
//   }
// }
