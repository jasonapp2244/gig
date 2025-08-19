import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../repository/task/get_task_repository.dart';
import '../../../utils/utils.dart';

class GetTaskViewModel extends GetxController {
  final _api = GetTaskRepository();

  RxBool loading = false.obs;
  RxList<Map<String, dynamic>> tasks = <Map<String, dynamic>>[].obs;
  RxString searchQuery = ''.obs;

  // Task status summary observables
  RxBool statusLoading = false.obs;
  RxMap<String, dynamic> taskStatusSummary = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    //  fetchTasks();
    fetchTaskStatus();
  }

  Future<void> fetchTasks() async {
    try {
      loading.value = true;

      print('🔄 Fetching tasks...');

      dynamic response = await _api.getTasksAPI();

      print('📋 Tasks response: $response');

      if (response != null) {
        if (response['status'] == true) {
          List<dynamic> tasksList = response['tasks'] ?? [];
          tasks.value = tasksList.map((task) {
            return Map<String, dynamic>.from(task);
          }).toList();

          print('✅ Tasks loaded successfully: ${tasks.length} tasks');
        } else {
          tasks.value = [];
          print('❌ Failed to load tasks: ${response['message']}');
        }
      } else {
        tasks.value = [];
        print('❌ No response from server');
      }
    } catch (e) {
      tasks.value = [];
      print('❌ Error fetching tasks: $e');
      Utils.snakBar('Error', 'Failed to load tasks: $e');
    } finally {
      loading.value = false;
    }
  }

  List<Map<String, dynamic>> getFilteredTasks(String searchText) {
    if (searchText.isEmpty) {
      return tasks.toList();
    }

    return tasks.where((task) {
      final title = (task['job_title'] ?? '').toString().toLowerCase();
      final startDate = (task['task_date_time'] ?? '').toString().toLowerCase();
      final endDate = (task['task_end_date_time'] ?? '')
          .toString()
          .toLowerCase();
      final status = (task['status'] ?? '').toString().toLowerCase();
      final employer = (task['employer'] ?? '').toString().toLowerCase();
      final location = (task['location'] ?? '').toString().toLowerCase();
      final searchLower = searchText.toLowerCase();

      return title.contains(searchLower) ||
          startDate.contains(searchLower) ||
          endDate.contains(searchLower) ||
          status.contains(searchLower) ||
          employer.contains(searchLower) ||
          location.contains(searchLower);
    }).toList();
  }

  List<Map<String, dynamic>> getTasksByStatus(String status) {
    return tasks.where((task) {
      final taskStatus = task['status'] ?? '';
      final hasEntry = task['has_entry'] ?? false;

      // Map API status to UI status
      if (status == 'Ongoing') {
        return taskStatus == '' && !hasEntry;
      } else if (status == 'Completed') {
        return hasEntry == true;
      }

      return false;
    }).toList();
  }

  Future<void> fetchTaskStatus() async {
    try {
      statusLoading.value = true;

      print('🔄 Fetching task status summary...');

      dynamic response = await _api.getTaskStatusAPI();

      print('📊 Task status response: $response');

      if (response != null) {
        if (response['status'] == true) {
          // Store the full response to access employer_all_summary and employer_status_summary arrays
          Map<String, dynamic> fullData = Map<String, dynamic>.from(response);
          fullData.remove('status'); // Remove non-data fields
          fullData.remove('message');

          taskStatusSummary.value = fullData;
          print('✅ Task status loaded successfully: $taskStatusSummary');
          print('📊 employer_all_summary: ${response['employer_all_summary']}');
          print(
            '📊 employer_status_summary: ${response['employer_status_summary']}',
          );
        } else {
          taskStatusSummary.value = {};
          print('❌ Failed to load task status: ${response['message']}');
        }
      } else {
        taskStatusSummary.value = {};
        print('❌ No response from task status API');
      }
    } catch (e) {
      taskStatusSummary.value = {};
      print('❌ Error fetching task status: $e');
      Utils.snakBar('Error', 'Failed to load task status: $e');
    } finally {
      statusLoading.value = false;
    }
  }

  Future<void> refreshTasks() async {
    await fetchTasks();
    await fetchTaskStatus(); // Also refresh status summary
    Utils.snakBar('Success', 'Tasks refreshed successfully!');
  }
}
