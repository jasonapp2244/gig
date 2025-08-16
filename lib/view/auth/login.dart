

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gig/res/components/button.dart';
import 'package:gig/res/fonts/app_fonts.dart';
import 'package:gig/res/routes/routes_name.dart';
import 'package:gig/utils/responsive.dart';
import 'package:gig/view_models/controller/auth/logout_view_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

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
                        'Welcome back!',
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

                      Column(
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
                              if (value == null || value.isEmpty) {
                                return 'Email is required';
                              }
                              if (!GetUtils.isEmail(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
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
                              if (value == null || value.isEmpty) {
                                return 'Password is required';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                            
                              InkWell(
                                onTap: () {
                                  Get.toNamed(RoutesName.forgetPassword);
                                },
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
                          ),
                          SizedBox(height: 15),

                         Row(
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
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 7.0,
                                  ),
                                  child: SvgPicture.asset(
                                    'assets/images/devicon_google.svg',
                                    width: 22,
                                    height: 22,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(width: 3),
                                Text(
                                  'Continue wit facebook',
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
                              if (_formKey.currentState?.validate() ?? false) {
                                LoginVM.loginApi();
                              }
                            },
                          ),
                          Row(children: []),
                          SizedBox(height: 30),
                        ],
                      ),
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

  Widget _buildDrawer(BuildContext context) {
    final bool isTablet = Responsive.isTablet(context);

    return Drawer(
      width: isTablet ? Responsive.width(40, context) : null,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
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
          ),
          _buildDrawerItem(
            context,
            icon: Icons.post_add,
            text: "Create Adds",
            route: RoutesName.createAddsScreen,
          ),
          _buildDrawerItem(
            context,
            icon: Icons.account_circle_outlined,
            text: "Profile",
            route: RoutesName.userProfileScreen,
          ),
          _buildDrawerItem(
            context,
            icon: LucideIcons.bellDot,
            text: "Notification",
            route: RoutesName.notificationScreen,
          ),
          _buildDrawerItem(
            context,
            icon: LucideIcons.building400,
            text: "Employer",
            route: RoutesName.employerScreen,
          ),
          _buildDrawerItem(
            context,
            icon: LucideIcons.building400,
            text: "logout",
            route: RoutesName.employerScreen,
            onTap: () {
              LogoutnVM.logoutApi();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String text,
    required String route,
    void Function()? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, size: Responsive.fontSize(20, context)),
      title: Text(
        text,
        style: TextStyle(fontSize: Responsive.fontSize(16, context)),
      ),
      onTap:
          onTap ??
          () {
            Navigator.pop(context); // Close the drawer
            Get.toNamed(route);
          },
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
