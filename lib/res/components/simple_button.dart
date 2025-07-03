import 'package:flutter/material.dart';
import '../colors/app_color.dart';
import '../fonts/app_fonts.dart';

class SimpleButton extends StatelessWidget {
  const SimpleButton({
    super.key,

    this.buttonColor = AppColor.primeColor,
    this.textColor = AppColor.whiteColor,
    required this.title,
    required this.onPress,
    this.loading = false,

  });

  final bool loading;
  final String title;
  final VoidCallback onPress;
  final Color textColor , buttonColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        child: loading ?
          Center( child: CircularProgressIndicator(color: AppColor.secondColor,))
            :
          Center(child: Text(title, style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w700, fontFamily: AppFonts.appFont),textAlign: TextAlign.center,),),
      ),
    );
  }
}

