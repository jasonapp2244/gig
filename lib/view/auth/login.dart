import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gig/res/routes/routes_name.dart';

import '../../res/colors/app_color.dart';
import '../../res/components/input.dart';
import '../../res/components/round_button.dart';
import '../../res/fonts/app_fonts.dart';
import '../../view_models/controller/auth/login_view_model.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final LoginVM = Get.put(LoginVewModel());
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
                  Get.toNamed(RoutesName.getStartedScreen);
                },
                child: Icon(Icons.arrow_back, color: AppColor.primeColor),
              ),
            ),
            Container(
              alignment: Alignment.center,
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
                        CustomInputField(
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
                        Obx(
                          () => RoundButton(
                            width: double.infinity,
                            height: 50,
                            title: 'Sign In',
                            loading: LoginVM.loading.value,
                            buttonColor: AppColor.primeColor,
                            onPress: () {
                              Get.toNamed(RoutesName.subscriptionScreen);
                              if (_formKey.currentState!.validate()) {
                                LoginVM.loginApi();
                              }
                            },
                          ),
                        ),
                        SizedBox(height: 30),
                        InkWell(
                          onTap: () {
                            Get.toNamed(RoutesName.forgetPassword);
                          },
                          child: Text(
                            'Forget Password?',
                            style: TextStyle(
                              color: AppColor.primeColor,
                              fontFamily: AppFonts.appFont,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
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
                                Get.toNamed(RoutesName.registerScreen);
                              },
                              child: Text(
                                'Sign Up',
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
