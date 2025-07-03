import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../colors/app_color.dart';
import '../fonts/app_fonts.dart';


class InternetExceptionsWidget extends StatefulWidget {
  final VoidCallback onPress;
  const InternetExceptionsWidget({super.key, required this.onPress});

  @override
  State<InternetExceptionsWidget> createState() => _InternetExceptionsWidgetState();
}

class _InternetExceptionsWidgetState extends State<InternetExceptionsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_off, size: 50, color: AppColor.redColor,),
            SizedBox(height: 10,),
            Text('internet_exception'.tr, textAlign: TextAlign.center,),
            SizedBox(height: 20,),
            InkWell(
              onTap: widget.onPress,
              child: Container(
                width: 160,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  color: AppColor.redColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('retry_txt'.tr, style: TextStyle(color: AppColor.whiteColor, fontSize: 16, fontFamily: AppFonts.appFont),textAlign: TextAlign.center,),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
