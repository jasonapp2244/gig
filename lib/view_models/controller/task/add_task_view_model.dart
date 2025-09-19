import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../repository/task/add_task_repository.dart';
import '../../../repository/employer/employer_repository.dart';
import '../../../res/routes/routes_name.dart';
import '../../../utils/utils.dart';
import '../user_preference/user_preference_view_model.dart';
import '../task/get_task_view_model.dart';
import '../home/home_view_model.dart';

class AddTaskViewModel extends GetxController {
  final _api = AddTaskRepository();
  final _employerRepository = EmployerRepository();
  UserPreference userPreference = UserPreference();
  final GetTaskViewModel taskViewModel = Get.find<GetTaskViewModel>();

  final employerController = TextEditingController().obs;
  final jobTypeController = TextEditingController().obs;
  final locationController = TextEditingController().obs;
  final supervisorController = TextEditingController().obs;
  // final workingHoursController = TextEditingController().obs;
  final wagesController = TextEditingController().obs;
  final straightTimeController = TextEditingController().obs;
  final notesController = TextEditingController().obs;
  DateTime? selectedDate;

  RxBool loading = false.obs;
  RxBool employerLoading = false.obs;
  RxList<Map<String, dynamic>> employers = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> filteredEmployers = <Map<String, dynamic>>[].obs;
  RxString searchQuery = ''.obs;

