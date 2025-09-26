import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart' show SvgPicture;
import 'package:get/get.dart';
import 'package:gig/res/colors/app_color.dart';
import 'package:gig/res/components/button.dart';
import 'package:gig/res/components/input.dart';
import 'package:gig/res/fonts/app_fonts.dart';
import 'package:gig/utils/responsive.dart';
import 'package:gig/view_models/controller/support_controller.dart';

class SupportView extends StatelessWidget {
  SupportView({super.key});
  final controller = Get.put(SupportController());

  final FocusNode subjectFoucs = FocusNode();
  final FocusNode messageFoucs = FocusNode();
  final FocusNode buttonFoucs = FocusNode();
  @override
  Widget build(BuildContext context) {
    (context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        backgroundColor: AppColor.appBodyBG,
        elevation: 0,

        centerTitle: true,
        title: Text(
          'Support',
          style: TextStyle(
            color: AppColor.whiteColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: AppColor.blackColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            spacing: 10,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: SvgPicture.asset(
                      "assets/icons/arrow-left-01.svg",
                      color: AppColor.redColor,
                    ),
                  ),
                  Text(
                    "Support Ticket",
                    style: TextStyle(
                      fontSize: Responsive.fontSize(24, context),
                      color: AppColor.whiteColor,
                      fontFamily: AppFonts.appFont,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              CustomInputField(
                controller: controller.subjectController,
                fieldType: 'text',
                hintText: "",
                requiredField: true,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Subject is required';
                  return null;
                },
              ),
              TextField(
                minLines: 4, // Minimum 4 lines
                maxLines: 5,
                controller: controller.messageController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  iconColor: AppColor.textColor,

                  hintStyle: const TextStyle(
                    color: Colors.white60,
                    fontFamily: AppFonts.appFont,
                  ),
                  filled: true,
                  fillColor: AppColor.grayColor,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 17,
                  ),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white24, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white24, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ), // Maximum 5 lines
                ),
              ),

              Button(
                color: AppColor.primeColor,
                textColor: AppColor.whiteColor,
                title: "Create New Ticket",
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
