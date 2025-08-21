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
  RxBool isRetrying = false.obs;
  RxList<String> paymentTitles = <String>[].obs;
  RxString selectedPaymentTitle = ''.obs;
  RxString error = ''.obs;
  RxInt selectedTaskId = 0.obs;

  // Store full task data for auto-filling
  RxList<Map<String, dynamic>> allTasks = <Map<String, dynamic>>[].obs;

  // Cache for offline/fallback support
  List<Map<String, dynamic>> _cachedTasks = [];
  DateTime? _lastCacheTime;
  static const Duration _cacheValidDuration = Duration(minutes: 30);

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
          List<Map<String, dynamic>> tasks = tasksList.map((task) {
            return Map<String, dynamic>.from(task);
          }).toList();

          allTasks.value = tasks;

          // Update cache with fresh data
          _updateCache(tasks);

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
          // Try to use cached data if available
          if (_isCacheValid()) {
            _useCachedData();
          } else {
            paymentTitles.value = [];
            error.value =
                response['message'] ?? 'Failed to load payment titles';
            print('❌ Failed to load payment titles: ${response['message']}');
          }
        }
      } else {
        // Try to use cached data if available
        if (_isCacheValid()) {
          _useCachedData();
        } else {
          paymentTitles.value = [];
          error.value = 'No response from server';
          print('❌ No response from server');
        }
      }
    } catch (e) {
      print('❌ All retry attempts failed: $e');

      // Try to use cached data as last resort
      if (_isCacheValid()) {
        _useCachedData();
        error.value = ''; // Clear error since we have cached data
      } else {
        paymentTitles.value = [];

        // Provide more specific error messages
        String errorMessage;
        if (e.toString().contains('TimeoutException')) {
          errorMessage =
              'Request timed out after multiple attempts. Please check your internet connection and try again.';
        } else if (e.toString().contains('SocketException')) {
          errorMessage =
              'No internet connection. Please check your network settings.';
        } else if (e.toString().contains('401')) {
          errorMessage = 'Authentication failed. Please log in again.';
        } else {
          errorMessage =
              'Failed to load payment titles after multiple attempts: $e';
        }

        error.value = errorMessage;
        print('❌ Error fetching payment titles: $e');
        Utils.snakBar('Error', errorMessage);
      }
    } finally {
      loading.value = false;
      isRetrying.value = false; // Ensure retry state is reset
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
    try {
      // Clear any previous errors
      error.value = '';

      await fetchPaymentTitles();
      if (paymentTitles.isNotEmpty) {
        Utils.snakBar('Success', 'Payment titles refreshed successfully!');
      }
    } catch (e) {
      print('❌ Error refreshing payment titles: $e');
      // Error handling is already done in fetchPaymentTitles
    }
  }

  // Force refresh without cache
  void forceRefreshPaymentTitles() async {
    try {
      // Clear cache to force fresh data
      _cachedTasks.clear();
      _lastCacheTime = null;

      error.value = '';
      await fetchPaymentTitles();

      if (paymentTitles.isNotEmpty) {
        Utils.snakBar(
          'Success',
          'Payment titles force refreshed successfully!',
        );
      }
    } catch (e) {
      print('❌ Error force refreshing payment titles: $e');
    }
  }

  void clearForm() {
    nameController.clear();
    amountController.clear();
    dateController.clear();
    selectedStatus.value = 'paid';
    selectedPaymentTitle.value = '';
    selectedTaskId.value = 0;
  }

  // Check if cached data is available and valid
  bool _isCacheValid() {
    if (_lastCacheTime == null || _cachedTasks.isEmpty) {
      return false;
    }
    return DateTime.now().difference(_lastCacheTime!) < _cacheValidDuration;
  }

  // Use cached data as fallback
  void _useCachedData() {
    if (_cachedTasks.isNotEmpty) {
      allTasks.value = _cachedTasks;

      // Extract job titles from cached tasks
      List<String> titles = _cachedTasks
          .where(
            (task) =>
                task['job_title'] != null &&
                task['job_title'].toString().isNotEmpty,
          )
          .map((task) => task['job_title'].toString())
          .toSet() // Remove duplicates
          .toList();

      paymentTitles.value = titles;

      print('📦 Using cached data: ${paymentTitles.length} titles');
      Utils.snakBar('Info', 'Using cached data due to connection issues');
    }
  }

  // Update cache with fresh data
  void _updateCache(List<Map<String, dynamic>> tasks) {
    _cachedTasks = tasks;
    _lastCacheTime = DateTime.now();
    print('💾 Cache updated with ${tasks.length} tasks');
  }
}
