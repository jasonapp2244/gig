import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gig/res/components/button.dart';
import 'package:gig/res/routes/routes_name.dart';
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
            SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      _buildHeader(),
                      _buildFormFields(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ----------------- HEADER -----------------
  Widget _buildHeader() {
    return Column(
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
      ],
    );
  }

  /// ----------------- FORM -----------------
  Widget _buildFormFields() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 30),
        _buildNameField(),
        const SizedBox(height: 15),
        _buildEmailField(),
        const SizedBox(height: 15),
        _buildPasswordField(),
        const SizedBox(height: 15),
        _buildPhoneField(),
        const SizedBox(height: 15),
        _buildSignUpButton(),
        const SizedBox(height: 30),
        _buildSignInRow(),
      ],
    );
  }

  /// ----------------- NAME FIELD -----------------
  Widget _buildNameField() {
    return CustomInputField(
      controller: registerVM.nameController.value,
      fieldType: 'text',
      hintText: "Name",
      requiredField: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Name is required';
        }
        return null;
      },
    );
  }

  /// ----------------- EMAIL FIELD -----------------
  Widget _buildEmailField() {
    return CustomInputField(
      controller: registerVM.emailController.value,
      fieldType: 'email',
      hintText: "Email",
      requiredField: true,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Email is required';
        if (!GetUtils.isEmail(value)) return 'Please enter a valid email';
        return null;
      },
    );
  }

  /// ----------------- PASSWORD FIELD -----------------
  Widget _buildPasswordField() {
    return CustomInputField(
      controller: registerVM.passwordController.value,
      fieldType: 'password',
      hintText: "Password",
      requiredField: true,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Password is required';
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }

  /// ----------------- PHONE FIELD -----------------
  Widget _buildPhoneField() {
    return CustomInputField(
      controller: registerVM.phoneNumberController.value,
      fieldType: 'Phone Number',
      hintText: "Phone number",
      requiredField: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Phone number is required';
        }
        return null;
      },
    );
  }

  /// ----------------- SIGN UP BUTTON -----------------
  Widget _buildSignUpButton() {
    return Button(
      color: AppColor.primeColor,
      title: "Sign Up",
      textColor: AppColor.whiteColor,
      onTap: () {
        if (_formKey.currentState?.validate() ?? false) {
          registerVM.registerApi();
        }
      },
    );
  }

  /// ----------------- SIGN IN ROW -----------------
  Widget _buildSignInRow() {
    return Row(
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
          onTap: () => Get.toNamed(RoutesName.loginScreen),
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
    );
  }

  @override
  void dispose() {
    if (Get.isSnackbarOpen) Get.back();
    if (Get.isDialogOpen ?? false) Get.back();
    super.dispose();
  }
}
