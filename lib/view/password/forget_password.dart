import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gig/view_models/controller/password/forget_password_view_model.dart';

import '../../res/colors/app_color.dart';
import '../../res/components/input.dart';
import '../../res/components/round_button.dart';
import '../../res/fonts/app_fonts.dart';
import '../../res/routes/routes_name.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _RegisterState();
}

class _RegisterState extends State<ForgetPassword> {
  final forgetPasswordVM = Get.put(ForgetPasswordVewModel());
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
                    'Forgot your password?',
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
                          controller: forgetPasswordVM.emailController.value,
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
                        Obx(
                          () => RoundButton(
                            width: double.infinity,
                            height: 50,
                            title: 'Continue',
                            loading: forgetPasswordVM.loading.value,
                            buttonColor: AppColor.primeColor,
                            onPress: () {
                              Get.toNamed(RoutesName.resetPassword);
                              if (_formKey.currentState!.validate()) {
                                forgetPasswordVM.forgetPasswordApi();
                              }
                            },
                          ),
                        ),
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Back to ',
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
                                'Login',
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
}
