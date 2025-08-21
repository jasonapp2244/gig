import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../repository/payment/payment_title_repository.dart';
import '../../../repository/payment/task_payment_repository.dart';
import '../../../utils/utils.dart';

class IncomeTrackerViewModel extends GetxController {
  final _api = PaymentTitleRepository();
  final _paymentApi = TaskPaymentRepository();

  RxBool loading = false.obs;
  RxBool buttonLoading = false.obs;
  RxList<String> paymentTitles = <String>[].obs;
  RxString selectedPaymentTitle = ''.obs;
  RxString error = ''.obs;
  RxInt selectedTaskId = 0.obs;

  // Store full task data for auto-filling
  RxList<Map<String, dynamic>> allTasks = <Map<String, dynamic>>[].obs;

  // Controllers for the form
  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  RxString selectedStatus = 'paid'.obs;

  // Payment list
  RxList<Map<String, String>> paymentList = <Map<String, String>>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Fetch payment titles when controller is initialized
    fetchPaymentTitles();
  }

  Future<void> fetchPaymentTitles() async {
    try {
      loading.value = true;
      error.value = '';

      print('🔄 Fetching payment titles...');

      dynamic response = await _api.getPaymentTitlesAPI();

      print('📋 Payment titles response: $response');

      if (response != null) {
        if (response['status'] == true) {
          List<dynamic> tasksList = response['tasks'] ?? [];

          // Store full task data for auto-filling
          allTasks.value = tasksList.map((task) {
            return Map<String, dynamic>.from(task);
          }).toList();

          // Extract job titles from tasks
          List<String> titles = tasksList
              .where(
                (task) =>
                    task['job_title'] != null &&
                    task['job_title'].toString().isNotEmpty,
              )
              .map((task) => task['job_title'].toString())
              .toSet() // Remove duplicates
              .toList();

          paymentTitles.value = titles;

          print(
            '✅ Payment titles loaded successfully: ${paymentTitles.length} titles',
          );
        } else {
          paymentTitles.value = [];
          error.value = response['message'] ?? 'Failed to load payment titles';
          print('❌ Failed to load payment titles: ${response['message']}');
        }
      } else {
        paymentTitles.value = [];
        error.value = 'No response from server';
        print('❌ No response from server');
      }
    } catch (e) {
      paymentTitles.value = [];
      error.value = 'Failed to load payment titles: $e';
      print('❌ Error fetching payment titles: $e');
      Utils.snakBar('Error', 'Failed to load payment titles: $e');
    } finally {
      loading.value = false;
    }
  }

  Future<void> addPayment() async {
    if (nameController.text.isNotEmpty &&
        amountController.text.isNotEmpty &&
        dateController.text.isNotEmpty &&
        selectedStatus.value.isNotEmpty &&
        selectedTaskId.value > 0) {
      try {
        buttonLoading.value = true;

        // Prepare data for API
        Map<String, dynamic> paymentData = {
          'task_id': selectedTaskId.value,
          'payment_title': nameController.text,
          'payment': amountController.text,
          'payment_status': selectedStatus.value,
        };

        print('📤 Sending payment data to API: $paymentData');

        // Send to API
        dynamic response = await _paymentApi.addTaskPaymentAPI(paymentData);

        print('📥 API Response: $response');

        if (response != null && response['status'] == true) {
          // Add to local list for display
          paymentList.insert(0, {
            'name': nameController.text,
            'amount': amountController.text,
            'date': dateController.text,
            'status': selectedStatus.value,
          });

          // Clear form
          clearForm();
          selectedTaskId.value = 0;

          Utils.snakBar(
            'Success',
            response['message'] ?? 'Payment added successfully!',
          );
        } else {
          String errorMessage = response?['message'] ?? 'Failed to add payment';
          Utils.snakBar('Error', errorMessage);
        }
      } catch (e) {
        print('❌ Error adding payment: $e');
        Utils.snakBar('Error', 'Failed to add payment: $e');
      } finally {
        buttonLoading.value = false;
      }
    } else {
      if (selectedTaskId.value == 0) {
        Utils.snakBar('Error', 'Please select a payment title first');
      } else {
        Utils.snakBar('Error', 'Please fill all fields');
      }
    }
  }

  void deletePayment(int index) {
    paymentList.removeAt(index);
    Utils.snakBar('Success', 'Payment deleted successfully!');
  }

  void setSelectedPaymentTitle(String title) {
    selectedPaymentTitle.value = title;
    nameController.text = title;

    // Find the corresponding task and auto-fill amount and date
    final selectedTask = allTasks.firstWhere(
      (task) => task['job_title'] == title,
      orElse: () => <String, dynamic>{},
    );

    if (selectedTask.isNotEmpty) {
      // Store the task_id for API call
      if (selectedTask['id'] != null) {
        selectedTaskId.value = int.tryParse(selectedTask['id'].toString()) ?? 0;
        print('📋 Selected task ID: ${selectedTaskId.value}');
      }

      // Auto-fill payment amount (wages)
      if (selectedTask['pay'] != null &&
          selectedTask['pay'].toString().isNotEmpty) {
        amountController.text = selectedTask['pay'].toString();
      }

      // Auto-fill date (task_date_time)
      if (selectedTask['task_date_time'] != null &&
          selectedTask['task_date_time'].toString().isNotEmpty) {
        String taskDateTime = selectedTask['task_date_time'].toString();

        // Parse the date and format it for display
        try {
          // Handle different date formats
          DateTime? parsedDate;

          if (taskDateTime.contains('T')) {
            // ISO format: 2025-01-21T09:00:00
            parsedDate = DateTime.tryParse(taskDateTime);
          } else if (taskDateTime.contains('-')) {
            // Date only format: 2025-01-21
            parsedDate = DateTime.tryParse(taskDateTime);
          }

          if (parsedDate != null) {
            // Format as yyyy-MM-dd for the date picker
            String formattedDate =
                "${parsedDate.year.toString().padLeft(4, '0')}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}";
            dateController.text = formattedDate;
          }
        } catch (e) {
          print('❌ Error parsing date: $e');
        }
      }

      print('✅ Auto-filled data for task: $title');
      print('💰 Amount: ${amountController.text}');
      print('📅 Date: ${dateController.text}');

      // Show success message for auto-fill
      Utils.snakBar('Auto-fill', 'Payment details auto-filled from task data!');
    }
  }

  void refreshPaymentTitles() async {
    await fetchPaymentTitles();
    Utils.snakBar('Success', 'Payment titles refreshed successfully!');
  }

  void clearForm() {
    nameController.clear();
    amountController.clear();
    dateController.clear();
    selectedStatus.value = 'paid';
    selectedPaymentTitle.value = '';
    selectedTaskId.value = 0;
  }
}
