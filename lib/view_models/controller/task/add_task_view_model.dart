import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
  final positionController = TextEditingController().obs;
  final supervisorController = TextEditingController().obs;
  // final workingHoursController = TextEditingController().obs;
  final wagesController = TextEditingController().obs;
  final straightTimeController = TextEditingController().obs;
  final notesController = TextEditingController().obs;
  final timeController = TextEditingController().obs;
  DateTime? selectedDate;
  Rx<DateTime?> selectedTime = Rx<DateTime?>(null);

  RxBool loading = false.obs;
  RxBool employerLoading = false.obs;
  RxList<Map<String, dynamic>> employers = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> filteredEmployers = <Map<String, dynamic>>[].obs;
  RxString searchQuery = ''.obs;
  var employerText = "";
  String formattedDateTime = "";
  Future<void> addTaskApi() async {
    loading.value = true;

    // Validate employer field
    employerText = employerController.value.text.trim();
    if (employerText.isEmpty) {
      loading.value = false;
      Utils.snakBar('Error', 'Please select or enter an employer name');
      return;
    }

    // Handle null selectedDate by using current date as default
    DateTime taskDate = selectedDate ?? DateTime.now();
    DateTime now = DateTime.now();
    DateTime taskDateTime;

    if (selectedTime.value != null) {
      // Use selected time with selected date
      taskDateTime = DateTime(
        taskDate.year,
        taskDate.month,
        taskDate.day,
        selectedTime.value!.hour,
        selectedTime.value!.minute,
        selectedTime.value!.second,
      );
    } else {
      // Use current time if no time selected
      taskDateTime = DateTime(
        taskDate.year,
        taskDate.month,
        taskDate.day,
        now.hour,
        now.minute,
        now.second,
      );
    }

    // ✅ Format datetime as "Y-m-d H:i:s" using intl
    formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(taskDateTime);
    print('✅ Formatted task_date_time: $formattedDateTime');

    Map<String, dynamic> data = {
      'employer': employerText,
      'job_title': jobTypeController.value.text,
      'location': locationController.value.text,
      'supervisor_contact_number': supervisorController.value.text,
      'task_date_time': formattedDateTime,
      'pay': wagesController.value.text,
      'working_hours': straightTimeController.value.text,
      'notes': notesController.value.text,
    };

    print('📋 Task data being sent: $data');

    try {
      dynamic value = await _api.addTaskAPI(data);
      loading.value = false;

      if (value['status'] == true) {
        Utils.snakBar('Success', 'Task added successfully!');

        // Refresh both task list and home calendar data
        await taskViewModel.refreshData();
        clear();

        // Refresh home screen calendar data
        try {
          final HomeViewModel homeController = Get.find<HomeViewModel>();
          await homeController.silentRefreshTasksForCalendar();
        } catch (e) {
          print('⚠️ Could not refresh home calendar: $e');
        }

        // Navigate to Tasks tab
        try {
          final HomeViewModel homeController = Get.find<HomeViewModel>();
          homeController.changeTab(1);
        } catch (e) {
          print('⚠️ Could not navigate to Tasks tab: $e');
          Get.toNamed(RoutesName.screenHolderScreen);
        }
      } else {
        String errorMessage = value['message'] ?? 'Something went wrong';
        Utils.snakBar('Task Add', errorMessage);
      }
    } catch (error) {
      loading.value = false;
      Utils.snakBar('Error', error.toString());
    }
  }

  clear() {
    jobTypeController.value.clear();
    locationController.value.clear();
    supervisorController.value.clear();
    selectedTime.value = null;
    selectedDate = null;
    timeController.value.clear();

    employerController.value.clear();
    positionController.value.clear();

    wagesController.value.clear();
    straightTimeController.value.clear();
    notesController.value.clear();
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

  DateTime? _countryTime;

  // Method to select time
  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime.value != null
          ? TimeOfDay.fromDateTime(selectedTime.value!)
          : TimeOfDay.now(),
    );

    if (picked != null) {
      // Create a DateTime with the picked time
      final now = DateTime.now();
      selectedTime.value = DateTime(
        now.year,
        now.month,
        now.day,
        picked.hour,
        picked.minute,
      );

      // Update the text field with formatted time
      timeController.value.text = picked.format(context);
      print('🕐 Time selected: ${selectedTime.value}');
      print('🕐 Time field updated: ${timeController.value.text}');
    }
  }

  // Method to clear selected time
  void clearSelectedTime() {
    selectedTime.value = null;
    timeController.value.clear();
    print('🕐 Time cleared');
  }
}
