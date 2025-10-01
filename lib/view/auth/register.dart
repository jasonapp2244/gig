import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gig/res/components/button.dart';
import 'package:gig/res/routes/routes_name.dart';
import 'package:gig/utils/utils.dart';
import 'package:gig/view/auth/auth_servies.dart';
import 'package:gig/view_models/controller/auth/register_view_model.dart';
import '../../res/colors/app_color.dart';
import '../../res/components/input.dart';
import '../../res/fonts/app_fonts.dart';
import 'package:gig/repository/auth_repository/social_login_repository.dart';
import 'package:gig/view/auth/auth_servies.dart';
import 'package:permission_handler/permission_handler.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final registerVM = Get.put(RegisterVewModel());
  final _formKey = GlobalKey<FormState>();

  /// Handle Google Sign-In
  Future<void> _handleGoogleSignIn() async {
    try {
      registerVM.googleLoading.value = true;

      final result = await GoogleAuthRepository.signInWithGoogle();

      if (result.success && result.user != null) {
        // Google sign-in successful
        Utils.snakBar('Success', 'Google Sign-in successful!');
        String providerId = await Utils.readSecureData('provider_token') ?? '';
        String email = await Utils.readSecureData('email') ?? '';
        final user = result.user!;
        registerVM.registerApiWithGoogle(
          providerId: user.uid,
          email: user.email,
          displayName: user.displayName,
          photoUrl: user.photoURL,
        );

        // You can navigate to the next screen or handle the user data here
        //s Get.toNamed(RoutesName.home);

        print('Google Sign-in successful: ${result.user!.email}');
      } else {
        // Handle sign-in failure
        Utils.snakBar('Sign-in Failed', result.message);
        print('Google Sign-in failed: ${result.message}');
      }
    } catch (error) {
      Utils.snakBar('Error', 'An unexpected error occurred');
      print('Google Sign-in error: $error');
    } finally {
      registerVM.googleLoading.value = false;
    }
  }

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
        _buildGoogleButton(),

        const SizedBox(height: 28),
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

  /// ----------------- GOOGLE BUTTON -----------------
  Widget _buildGoogleButton() {
    return _socialButton(
      icon: 'assets/images/devicon_google.svg',
      text: 'Continue with Google',
    );
  }

  /// ----------------- FACEBOOK BUTTON -----------------
  Widget _buildFacebookButton() {
    return _socialButton(
      icon: 'assets/images/facebook.svg',
      text: 'Continue with facebook',
    );
  }

  Widget _socialButton({required String icon, required String text}) {
    return GestureDetector(
      onTap: registerVM.googleLoading.value ? null : _handleGoogleSignIn,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
        decoration: BoxDecoration(
          color: AppColor.grayColor,
          border: Border.all(color: Colors.white24, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              child: SvgPicture.asset(icon, fit: BoxFit.cover),
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
      ),
    );
  }

  @override
  void dispose() {
    if (Get.isSnackbarOpen) Get.back();
    if (Get.isDialogOpen ?? false) Get.back();
    super.dispose();
  }
}
