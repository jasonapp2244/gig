import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../colors/app_color.dart';

void customBottomSheet(
  BuildContext context, {
  required String title,
  required VoidCallback onFirstTap,
  required VoidCallback onSecondTap,
  required String btnText1,
  required String btnText2,
}) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
    ),
    backgroundColor: Colors.white,
    isScrollControlled: true,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 30, 20, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ✅ Top Logo
            // Image.asset('assets/images/logo.png', width: 120),
            Icon(
              LucideIcons.triangleAlert400,
              color: AppColor.redColor,
              size: 50,
            ),

            SizedBox(height: 20),

            // ✅ Instruction Text
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 30),

            // ✅ Buttons Row
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      onFirstTap();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColor.redColor,
                      ),
                      child: Text(
                        btnText1,
                        style: TextStyle(
                          color: AppColor.whiteColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      onSecondTap();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 1, color: Colors.black54),
                      ),
                      child: Text(
                        btnText2,
                        style: TextStyle(color: Colors.black54, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
