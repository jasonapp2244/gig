import 'package:flutter/material.dart';

import '../colors/app_color.dart';
import '../fonts/app_fonts.dart';

class RoundButton extends StatelessWidget {
  const RoundButton({
    super.key,

    this.buttonColor = AppColor.primeColor,
    this.textColor = AppColor.whiteColor,
    required this.title,
    required this.onPress,
    this.width = 60,
    this.height = 50,
    this.loading = false,

  });

  final bool loading;
  final String title;
  final double height , width;
  final VoidCallback onPress;
  final Color textColor , buttonColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: loading ? 
          Center( child: CircularProgressIndicator(color: AppColor.whiteColor,)) : Center(child: Text(title, style: TextStyle(color: AppColor.whiteColor, fontSize: 16, fontFamily: AppFonts.appFont, fontWeight: FontWeight.w600),textAlign: TextAlign.center,),),
      ),
    );
  }
}

