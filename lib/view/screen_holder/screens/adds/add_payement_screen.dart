import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gig/res/routes/routes_name.dart';

import '../../../../res/colors/app_color.dart';
import '../../../../res/components/input.dart';
import '../../../../res/components/round_button.dart';
import '../../../../res/fonts/app_fonts.dart';
import '../../../../view_models/controller/payment/card_payment_view_model.dart';

class AddPaymentScreen extends StatefulWidget {
  const AddPaymentScreen({super.key});
  @override
  State<AddPaymentScreen> createState() => AddPaymentScreenState();
}

class AddPaymentScreenState extends State<AddPaymentScreen>
    with SingleTickerProviderStateMixin {
  final cardPaymentVM = Get.put(CardPaymentViewModel());
  final _formKey = GlobalKey<FormState>();

  int _selectedIndex = 0;

  final List<Map<String, dynamic>> paymentMethods = [
    {'icon': Icons.paypal, 'label': 'Paypal'},
    {'icon': Icons.credit_card, 'label': 'Card'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBodyBG,
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, bottom: 10, top: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () {
                        print('ASDFGTUYTRE');
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back, color: AppColor.primeColor),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 35,
                  left: 35,
                  child: Text(
                    'Add Payment Methods',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColor.secondColor,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 50),
                    Center(
                      child: Text(
                        'Enter your payment details \nBy continuing you agree to our Terms',
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColor.whiteColor,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      height: 80,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: paymentMethods.length,
                        separatorBuilder: (_, __) => SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          bool isSelected = _selectedIndex == index;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedIndex = index),
                            child: Container(
                              width: 80,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 2,
                                  color: isSelected
                                      ? AppColor.primeColor
                                      : Colors.grey.shade400,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    paymentMethods[index]['icon'],
                                    color: isSelected
                                        ? AppColor.primeColor
                                        : AppColor.whiteColor,
                                    size: 30,
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    paymentMethods[index]['label'],
                                    style: TextStyle(
                                      fontFamily: AppFonts.appFont,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: AppColor.whiteColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: _getSelectedContent(),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getSelectedContent() {
    switch (_selectedIndex) {
      case 0:
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              CustomInputField(
                controller: cardPaymentVM.cardHolderNameController.value,
                fieldType: 'text',
                hintText: "Cardholder name",
                requiredField: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Name is required';
                  }
                  return 'Name is required';
                },
              ),
              SizedBox(height: 15),
              CustomInputField(
                controller: cardPaymentVM.cardNumberController.value,
                fieldType: 'number',
                hintText: "Card Number",
                requiredField: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Card number is required';
                  }
                  return 'Name is required';
                },
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: CustomInputField(
                      controller: cardPaymentVM.expMonthController.value,
                      fieldType: 'number',
                      hintText: "Exp Month",
                      requiredField: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Month required';
                        }
                        return 'Name is required';
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: CustomInputField(
                      controller: cardPaymentVM.expYearController.value,
                      fieldType: 'number',
                      hintText: "Exp Year",
                      requiredField: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Year required';
                        }
                        return 'Name is required';
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              CustomInputField(
                controller: cardPaymentVM.cvcController.value,
                fieldType: 'number',
                hintText: "CVC",
                requiredField: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'CVC required';
                  }
                  return 'Name is required';
                },
              ),
              SizedBox(height: 30),
              Obx(
                () => RoundButton(
                  width: double.infinity,
                  height: 50,
                  title: 'Pay Now',
                  loading: cardPaymentVM.loading.value,
                  buttonColor: AppColor.primeColor,
                  onPress: () {
                    Get.toNamed(RoutesName.createAAddsScreen);
                    if (_formKey.currentState!.validate()) {
                      cardPaymentVM.cardPaymentApi();
                    }
                  },
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        );
      case 1:
        return SizedBox(
          key: ValueKey(1),
          height: 300,
          child: Center(
            child: Text(
              'Card payment method selected.',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      default:
        return SizedBox.shrink();
    }
  }
}
