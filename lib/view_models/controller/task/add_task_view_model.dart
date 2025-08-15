import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../repository/task/add_task_repository.dart';
import '../../../repository/employer/employer_repository.dart';
import '../../../res/routes/routes_name.dart';
import '../../../utils/utils.dart';
import '../user_preference/user_preference_view_model.dart';
import '../task/get_task_view_model.dart';

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
    Map data = {
      'employer': employerController.value.text,
      'job_title': jobTypeController.value.text,
      'location': locationController.value.text,
      'supervisorContactNumber': supervisorController.value.text,
      //  'workingHoursController': workingHoursController.value.text,
      'task_date_time':
          "${selectedDate!.year.toString().padLeft(4, '0')}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}T${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}:${DateTime.now().second.toString().padLeft(2, '0')}.${DateTime.now().millisecond.toString().padLeft(3, '0')}Z",
      'pay': wagesController.value.text,
      'workingHours': straightTimeController.value.text,
      'notes': notesController.value.text,
    };

    try {
      dynamic value = await _api.addTaskAPI(data);
      loading.value = false;

      if (value['status'] == true) {
        Utils.snakBar('Success', 'Task added successfully!');
        // Refresh the task list to show the new task
        await taskViewModel.refreshTasks();
        Get.toNamed(RoutesName.taskScreen);
      } else {
        print("Task Add failed: $value");
        print("Task Add failed: ${value['errors']}");
        Utils.snakBar('Task Add', value['errors'] ?? 'Something went wrong');
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
