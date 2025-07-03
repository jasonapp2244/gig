import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../res/colors/app_color.dart';
import '../../res/components/input.dart';
import '../../res/components/round_button.dart';
import '../../utils/utils.dart';
import '../../view_models/controller/password/reset_password_view_model.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final ResetPasswordVM = Get.put(ResetPasswordViewModel());
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
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back, color: AppColor.primeColor,)
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: 0, bottom: 0, left: 25, right: 25,),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Secure your account', style: TextStyle(fontSize: 24,color: AppColor.secondColor, fontWeight: FontWeight.w600), textAlign: TextAlign.center,),
                  Text('Lorem Ipsum is simply dummy text', style: TextStyle(fontSize: 12, color: AppColor.whiteColor, fontWeight: FontWeight.w400), textAlign: TextAlign.center,),
                  Form(
                    key: _formKey,
                    child: Column(
                      spacing: 15,
                      children: [
                        SizedBox(height: 15),
                        CustomInputField(
                          controller: ResetPasswordVM.passwordController.value,
                          fieldType: 'password',
                          hintText: "Older Password",
                          requiredField: true,
                          validator: (value) {
                            if(value!.isEmpty){
                              Utils.snakBar('Password', 'Enter password');
                            }
                            return 'Password is required';
                          },
                        ),
                        CustomInputField(
                            controller: ResetPasswordVM.oldPasswordController.value,
                            fieldType: 'password',
                            hintText: "New Password",
                            requiredField: true,
                            validator: (value) {
                              if(value!.isEmpty){
                                Utils.snakBar('Password', 'Enter password');

                              }
                              return 'Password is required';
                            },
                        ),
                        Obx(
                          () => RoundButton(
                            width: double.infinity,
                            title: 'Save New Password',
                            loading: ResetPasswordVM.loading.value,
                            onPress: () {
                              if(_formKey.currentState!.validate()){
                                ResetPasswordVM.resetPasswordApi();
                              }
                            },
                          ),
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
