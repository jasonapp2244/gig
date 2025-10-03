import 'package:get/get.dart';
import '../../../repository/task/get_task_repository.dart';
import '../../../utils/utils.dart';

class GetTaskViewModel extends GetxController {
  final _api = GetTaskRepository();
  RxString status = "".obs;

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
    fetchTaskStatus(); // Initial load without status filter
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

  // Refresh data with optional silent mode
  Future<void> refreshData({bool silent = false, String? status}) async {
    try {
      if (!silent) {
        // Show loading indicator only for manual refreshes
        loading.value = true;
      }

      // Fetch both tasks and status summary (all data)
      await Future.wait([fetchTasks(), fetchTaskStatus()]);

      print('✅ Task data refreshed successfully');
    } catch (e) {
      print('❌ Error refreshing task data: $e');
    } finally {
      if (!silent) {
        loading.value = false;
      }
    }
  }

  List<Map<String, dynamic>> getTasksByStatus(String status) {
    return tasks.where((task) {
      final taskStatus = (task['status'] ?? '').toString().toLowerCase();
      final hasEntry = task['has_entry'] ?? false;

      // Map API status to UI status
      if (status == 'Ongoing') {
        // Show tasks that are not completed (no entry or status is not completed)
        return !hasEntry && taskStatus != 'completed';
      } else if (status == 'Completed') {
        // Show tasks that are completed (has entry or status is completed)
        return hasEntry == true || taskStatus == 'completed';
      }

      return false;
    }).toList();
  }

  List<Map<String, dynamic>> getEmployerSummariesByStatus(String status) {
    List<Map<String, dynamic>> employerSummaries = [];

    print('🔍 Getting employer summaries for status: $status');

    // Use employer_status_summary only
    final summaries = taskStatusSummary['employer_status_summary'];

    if (summaries != null && summaries is List && summaries.isNotEmpty) {
      print('📊 Using employer_status_summary data');

      for (var summary in summaries) {
        final summaryStatus = summary['status'] ?? '';

        // Map UI status to API status for filtering
        String apiStatus = '';
        switch (status.toLowerCase()) {
          case 'incomplete':
            apiStatus = 'pending';
            break;
          case 'ongoing':
            apiStatus = 'ongoing';
            break;
          case 'completed':
            apiStatus = 'completed';
            break;
          default:
            apiStatus = status.toLowerCase();
        }

        // Only include summaries that match the current tab status
        if (summaryStatus.toString().toLowerCase() != apiStatus) {
          continue;
        }

        final employerName = summary['employer_name'] ?? 'Unknown Employer';
        final employerId = summary['employer_id'] ?? 0;
        final totalTasks = summary['total'] ?? 0;
        final count = summary['count'] ?? 0;
        final percentage = summary['percentage']?.toString() ?? '';
        final fromDate = summary['from_date'];
        final toDate = summary['to_date'];
        final summaryText = summary['summary_text'] ?? '';

        employerSummaries.add({
          'employer_name': employerName,
          'employer_id': employerId,
          'total': totalTasks,
          'status': summaryStatus,
          'count': count,
          'percentage': percentage,
          'summary_text': summaryText,
          'from_date': fromDate,
          'to_date': toDate,
          'has_entry': count > 0,
        });

        print(
          '✅ Added: $employerName | Status: $summaryStatus | Total: $totalTasks | Count: $count | Percentage: $percentage',
        );
      }

      print(
        '✅ Total summaries found for "$status": ${employerSummaries.length}',
      );
    } else {
      print('❌ No employer_status_summary data found in taskStatusSummary.');
    }

    return employerSummaries;
  }

  Future<void> fetchTaskStatus({String? status}) async {
    try {
      statusLoading.value = true;

      print('🔄 Fetching task status summary (all statuses)');

      // Don't pass status parameter to get all data
      dynamic response = await _api.getTaskStatusAPI();

      print('📊 Task status response: $response');

      if (response != null) {
        if (response['status'] == true) {
          // Store the full response to access employer_status_summary array
          Map<String, dynamic> fullData = Map<String, dynamic>.from(response);
          fullData.remove('status'); // Remove non-data fields
          fullData.remove('message');

          taskStatusSummary.value = fullData;
          print('✅ Task status loaded successfully');
          print('📊 Full taskStatusSummary: $taskStatusSummary');
          print('📊 taskStatusSummary keys: ${taskStatusSummary.keys}');
          print(
            '📊 employer_status_summary: ${response['employer_status_summary']}',
          );
          print(
            '📊 employer_status_summary type: ${response['employer_status_summary']?.runtimeType}',
          );
          print(
            '📊 employer_status_summary length: ${response['employer_status_summary']?.length}',
          );
          print('📊 tasks: ${response['tasks']}');
          print('📊 tasks length: ${response['tasks']?.length}');
          print(
            '📊 employer_status_summary: ${response['employer_status_summary']}',
          );
          print(
            '📊 employer_status_summary length: ${response['employer_status_summary']?.length}',
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

  Future<List<Map<String, dynamic>>> fetchTasksByEmployer({
    required int employerId,
    required String status,
  }) async {
    try {
      final tasks = await _api.getSpecficTasks(
        status: status,
        employerId: employerId.toString(),
      );
      return tasks ?? [];
    } catch (e) {
      print("❌ Error fetching tasks: $e");
      return [];
    }
  }
}
