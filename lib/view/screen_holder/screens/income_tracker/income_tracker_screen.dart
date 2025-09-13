import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../res/colors/app_color.dart';
import '../../../../view_models/controller/income/income_tracker_view_model.dart';

class IncomeTracker extends StatefulWidget {
  const IncomeTracker({super.key});

  @override
  State<IncomeTracker> createState() => _IncomeTrackerState();
}

class _IncomeTrackerState extends State<IncomeTracker> {
  final IncomeTrackerViewModel controller = Get.put(IncomeTrackerViewModel());

  Future<void> pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      controller.dateController.text = formattedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBodyBG,
      appBar: AppBar(
        backgroundColor: AppColor.appBodyBG,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Income Tracker',
          style: TextStyle(
            color: AppColor.secondColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.refresh, color: AppColor.secondColor),
        //     onPressed: controller.refreshPaymentTitles,
        //   ),
        // ],
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.loading.value) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColor.primeColor),
                  SizedBox(height: 16),
                  Obx(() {
                    if (controller.isRetrying.value) {
                      return Text(
                        'Retrying connection...',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      );
                    }
                    return Text(
                      'Loading payment titles...',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    );
                  }),
                ],
              ),
            );
          }

          if (controller.error.value.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 64),
                  SizedBox(height: 16),
                  Text(
                    'Error loading payment titles',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    controller.error.value,
                    style: TextStyle(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: controller.refreshPaymentTitles,
                        child: Text('Retry'),
                      ),
                      SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: controller.forceRefreshPaymentTitles,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                        ),
                        child: Text('Force Refresh'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Column(
                children: [
                  buildPaymentTitleDropdown(),
                  buildInputField(
                    "Payment amount",
                    controller.amountController,
                    isNumber: true,
                  ),
                  buildDatePickerField("Date", controller.dateController),
                  buildStatusDropdown(),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Obx(
                            () => GestureDetector(
                              onTap: controller.buttonLoading.value
                                  ? null
                                  : controller.addPayment,
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                  color: controller.buttonLoading.value
                                      ? Colors.grey.shade600
                                      : AppColor.primeColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                alignment: Alignment.center,
                                child: controller.buttonLoading.value
                                    ? SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      )
                                    : Text(
                                        "Add Payment",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        GestureDetector(
                          onTap: controller.clearForm,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 20,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade700,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "Clear",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
              // Expanded(
              //   child: SingleChildScrollView(
              //     padding: const EdgeInsets.only(bottom: 20),
              //     child: Column(
              //       children: [
              //         Obx(
              //           () => ListView.builder(
              //             shrinkWrap: true,
              //             physics: NeverScrollableScrollPhysics(),
              //             itemCount: controller.paymentList.length,
              //             itemBuilder: (context, index) {
              //               if (kDebugMode) {
              //                 print("");
              //               }
              //               print("");
              //               final payment = controller.paymentList[index];
              //               return Card(
              //                 color: Colors.grey.shade900.withValues(
              //                   alpha: 0.6,
              //                 ),
              //                 margin: EdgeInsets.symmetric(
              //                   vertical: 6,
              //                   horizontal: 16,
              //                 ),
              //                 shape: RoundedRectangleBorder(
              //                   borderRadius: BorderRadius.circular(12),
              //                 ),
              //                 child: ListTile(
              //                   title: Text(
              //                     payment['name'] ?? '',
              //                     style: TextStyle(color: Colors.white),
              //                   ),
              //                   subtitle: Column(
              //                     crossAxisAlignment: CrossAxisAlignment.start,
              //                     children: [
              //                       Text(
              //                         "Amount: ${payment['amount']}",
              //                         style: TextStyle(color: Colors.white70),
              //                       ),
              //                       Text(
              //                         "Date: ${payment['date']}",
              //                         style: TextStyle(color: Colors.white70),
              //                       ),
              //                       Text(
              //                         "Status: ${payment['status']}",
              //                         style: TextStyle(color: Colors.white70),
              //                       ),
              //                     ],
              //                   ),
              //                   trailing: IconButton(
              //                     icon: Icon(
              //                       Icons.delete,
              //                       color: Colors.redAccent,
              //                     ),
              //                     onPressed: () =>
              //                         controller.deletePayment(index),
              //                   ),
              //                 ),
              //               );
              //             },
              //           ),
              //         ),
              //    ],
              //   ),
              //  ),
              /////  ),
            ],
          );
        }),
      ),
    );
  }

  Widget buildPaymentTitleDropdown() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 17),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white.withOpacity(0.1),
        border: Border.all(color: Colors.grey.shade600),
      ),
      child: DropdownButtonHideUnderline(
        child: Obx(
          () => DropdownButton<String>(
            isExpanded: true,
            value: controller.selectedPaymentTitle.value.isEmpty
                ? null
                : controller.selectedPaymentTitle.value,
            hint: Text('Payment Title', style: TextStyle(color: Colors.grey)),
            dropdownColor: Colors.grey.shade900,
            style: TextStyle(color: Colors.white),
            iconEnabledColor: Colors.white,
            items: controller.paymentTitles.map((title) {
              return DropdownMenuItem(value: title, child: Text(title));
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                controller.setSelectedPaymentTitle(value);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget buildInputField(
    String hint,
    TextEditingController controller, {
    bool isNumber = false,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 17),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white.withOpacity(0.1),
        border: Border.all(color: Colors.grey.shade600),
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
        ),
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      ),
    );
  }

  Widget buildDatePickerField(String hint, TextEditingController controller) {
    return GestureDetector(
      onTap: pickDate,
      child: AbsorbPointer(child: buildInputField(hint, controller)),
    );
  }

  Widget buildStatusDropdown() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 17),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white.withOpacity(0.1),
        border: Border.all(color: Colors.grey.shade600),
      ),
      child: DropdownButtonHideUnderline(
        child: Obx(
          () => DropdownButton<String>(
            isExpanded: true,
            value: controller.selectedStatus.value,
            dropdownColor: Colors.grey.shade900,
            style: TextStyle(color: Colors.white),
            iconEnabledColor: Colors.white,
            items: ['paid', 'pending'].map((status) {
              return DropdownMenuItem(value: status, child: Text(status));
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                controller.selectedStatus.value = value;
              }
            },
          ),
        ),
      ),
    );
  }
}
