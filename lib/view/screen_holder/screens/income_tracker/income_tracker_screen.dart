import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../res/colors/app_color.dart';

class IncomeTracker extends StatefulWidget {
  const IncomeTracker({super.key});

  @override
  State<IncomeTracker> createState() => _IncomeTrackerState();
}

class _IncomeTrackerState extends State<IncomeTracker> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  String selectedStatus = 'paid';

  List<Map<String, String>> paymentList = [];

  void addPayment() {
    if (nameController.text.isNotEmpty &&
        amountController.text.isNotEmpty &&
        dateController.text.isNotEmpty &&
        selectedStatus.isNotEmpty) {
      setState(() {
        paymentList.insert(0, {
          'name': nameController.text,
          'amount': amountController.text,
          'date': dateController.text,
          'status': selectedStatus,
        });

        nameController.clear();
        amountController.clear();
        dateController.clear();
        selectedStatus = 'paid';
      });
    }
  }

  void deletePayment(int index) {
    setState(() {
      paymentList.removeAt(index);
    });
  }

  Future<void> pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      setState(() {
        dateController.text = formattedDate;
      });
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
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Stack(
            //   children: [
            //     Padding(
            //       padding: const EdgeInsets.only(left: 20, bottom: 10, top: 10),
            //       child: Align(
            //         alignment: Alignment.centerLeft,
            //         child: InkWell(
            //           onTap: () => Navigator.pop(context),
            //           child: Icon(Icons.arrow_back, color: AppColor.primeColor),
            //         ),
            //       ),
            //     ),
            //     Positioned(
            //       top: 10,
            //       right: 35,
            //       left: 35,
            //       child: Text(
            //         'Income Tracker',
            //         style: TextStyle(
            //           fontSize: 18,
            //           color: AppColor.secondColor,
            //           fontWeight: FontWeight.bold,
            //         ),
            //         textAlign: TextAlign.center,
            //       ),
            //     ),
            //   ],
            // ),
            Column(
              children: [
                buildInputField("Name", nameController),
                buildInputField(
                  "Payment amount",
                  amountController,
                  isNumber: true,
                ),
                buildDatePickerField("Date", dateController),
                buildStatusDropdown(),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GestureDetector(
                    onTap: addPayment,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColor.primeColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "Add Payment",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: paymentList.length,
                      itemBuilder: (context, index) {
                        if (kDebugMode) {
                          print("");
                        }
                        print("");
                        final payment = paymentList[index];
                        return Card(
                          color: Colors.grey.shade900.withValues(alpha: 0.6),
                          margin: EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            title: Text(
                              payment['name'] ?? '',
                              style: TextStyle(color: Colors.white),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Amount: ${payment['amount']}",
                                  style: TextStyle(color: Colors.white70),
                                ),
                                Text(
                                  "Date: ${payment['date']}",
                                  style: TextStyle(color: Colors.white70),
                                ),
                                Text(
                                  "Status: ${payment['status']}",
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.redAccent),
                              onPressed: () => deletePayment(index),
                            ),
                          ),
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
        child: DropdownButton<String>(
          isExpanded: true, // 👈 full width dropdown
          value: selectedStatus,
          dropdownColor: Colors.grey.shade900,
          style: TextStyle(color: Colors.white),
          iconEnabledColor: Colors.white,
          items: ['paid', 'pending'].map((status) {
            return DropdownMenuItem(value: status, child: Text(status));
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedStatus = value!;
            });
          },
        ),
      ),
    );
  }
}
