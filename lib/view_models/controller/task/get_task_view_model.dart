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

      // Fetch both tasks and status summary with optional status filter
      await Future.wait([fetchTasks(), fetchTaskStatus(status: status)]);

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

  // New method to get tasks by status from employer_status_summary
  List<Map<String, dynamic>> getTasksByStatusFromSummary(String status) {
    List<Map<String, dynamic>> filteredTasks = [];

    print('🔍 Filtering tasks by status: $status');
    print('🔍 taskStatusSummary keys: ${taskStatusSummary.keys}');
    print('🔍 tasks available: ${taskStatusSummary['tasks'] != null}');

    // Check if tasks are in the 'tasks' field
    if (taskStatusSummary['tasks'] != null) {
      List<dynamic> tasksList = taskStatusSummary['tasks'];
      print('🔍 Total tasks in tasks list: ${tasksList.length}');

      filteredTasks = tasksList
          .where((task) {
            final taskStatus = (task['status'] ?? '').toString().toLowerCase();
            final hasEntry = task['has_entry'] ?? false;

            print(
              '🔍 Task: ${task['employer'] ?? task['job_title']} - Status: $taskStatus, HasEntry: $hasEntry',
            );

            if (status == 'Ongoing') {
              // Show tasks that are ongoing (not completed)
              bool isOngoing = !hasEntry && taskStatus == 'ongoing';
              print('🔍 Is Ongoing: $isOngoing');
              return isOngoing;
            } else if (status == 'Completed') {
              // Show tasks that are completed
              bool isCompleted = hasEntry == true || taskStatus == 'completed';
              print('🔍 Is Completed: $isCompleted');
              return isCompleted;
            } else if (status == 'Incomplete' || status == 'pending') {
              // Show tasks that are incomplete/pending (not completed and not ongoing)
              bool isIncomplete =
                  !hasEntry &&
                  (taskStatus == 'pending' || taskStatus == 'incomplete');
              print('🔍 Is Incomplete: $isIncomplete');
              return isIncomplete;
            }

            return false;
          })
          .map((task) => Map<String, dynamic>.from(task))
          .toList();

      print('🔍 Filtered tasks count: ${filteredTasks.length}');
    } else {
      print('🔍 No tasks data available in taskStatusSummary');
    }

    return filteredTasks;
  }

  // New method to get employer summaries grouped by employer
  List<Map<String, dynamic>> getEmployerSummariesByStatus(String status) {
    List<Map<String, dynamic>> employerSummaries = [];

    print('🔍 Getting employer summaries for status: $status');
    print('🔍 taskStatusSummary keys: ${taskStatusSummary.keys}');
    print('🔍 Full taskStatusSummary: $taskStatusSummary');

    // Use employer_all_summary data which contains both completed and ongoing counts
    if (taskStatusSummary['employer_all_summary'] != null) {
      List<dynamic> allSummaries = taskStatusSummary['employer_all_summary'];
      print('🔍 Total employer summaries from API: ${allSummaries.length}');

      for (var summary in allSummaries) {
        print('🔍 Processing summary: $summary');

        final employerName = summary['employer_name'] ?? 'Unknown Employer';
        final totalTasks = summary['total'] ?? 0;
        final completedTasks =
            summary['completed'] ?? 0; // Direct completed count
        final ongoingTasks = summary['ongoing'] ?? 0; // Direct ongoing count
        final percentage = summary['percentage'] ?? 0;
        final summaryText = summary['summary_text'] ?? '';
        final fromDate = summary['from_date'];
        final toDate = summary['to_date'];
        final employerId = summary['employer_id'];

        // Filter based on status
        bool shouldInclude = false;
        final pendingTasks = summary['pending'] ?? 0; // Add pending tasks count

        if (status == 'Ongoing') {
          // Show employers that have ongoing tasks
          shouldInclude = ongoingTasks > 0;
        } else if (status == 'Completed') {
          // Show employers that have completed tasks
          shouldInclude = completedTasks > 0;
        } else if (status == 'pending' || status == 'Incomplete') {
          // Show employers that have pending/incomplete tasks
          shouldInclude = pendingTasks > 0;
        }

        if (shouldInclude) {
          employerSummaries.add({
            'employer_name': employerName,
            'employer_id': employerId,
            'total': totalTasks,
            'completed': completedTasks,
            'ongoing': ongoingTasks,
            'pending': pendingTasks, // Add pending tasks count
            'percentage': percentage.toString(),
            'summary_text': summaryText,
            'from_date': fromDate,
            'to_date': toDate,
            'status': status, // Use the requested status
            'has_entry': completedTasks > 0,
          });

          print(
            '🔍 Added Employer: $employerName - Total: $totalTasks, Completed: $completedTasks, Ongoing: $ongoingTasks, Percentage: $percentage',
          );
        }
      }

      print(
        '🔍 Created ${employerSummaries.length} employer summaries for $status tab',
      );
    } else {
      print('🔍 No employer_all_summary data available in taskStatusSummary');
      print('🔍 Available keys: ${taskStatusSummary.keys.toList()}');
    }

    return employerSummaries;
  }

  Future<void> fetchTaskStatus({String? status}) async {
    try {
      statusLoading.value = true;

      print('🔄 Fetching task status summary for status: $status');

      dynamic response = await _api.getTaskStatusAPI(status: status);

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
          print(
            '📊 employer_status_summary: ${response['employer_status_summary']}',
          );
          print(
            '📊 employer_status_summary type: ${response['employer_status_summary'].runtimeType}',
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
      loading.value = true;
      print("🔄 Fetching tasks for employer $employerId with status: $status");
      
      final fetchedTasks = await _api.getSpecficTasks(
        status: status,
        employerId: employerId.toString(),
      );
      
      print("📋 Fetched ${fetchedTasks?.length ?? 0} tasks");
      
      // Update the observable tasks list
      if (fetchedTasks != null) {
        tasks.value = fetchedTasks;
        print("✅ Updated tasks list with ${tasks.length} tasks");
      } else {
        tasks.value = [];
        print("⚠️ No tasks returned from API");
      }
      
      return fetchedTasks ?? [];
    } catch (e) {
      print("❌ Error fetching tasks: $e");
      tasks.value = [];
      return [];
    } finally {
      loading.value = false;
    }
  }
}
