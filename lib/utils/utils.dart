import 'package:flutter/material.dart';
import 'package:get/get.dart';
class Utils {

  static void fieldFocusChange(BuildContext context , FocusNode current , FocusNode nextFocus) {
    current.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  static void toastMessage(String message) {
    // Fluttertoast.showToast(
    //   msg: message,
    //   backgroundColor: AppColor.blackColor,
    // );
  }

  static void snakBar(String title, String message) {
  Get.snackbar(
    title,
    message,
    backgroundColor: Colors.white, // 👈 Background color white
    colorText: Colors.black,        // 👈 Text ka color black takay visible ho
    snackPosition: SnackPosition.TOP, // (optional) kahaan show karna hai
    margin: const EdgeInsets.all(10), // (optional) thoda margin dena
    borderRadius: 10,                // (optional) halki rounding
  );
}


}