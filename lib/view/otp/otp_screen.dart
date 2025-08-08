import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../res/colors/app_color.dart';
import '../../res/components/round_button.dart';
import '../../res/components/simple_button.dart';
import '../../view_models/controller/otp/otp_view_model.dart';
import '../../view_models/controller/otp/resend_otp_view_model.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  RxString userEmail = ''.obs;

  @override
  void initState() {
    super.initState();
    loadEmail();
  }

  void loadEmail() {
    // Get email from navigation arguments first
    final args = Get.arguments;
    if (args != null && args['email'] != null) {
      userEmail.value = args['email'];
    } else {
      // Fallback to SharedPreferences
      loadEmailFromPrefs();
    }
  }

  void loadEmailFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('otp_email') ?? '';
    userEmail.value = email;
  }

  final OtpVM = Get.put(OtpViewModel());
  final ResendOtpVM = Get.put(ResendOtpViewModel());
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
                    'Enter OTP Code',
                    style: TextStyle(
                      color: AppColor.redColor,
                      fontFamily: 'Poppins',
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Enter the One Time Password sent to  ',
                    style: TextStyle(
                      color: const Color(0xFF8d8d8d),
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Obx(
                    () => Text(
                      '$userEmail',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Form(
                    key: _formKey,
                    child: PinFieldAutoFill(
                      keyboardType: TextInputType.number,
                      controller: OtpVM.otpVerificationController.value,
                      codeLength: 6,
                      decoration: UnderlineDecoration(
                        colorBuilder: FixedColorBuilder(Colors.white),
                        textStyle: TextStyle(color: AppColor.whiteColor),
                      ),
                      cursor: Cursor(
                        width: 2,
                        height: 20,
                        color: Colors.white,
                        enabled: true,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don’t receive the OTP? ',
                        style: TextStyle(
                          color: const Color(0xFF8d8d8d),
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(width: 5),
                      Obx(
                        () => SimpleButton(
                          title: 'Resend OTP',
                          loading: ResendOtpVM.loading.value,
                          textColor: AppColor.secondColor,
                          onPress: () {
                            ResendOtpVM.resendOtpApi();
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Obx(
                    () => RoundButton(
                      width: double.infinity,
                      title: 'Verify',
                      loading: OtpVM.loading.value,
                      onPress: () {
                        if (_formKey.currentState!.validate()) {
                          OtpVM.otpApi(userEmail.value);
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
    );
  }
}
