import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gig/res/components/button.dart';
import 'package:gig/res/routes/routes_name.dart';
import 'package:gig/view/screen_holder/screen_holder_screen.dart';
import 'package:gig/view_models/controller/auth/register_view_model.dart';
import '../../res/colors/app_color.dart';
import '../../res/components/input.dart';
import '../../res/fonts/app_fonts.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final registerVM = Get.put(RegisterVewModel());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBodyBG,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 10,
              left: 20,
              child: InkWell(
                onTap: () {
                  // Get.toNamed(RoutesName.loginScreen);
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back, color: AppColor.primeColor),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 0, bottom: 0, left: 25, right: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                      children: [
                        SizedBox(height: 30),
                        CustomInputField(
                          controller: registerVM.nameController.value,
                          fieldType: 'text',
                          hintText: "Name",
                          requiredField: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Name is required';
                            }
                            return 'Name is Required';
                          },
                        ),
                        SizedBox(height: 15),
                        CustomInputField(
                          controller: registerVM.emailController.value,
                          fieldType: 'email',
                          hintText: "Email",
                          requiredField: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Email is required';
                            }
                            return 'Email is Required';
                          },
                        ),
                        SizedBox(height: 15),
                        CustomInputField(
                          controller: registerVM.passwordController.value,
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
                        Button(color: AppColor.primeColor, title: "Sign Up", textColor: AppColor.whiteColor, onTap: (){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>ScreenHolderScreen()));
                        }),

                        //OTP Screen

                        // Obx(
                        //   () => RoundButton(
                        //     width: double.infinity,
                        //     height: 50,
                        //     title: 'Sign Up',
                        //     loading: registerVM.loading.value,
                        //     buttonColor: AppColor.primeColor,
                        //     onPress: () {
                        //       Get.toNamed(RoutesName.otpScreen);
                        //       if (_formKey.currentState!.validate()) {
                        //         registerVM.registerApi();
                        //       }
                        //     },
                        //   ),
                        // ),
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account? ',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: AppFonts.appFont,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Get.toNamed(RoutesName.loginScreen);
                              },
                              child: Text(
                                'Sign In',
                                style: TextStyle(
                                  color: AppColor.primeColor,
                                  fontFamily: AppFonts.appFont,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
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
