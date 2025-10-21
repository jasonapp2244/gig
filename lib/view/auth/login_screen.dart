import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gig/res/components/button.dart';
import 'package:gig/res/fonts/app_fonts.dart';
import 'package:gig/res/routes/routes_name.dart';
import 'package:gig/utils/responsive.dart';
import 'package:gig/utils/utils.dart';
import 'package:gig/view/auth/auth_servies.dart';
import 'package:gig/view_models/controller/auth/logout_view_model.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../res/colors/app_color.dart';
import '../../res/components/input.dart';
import '../../view_models/controller/auth/login_view_model.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final LoginVM = Get.put(LoginVewModel());
  final _formKey = GlobalKey<FormState>();
  final LogoutnVM = Get.put(LogoutViewModel());

  /// Handle Google Sign-In
  Future<void> _handleGoogleSignIn() async {
    try {
      LoginVM.googleLoading.value = true;

      final result = await GoogleAuthRepository.signInWithGoogle();

      if (result.success && result.user != null) {
        // Google sign-in successful
        Utils.snakBar('Success', 'Google Sign-in successful!');
        Utils.writeSecureStorage('provider_name', 'google');
        String email = await Utils.readSecureData('email') ?? '';
        final user = result.user!;
        LoginVM.loginApiWithGoogle(
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
      LoginVM.googleLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBodyBG,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      _buildHeader(),
                      _buildFormFields(),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
          'Welcome back!',
          style: TextStyle(
            fontSize: 24,
            color: AppColor.secondColor,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          'Your tasks, your productivity.',
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        _buildEmailField(),
        const SizedBox(height: 15),
        _buildPasswordField(),
        const SizedBox(height: 15),
        _buildForgotPassword(),
        const SizedBox(height: 15),
        _buildSignUpRow(),
        const SizedBox(height: 15),
        _buildDivider(),
        const SizedBox(height: 12),
        _buildGoogleButton(),
        // const SizedBox(height: 12),
        //  _buildFacebookButton(),
        const SizedBox(height: 28),
        _buildSignInButton(),
      ],
    );
  }

  /// ----------------- EMAIL -----------------
  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Email",
          style: GoogleFonts.poppins(color: AppColor.textColor, fontSize: 16),
        ),
        CustomInputField(
          prefixIcon: Icon(Icons.email_outlined, color: AppColor.textColor),
          controller: LoginVM.emailController.value,
          fieldType: 'email',
          hintText: "Email",
          requiredField: true,
          validator: (value) {
            if (value == null || value.isEmpty) return 'Email is required';
            if (!GetUtils.isEmail(value)) return 'Please enter a valid email';
            return null;
          },
        ),
      ],
    );
  }

  /// ----------------- PASSWORD -----------------
  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Password",
          style: GoogleFonts.poppins(color: AppColor.textColor, fontSize: 16),
        ),
        CustomInputField(
          prefixIcon: Icon(Icons.password, color: AppColor.textColor),
          controller: LoginVM.passwordController.value,
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
        ),
      ],
    );
  }

  /// ----------------- FORGOT PASSWORD -----------------
  Widget _buildForgotPassword() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          onTap: () => Get.toNamed(RoutesName.forgetPassword),
          child: Text(
            'Forgot Password',
            style: GoogleFonts.poppins(
              color: AppColor.primeColor,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  /// ----------------- SIGN UP ROW -----------------
  Widget _buildSignUpRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Don\'t have an account? ',
          style: TextStyle(
            color: Colors.white,
            fontFamily: AppFonts.appFont,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        InkWell(
          onTap: () => Get.toNamed(RoutesName.registerScreen),
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
    );
  }

  /// ----------------- DIVIDER -----------------
  Widget _buildDivider() {
    return Row(
      children: <Widget>[
        const Expanded(child: Divider(color: Colors.grey, thickness: 1.5)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            "or",
            style: GoogleFonts.poppins(color: AppColor.textColor),
          ),
        ),
        const Expanded(child: Divider(color: Colors.grey, thickness: 1.5)),
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
      onTap: LoginVM.googleLoading.value ? null : _handleGoogleSignIn,
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

  /// ----------------- SIGN IN BUTTON -----------------
  Widget _buildSignInButton() {
    return Obx(
      () => Button(
        color: LoginVM.loading.value ? Colors.grey : AppColor.primeColor,
        title: "Sign In",
        textColor: AppColor.whiteColor,
        isLoading: LoginVM.loading.value,
        onTap: () {
          if (_formKey.currentState?.validate() ?? false) {
            LoginVM.loginApi();
          }
        },
      ),
    );
  }
  Widget _buildDrawerHeader(BuildContext context, bool isTablet) {
    return DrawerHeader(
      decoration: BoxDecoration(color: AppColor.primeColor),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage('assets/images/user.png'),
            radius: isTablet
                ? Responsive.width(5, context)
                : Responsive.width(6, context),
          ),
          SizedBox(height: Responsive.height(1, context)),
          Text(
            "John Doe",
            style: TextStyle(
              color: Colors.white,
              fontSize: Responsive.fontSize(18, context),
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "johndoe@gmail.com",
            style: TextStyle(
              color: Colors.white,
              fontSize: Responsive.fontSize(14, context),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildDrawerItem(
  //   BuildContext context, {
  //   required IconData icon,
  //   required String text,
  //   required String route,
  //   void Function()? onTap,
  // }) {
  //   return ListTile(
  //     leading: Icon(icon, size: Responsive.fontSize(20, context)),
  //     title: Text(
  //       text,
  //       style: TextStyle(fontSize: Responsive.fontSize(16, context)),
  //     ),
  //     onTap:
  //         onTap ??
  //         () {
  //           Navigator.pop(context);
  //           Get.toNamed(route);
  //         },
  //   );
  // }

  @override
  void dispose() {
    if (Get.isSnackbarOpen) Get.back();
    if (Get.isDialogOpen ?? false) Get.back();
    super.dispose();
  }
}
