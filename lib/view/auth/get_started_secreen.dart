import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gig/res/colors/app_color.dart';
import 'package:gig/res/components/button.dart';
import 'package:gig/res/routes/routes_name.dart';
import 'package:gig/view/auth/auth_servies.dart';
import 'package:gig/view/privacy_policy.dart';

import 'package:gig/view_models/controller/auth/login_view_model.dart';
import 'package:gig/utils/utils.dart';

class GetStartedSecreen extends StatefulWidget {
  const GetStartedSecreen({super.key});

  @override
  State<GetStartedSecreen> createState() => _GetStartedSecreenState();
}

class _GetStartedSecreenState extends State<GetStartedSecreen> {
  final LoginVewModel loginVM = Get.put(LoginVewModel());

  /// Handle Google Sign-In
  Future<void> _handleGoogleSignIn() async {
    try {
      loginVM.googleLoading.value = true;

      final result = await GoogleAuthRepository.signInWithGoogle();

      if (result.success && result.user != null) {
        // Google sign-in successful
        Utils.snakBar('Success', 'Google Sign-in successful!');
        String providerId = await Utils.readSecureData('provider_token') ?? '';
        String email = await Utils.readSecureData('email') ?? '';
        final user = result.user!;
        loginVM.loginApiWithGoogle(
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
      loginVM.googleLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBodyBG,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildHeader(),
            const SizedBox(height: 40),
            _buildSocialButtons(),
            const SizedBox(height: 40),
            _buildActionButtons(),
            const SizedBox(height: 40),
            _buildPrivacyPolicy(context),
          ],
        ),
      ),
    );
  }

  /// ----------------- HEADER -----------------
  Widget _buildHeader() {
    return Column(
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
      ],
    );
  }

  /// ----------------- SOCIAL BUTTONS -----------------
  Widget _buildSocialButtons() {
    return Column(
      children: [
        _googleSignInButton(),
        const SizedBox(height: 10),
        _socialButton(
          icon: 'assets/images/apple.svg',
          text: 'Continue with apple',
          iconSize: 20,
        ),
        const SizedBox(height: 10),
        _socialButton(
          icon: 'assets/images/facebook.svg',
          text: 'Continue with facebook',
          iconSize: 20,
        ),
        const SizedBox(height: 10),
        _socialButton(
          icon: 'assets/images/twitter.svg',
          text: 'Continue with twitter',
        ),
      ],
    );
  }

  Widget _googleSignInButton() {
    return Obx(
      () => GestureDetector(
        onTap: loginVM.googleLoading.value ? null : _handleGoogleSignIn,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
          decoration: BoxDecoration(
            color: loginVM.googleLoading.value
                ? Colors.grey
                : AppColor.grayColor,
            border: Border.all(color: Colors.white24, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              if (loginVM.googleLoading.value)
                Container(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColor.whiteColor,
                  ),
                )
              else
                Container(
                  width: 22,
                  height: 22,
                  child: SvgPicture.asset(
                    'assets/images/devicon_google.svg',
                    fit: BoxFit.contain,
                  ),
                ),
              const SizedBox(width: 5),
              Text(
                loginVM.googleLoading.value
                    ? 'Signing in...'
                    : 'Continue with google',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColor.whiteColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _socialButton({
    required String icon,
    required String text,
    double iconSize = 22,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
      decoration: BoxDecoration(
        color: AppColor.grayColor,
        border: Border.all(color: Colors.white24, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: iconSize,
            height: iconSize,
            child: SvgPicture.asset(icon, fit: BoxFit.contain),
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
    );
  }

  /// ----------------- SIGNUP & LOGIN BUTTONS -----------------
  Widget _buildActionButtons() {
    return Column(
      children: [
        Button(
          color: AppColor.primeColor,
          title: "Sign Up",
          textColor: AppColor.whiteColor,
          onTap: () => Get.toNamed(RoutesName.registerScreen),
        ),
        const SizedBox(height: 10),
        Button(
          color: AppColor.whiteColor,
          title: "Log In",
          textColor: AppColor.blackColor,
          onTap: () => Get.toNamed(RoutesName.loginScreen),
        ),
      ],
    );
  }

  /// ----------------- PRIVACY POLICY -----------------
  Widget _buildPrivacyPolicy(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => PrivacyPolicy()),
      ),
      child: Text(
        'Privacy Policy',
        style: const TextStyle(
          fontSize: 16,
          color: Colors.grey,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
