// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:gig/view_models/controller/password/forget_password_view_model.dart';

// import '../../res/colors/app_color.dart';
// import '../../res/components/input.dart';
// import '../../res/components/round_button.dart';

// class ForgetPassword extends StatefulWidget {
//   const ForgetPassword({super.key});

//   @override
//   State<ForgetPassword> createState() => _RegisterState();
// }

// class _RegisterState extends State<ForgetPassword> {
//   final forgetPasswordVM = Get.put(ForgetPasswordVewModel());
//   final _formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColor.appBodyBG,
//       body: SafeArea(
//         child: Column(
//           children: [
//             Container(
//               padding: EdgeInsets.only(top: 0, bottom: 0, left: 25, right: 25),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Forgot your password?',
//                     style: TextStyle(
//                       fontSize: 24,
//                       color: AppColor.secondColor,
//                       fontWeight: FontWeight.w600,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   Text(
//                     'Your Registered Email',
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: AppColor.whiteColor,
//                       fontWeight: FontWeight.w400,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   Form(
//                     key: _formKey,
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         SizedBox(height: 30),
//                         CustomInputField(
//                           controller: forgetPasswordVM.emailController.value,
//                           fieldType: 'email',
//                           hintText: "Email",
//                           requiredField: true,
//                           validator: (value) {
//                             if (value!.isEmpty) {
//                               return 'Email is required';
//                             }
//                             return null;
//                           },
//                         ),
//                         SizedBox(height: 15),
//                         Obx(
//                           () => RoundButton(
//                             width: double.infinity,
//                             height: 50,
//                             title: 'Forgot',
//                             loading: forgetPasswordVM.loading.value,
//                             buttonColor: AppColor.primeColor,
//                             onPress: () {
//                               if (_formKey.currentState!.validate()) {
//                                 forgetPasswordVM.forgetPasswordApi();
//                               }
//                             },
//                           ),
//                         ),
//                         SizedBox(height: 30),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }












import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gig/res/colors/app_color.dart';
import 'package:gig/res/components/input.dart';
import 'package:gig/res/components/round_button.dart';
import 'package:gig/res/fonts/app_fonts.dart';
import 'package:gig/utils/responsive.dart';
import 'package:gig/view_models/controller/support/support_view_model.dart';
import 'package:gig/view_models/controller/support_controller.dart';

class SupportView extends StatelessWidget {
  SupportView({super.key});
  final controller = Get.put(SupportController());
  final supportVM = Get.put(SupportViewModel());
  final _formKey = GlobalKey<FormState>();
  final FocusNode subjectFoucs = FocusNode();
  final FocusNode messageFoucs = FocusNode();
  final FocusNode buttonFoucs = FocusNode();
  @override
  Widget build(BuildContext context) {
    (context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
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
      backgroundColor: AppColor.appBodyBG,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 10,
              children: [
                Row(
                  children: [
                    // GestureDetector(
                    //   onTap: () => Navigator.pop(context),
                    //   child: SvgPicture.asset(
                    //     "assets/icons/arrow-left-01.svg",
                    //     color: AppColor.redColor,
                    //   ),
                    // ),
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
                  controller: supportVM.subjectController.value,
                  fieldType: 'text',
                  hintText: "Subject",
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
                   controller: supportVM.messageController.value,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    iconColor: AppColor.textColor,
                    hintText: "Message",
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
             Obx(
                          () => RoundButton(
                            width: double.infinity,
                            height: 50,
                            title: 'Create New Ticket',
                            loading: supportVM.loading.value,
                            buttonColor: AppColor.primeColor,
                            onPress: () {
                              if (_formKey.currentState!.validate()) {
                                supportVM.SupportApi();
                              }
                            },
                          ),
                        ),
                // Button(
                //   color: AppColor.primeColor,
                //   textColor: AppColor.whiteColor,
                //   title: "Create New Ticket",
                //   onTap: () {},
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
