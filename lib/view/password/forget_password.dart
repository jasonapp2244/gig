import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gig/view_models/controller/password/forget_password_view_model.dart';

import '../../res/colors/app_color.dart';
import '../../res/components/input.dart';
import '../../res/components/round_button.dart';

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
        child: Column(
          children: [
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
                    'Your Registered Email',
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
                              return 'Email is required';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 15),
                        Obx(
                          () => RoundButton(
                            width: double.infinity,
                            height: 50,
                            title: 'Forgot',
                            loading: forgetPasswordVM.loading.value,
                            buttonColor: AppColor.primeColor,
                            onPress: () {
                              if (_formKey.currentState!.validate()) {
                                forgetPasswordVM.forgetPasswordApi();
                              }
                            },
                          ),
                        ),
                        SizedBox(height: 30),
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