  Future<void> addTaskApi() async {
    loading.value = true;

    // Validate employer field
    final employerText = employerController.value.text.trim();
    if (employerText.isEmpty) {
      loading.value = false;
      Utils.snakBar('Error', 'Please select or enter an employer name');
      return;
    }

    // Handle null selectedDate by using current date as default
    print('🔍 AddTaskAPI - selectedDate before assignment: $selectedDate');
    print('🔍 AddTaskAPI - selectedDate is null: ${selectedDate == null}');
    DateTime taskDate = selectedDate ?? DateTime.now();
    print('🔍 AddTaskAPI - taskDate after assignment: $taskDate');

    // Create a DateTime with the selected date and current time
    DateTime now = DateTime.now();
    DateTime taskDateTime = DateTime(
      taskDate.year,
      taskDate.month,
      taskDate.day,
      now.hour, // Use current hour
      now.minute, // Use current minute
      now.second, // Use current second
    );

    print('🔍 Original selectedDate: $selectedDate');
    print('🔍 Original taskDate: $taskDate');
    print('🔍 New taskDateTime: $taskDateTime');

    // Format the date time properly - simple format without timezone
    String formattedDateTime =
        "${taskDateTime.year.toString().padLeft(4, '0')}-${taskDateTime.month.toString().padLeft(2, '0')}-${taskDateTime.day.toString().padLeft(2, '0')}T${taskDateTime.hour.toString().padLeft(2, '0')}:${taskDateTime.minute.toString().padLeft(2, '0')}:${taskDateTime.second.toString().padLeft(2, '0')}";

    print('🔍 Formatted string: $formattedDateTime');
    print('🔍 Expected format: 2025-08-21T09:00:00');

    Map data = {
      'employer': employerText,
      'job_title': jobTypeController.value.text,
      'location': locationController.value.text,
      'supervisorContactNumber': supervisorController.value.text,
      //  'workingHoursController': workingHoursController.value.text,
      'task_date_time': formattedDateTime,
      'pay': wagesController.value.text,
      'workingHours': straightTimeController.value.text,
      'notes': notesController.value.text,
    };

    print('📋 Task data being sent: $data');
    print('🕐 Task date time: ${data['task_date_time']}');
    print('📅 Selected date: $taskDate');
    print(
      '📅 Selected date hour: ${taskDate.hour}, minute: ${taskDate.minute}',
    );
    print('⏰ Created date time: $taskDateTime');
    print('🕐 Formatted date time: $formattedDateTime');
    print(
      '🔍 Hour: ${taskDateTime.hour}, Minute: ${taskDateTime.minute}, Second: ${taskDateTime.second}',
    );

    try {
      dynamic value = await _api.addTaskAPI(data);
      loading.value = false;

      if (value['status'] == true) {
        Utils.snakBar('Success', 'Task added successfully!');

        // Refresh both task list and home calendar data
        await taskViewModel.refreshData();

        // Also refresh home screen calendar data
        try {
          final HomeViewModel homeController = Get.find<HomeViewModel>();
          await homeController.silentRefreshTasksForCalendar();
          print('✅ Home calendar data refreshed after adding task');
        } catch (e) {
          print('⚠️ Could not refresh home calendar: $e');
        }

        // Navigate to Tasks tab in bottom navigation (this will clear the override screen)
        try {
          final HomeViewModel homeController = Get.find<HomeViewModel>();
          homeController.changeTab(
            1,
          ); // Switch to Tasks tab (index 1) - this also clears override screen
          print('✅ Navigated to Tasks tab');
        } catch (e) {
          print('⚠️ Could not navigate to Tasks tab: $e');
          // Fallback to regular navigation if HomeViewModel not found
          Get.toNamed(RoutesName.screenHolderScreen);
        }
      } else {
        print("Task Add failed: $value");
        print("Task Add failed: ${value['message']}");
        print("Task Add failed - Full response: $value");
        String errorMessage = value['message'] ?? 'Something went wrong';
        print("Task Add failed - Error message to display: $errorMessage");
        Utils.snakBar('Task Add', errorMessage);
        // Don't navigate away on error - let user see the error and try again
      }
    } catch (error) {
      loading.value = false;
      print('Task Add API error: ${error.toString()}');
      Utils.snakBar('Error', error.toString());
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchEmployers();

    // Add listener to employer controller to ensure proper synchronization
    employerController.value.addListener(() {
      print(
        '🔍 Employer controller changed: "${employerController.value.text}"',
      );
    });
  }

  Future<void> fetchEmployers() async {
    try {
      employerLoading.value = true;

      print(' Fetching employers for task screen...');

      dynamic response = await _employerRepository.getEmployers();

      print(' Employers response: $response');

      if (response != null) {
        if (response['status'] == true) {
          List<dynamic> employersList = response['data'] ?? [];
          employers.value = employersList.map((employer) {
            return Map<String, dynamic>.from(employer);
          }).toList();

          // Initialize filtered employers with all employers (even if empty)
          filteredEmployers.value = List.from(employers);

          print(
            '✅ Employers loaded successfully: ${employers.length} employers',
          );
        } else {
          // Even if API fails, initialize with empty lists to show dropdown
          employers.value = [];
          filteredEmployers.value = [];
          print('❌ Failed to load employers: ${response['message']}');
        }
      } else {
        // Even if no response, initialize with empty lists to show dropdown
        employers.value = [];
        filteredEmployers.value = [];
        print('❌ No response from server');
      }
    } catch (e) {
      // Even if error occurs, initialize with empty lists to show dropdown
      employers.value = [];
      filteredEmployers.value = [];
      print('❌ Error fetching employers: $e');
    } finally {
      employerLoading.value = false;
    }
  }

  void filterEmployers(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredEmployers.value = List.from(employers);
    } else {
      filteredEmployers.value = employers.where((employer) {
        final name = (employer['employer_name'] ?? employer['name'] ?? '')
            .toString()
            .toLowerCase();
        final company = (employer['company'] ?? '').toString().toLowerCase();
        final location = (employer['location'] ?? '').toString().toLowerCase();
        final searchLower = query.toLowerCase();

        return name.contains(searchLower) ||
            company.contains(searchLower) ||
            location.contains(searchLower);
      }).toList();
    }
  }

  Future<void> deleteEmployer(String employerId) async {
    try {
      employerLoading.value = true;

      print('🗑️ Deleting employer with ID: $employerId');

      dynamic response = await _employerRepository.deleteEmployer(employerId);

      print('📋 Delete response: $response');

      if (response != null) {
        if (response['status'] == true) {
          Utils.snakBar('Success', 'Employer deleted successfully!');
          // Refresh the employers list
          await fetchEmployers();
        } else {
          Utils.snakBar(
            'Error',
            response['message'] ?? 'Failed to delete employer',
          );
        }
      } else {
        Utils.snakBar('Error', 'No response from server');
      }
    } catch (e) {
      print('❌ Error deleting employer: $e');
      Utils.snakBar('Error', 'Failed to delete employer');
    } finally {
      employerLoading.value = false;
    }
  }
}
