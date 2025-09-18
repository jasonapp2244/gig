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
  void initState() {
    // TODO: implement initState
    controller.fetchPaymentTitles();
    super.initState();
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

          return SingleChildScrollView(
            child: Column(
              children: [
                // Earnings Summary Section
                _buildEarningsSummary(),
                const SizedBox(height: 20),

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
              ],
            ),
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
            value: controller.selectedStatus.value ?? 'pending',
            dropdownColor: Colors.grey.shade900,
            style: TextStyle(color: Colors.white),
            iconEnabledColor: Colors.white,
            items: ['pending', 'paid'].map((status) {
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

  Widget _buildEarningsSummary() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Tab headers
          Row(
            children: [
              Expanded(child: _buildTabHeader('Total Earning', true)),
              Expanded(child: _buildTabHeader('Pending payments', false)),
              Expanded(child: _buildTabHeader('Net earnings', false)),
            ],
          ),

          // Content container
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: _buildEarningsItem(
                        'Balance available for use',
                        Color(0xffFFA500),
                      ),
                    ),
                    Expanded(
                      child: _buildEarningsItem(
                        'Payments being cleared',
                        Color(0xffFFA500),
                      ),
                    ),
                    Expanded(
                      child: _buildEarningsItem(
                        'Earnings this year',
                        Color(0xffFFA500),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Obx(() {
                  if (controller.earningsLoading.value) {
                    return Container(
                      height: 50,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColor.primeColor,
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  }

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _buildAmountDisplay(
                          controller.formatCurrency(
                            controller.balanceAvailable.value,
                          ),
                        ),
                      ),
                      Expanded(
                        child: _buildAmountDisplay(
                          controller.formatCurrency(
                            controller.paymentsBeingCleared.value,
                          ),
                        ),
                      ),
                      Expanded(
                        child: _buildAmountDisplay(
                          controller.formatCurrency(
                            controller.earningsThisYear.value,
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabHeader(String title, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),

      child: Text(
        title,
        style: TextStyle(
          color: Color(0xff848A94),
          fontSize: 14,
          fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildEarningsItem(String label, Color labelColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            color: labelColor,
            fontSize: 12,

            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildAmountDisplay(String amount) {
    return Text(
      amount,
      style: TextStyle(
        color: AppColor.secondColor,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }
}
