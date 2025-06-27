import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gig/res/colors/app_color.dart';
import 'package:gig/res/routes/routes_name.dart';

class GetStartedSecreen extends StatefulWidget {
  const GetStartedSecreen({super.key});

  @override
  State<GetStartedSecreen> createState() => _GetStartedSecreenState();
}

class _GetStartedSecreenState extends State<GetStartedSecreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBodyBG,
      body: Container(
        padding: EdgeInsets.only(top: 0, bottom: 0, left: 25, right: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Let’s Get Started!',
              style: TextStyle(
                fontSize: 24,
                color: AppColor.secondColor,
                fontWeight: FontWeight.w400,
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
            SizedBox(height: 40),
            Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
              decoration: BoxDecoration(
                color: AppColor.grayColor,
                border: Border.all(color: Colors.white24, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Image.asset('assets/images/login-icon1.png'),
                  SizedBox(width: 5),
                  Text(
                    'Continue with google',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white24,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
              decoration: BoxDecoration(
                color: AppColor.grayColor,
                border: Border.all(color: Colors.white24, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Image.asset('assets/images/login-icon2.png'),
                  SizedBox(width: 5),
                  Text(
                    'Continue with apple',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white24,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
              decoration: BoxDecoration(
                color: AppColor.grayColor,
                border: Border.all(color: Colors.white24, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Image.asset('assets/images/login-icon3.png'),
                  SizedBox(width: 3),
                  Text(
                    'Continue with facebook',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white24,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
              decoration: BoxDecoration(
                color: AppColor.grayColor,
                border: Border.all(color: Colors.white24, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Image.asset('assets/images/login-icon4.png'),
                  SizedBox(width: 5),
                  Text(
                    'Continue with twitter',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white24,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            InkWell(
              onTap: () {
                Get.toNamed(RoutesName.registerScreen);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                decoration: BoxDecoration(
                  color: AppColor.primeColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            InkWell(
              onTap: () {
                Get.toNamed(RoutesName.loginScreen);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                decoration: BoxDecoration(
                  color: AppColor.whiteColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Log in',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
            Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
