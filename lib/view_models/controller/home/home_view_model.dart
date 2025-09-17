import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:gig/utils/utils.dart';
import '../auth/logout_view_model.dart';
import '../task/get_task_view_model.dart';
import '../../../data/network/network_api_services.dart';
import '../../../res/app_url/app_url.dart';
import '../user_preference/user_preference_view_model.dart';

class HomeViewModel extends GetxController {
  final LogoutViewModel logoutViewModel = Get.put(LogoutViewModel());
  final GetTaskViewModel taskViewModel = Get.put(GetTaskViewModel());
  final NetworkApiServices _apiServices = NetworkApiServices();
  final UserPreference _userPreference = UserPreference();
  RxInt selectedIndex = 0.obs;
  RxString userName = 'User'.obs;
  RxString userEmail = 'user@example.com'.obs;
  RxString profileImage = ''.obs;

  // Task-related observables
  RxList<Map<String, dynamic>> tasks = <Map<String, dynamic>>[].obs;
  RxSet<DateTime> taskDates = <DateTime>{}.obs;
  RxMap<DateTime, List<Map<String, dynamic>>> tasksByDate =
      <DateTime, List<Map<String, dynamic>>>{}.obs;
  RxBool tasksLoading = false.obs;

  // Tasks by specific date (for API call)
  RxList<Map<String, dynamic>> tasksBySpecificDate =
      <Map<String, dynamic>>[].obs;
  RxBool tasksByDateLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    fetchTasksForCalendar();
  }

  Future<void> loadUserData() async {
    try {
      // Load user data from secure storage
      String? name = await Utils.readSecureData('user_name');
      String? email = await Utils.readSecureData('user_email');
      String? avatar = await Utils.readSecureData('user_avatar');

      if (name != null && name.isNotEmpty) {
        userName.value = name;
      }

      if (email != null && email.isNotEmpty) {
        userEmail.value = email;
      }

      if (avatar != null && avatar.isNotEmpty) {
        profileImage.value = avatar;
      }

      print(' Loaded user data: $name, $email');
    } catch (e) {
      print(' Error loading user data: $e');
    }
  }

  Future<void> refreshUserData() async {
    await loadUserData();
  }

  /// Fetch tasks and process them for calendar display
  Future<void> fetchTasksForCalendar() async {
    try {
      tasksLoading.value = true;
      print('🔄 Fetching tasks for calendar...');

      // Fetch tasks using the existing task view model
      await taskViewModel.fetchTasks();

      // Update local task list
      tasks.value = taskViewModel.tasks.toList();

      // Process tasks to extract dates and organize by date
      _processTasksForCalendar();

      print(
        ' Calendar tasks loaded: ${tasks.length} tasks, ${taskDates.length} unique dates',
      );
    } catch (e) {
      print(' Error fetching tasks for calendar: $e');
      tasks.value = [];
      taskDates.clear();
      tasksByDate.clear();
    } finally {
      tasksLoading.value = false;
    }
  }

  /// Process tasks to extract dates and organize them for calendar display
  void _processTasksForCalendar() {
    taskDates.clear();
    tasksByDate.clear();

    for (Map<String, dynamic> task in tasks) {
      try {
        // Extract task date from task_date_time
        String? taskDateTimeStr = task['task_date_time'];
        if (taskDateTimeStr != null && taskDateTimeStr.isNotEmpty) {
          // Parse as local time to avoid timezone conversion issues
          DateTime taskDate;
          try {
            // If the string contains 'T' or 'Z', handle it carefully
            if (taskDateTimeStr.contains('T')) {
              // Remove 'Z' if present and parse as local time
              String localDateStr = taskDateTimeStr.replaceAll('Z', '');
              taskDate = DateTime.parse(localDateStr);
            } else {
              taskDate = DateTime.parse(taskDateTimeStr);
            }
          } catch (e) {
            print('⚠️ Error parsing date: $taskDateTimeStr, error: $e');
            continue; // Skip this task if date parsing fails
          }

          // Normalize to date only (remove time) - ensure we keep the same date
          DateTime normalizedDate = DateTime(
            taskDate.year,
            taskDate.month,
            taskDate.day,
          );

          print('📅 Processing task: ${task['job_title'] ?? 'Unknown'}');
          print('📅 Original date string: $taskDateTimeStr');
          print('📅 Parsed taskDate: $taskDate');
          print('📅 Normalized date: $normalizedDate');
          print(
            '📅 Normalized date components: ${normalizedDate.year}-${normalizedDate.month}-${normalizedDate.day}',
          );

          // Add to set of unique dates
          taskDates.add(normalizedDate);

          // Group tasks by date
          if (!tasksByDate.containsKey(normalizedDate)) {
            tasksByDate[normalizedDate] = [];
          }
          tasksByDate[normalizedDate]!.add(task);
        }
      } catch (e) {
        print(' Error processing task date: $e for task: ${task['id']}');
      }
    }

    // Force UI update
    taskDates.refresh();
    tasksByDate.refresh();
  }

  /// Get events for a specific date (used by TableCalendar eventLoader)
  List<Map<String, dynamic>> getEventsForDate(DateTime date) {
    DateTime normalizedDate = DateTime(date.year, date.month, date.day);
    return tasksByDate[normalizedDate] ?? [];
  }

  /// Check if a date has any tasks
  bool hasTasksOnDate(DateTime date) {
    DateTime normalizedDate = DateTime(date.year, date.month, date.day);
    return taskDates.contains(normalizedDate);
  }

  /// Get tasks for a specific date
  List<Map<String, dynamic>> getTasksForDate(DateTime date) {
    DateTime normalizedDate = DateTime(date.year, date.month, date.day);
    return tasksByDate[normalizedDate] ?? [];
  }

  /// Get ongoing tasks for a specific date
  List<Map<String, dynamic>> getOngoingTasksForDate(DateTime date) {
    List<Map<String, dynamic>> dateTasks = getTasksForDate(date);
    return dateTasks.where((task) {
      final status = task['status'] ?? '';
      final hasEntry = task['has_entry'] ?? false;
      return status == 'o' && !hasEntry;
    }).toList();
  }

  /// Get completed tasks for a specific date
  List<Map<String, dynamic>> getCompletedTasksForDate(DateTime date) {
    List<Map<String, dynamic>> dateTasks = getTasksForDate(date);
    return dateTasks.where((task) {
      final hasEntry = task['has_entry'] ?? false;
      return hasEntry == true;
    }).toList();
  }

  /// Refresh tasks and update calendar
  Future<void> refreshTasksForCalendar() async {
    await fetchTasksForCalendar();
    Utils.snakBar('Success', 'Calendar updated with latest tasks!');
  }

  /// Silent refresh for automatic updates (no snackbar)
  Future<void> silentRefreshTasksForCalendar() async {
    await fetchTasksForCalendar();
  }

  /// Format date for display
  String formatTaskDate(String? dateString) {
    if (dateString == null || dateString == 'N/A') return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return 'N/A';
    }
  }

  /// Map task status for display
  String mapTaskStatus(String? status, bool? hasEntry) {
    if (hasEntry == true) return 'Completed';
    if (status == 'ongoing') return 'Ongoing';
    return status ?? 'Unknown';
  }

  // For special/extra screens (like AddTaskScreen)
  var overrideScreen = Rxn<Widget>();

  void changeTab(int index) {
    overrideScreen.value = null; // clear special screen when using tabs
    selectedIndex.value = index;
  }

  void openScreen(Widget screen) {
    overrideScreen.value = screen; // set special screen
  }

  /// Fetch tasks for a specific date using the API
  Future<void> fetchTasksByDate(DateTime selectedDate, String tokenId) async {
    try {
      tasksByDateLoading.value = true;
      tasksBySpecificDate.clear();

      print('🔴 DEBUG: fetchTasksByDate called with: $selectedDate');

      // Get user token
      final userData = await _userPreference.getUser();

      print(
        '🔴 DEBUG: Token preview: ${tokenId.isEmpty ? 'EMPTY' : tokenId.substring(0, 10)}...',
      );

      if (tokenId.isEmpty) {
        print('❌ No token found, cannot fetch tasks by date');
        return;
      }

      // Format date as required by API (YYYY-MM-DD)
      String formattedDate =
          "${selectedDate.year.toString().padLeft(4, '0')}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";

      print('🔴 DEBUG: Formatted date for API: $formattedDate');
      print(
        '🔴 DEBUG: Full API URL will be: ${AppUrl.taskByDate}/$formattedDate',
      );
      print('🔴 DEBUG: Calling getTaskByDate...');

      // Use the existing getTaskByDate method from NetworkApiServices
      print('🔴 DEBUG: About to call API with:');
      print('🔴 DEBUG: - Token: ${tokenId.substring(0, 10)}...');
      print('🔴 DEBUG: - TaskId (date): $formattedDate');
      print('🔴 DEBUG: - URL: ${AppUrl.taskByDate}');
      print(
        '🔴 DEBUG: - Full URL will be: ${AppUrl.taskByDate}/$formattedDate',
      );

      dynamic response = await _apiServices.getTaskByDate(
        tokenId,
        date: formattedDate, // Using taskId parameter for the date
        url: AppUrl.taskByDate,
      );

      print('🔴 DEBUG: API Response received: $response');
      print('🔴 DEBUG: Response type: ${response.runtimeType}');

      if (response != null && response['status'] == true) {
        // Handle the response data
        List<dynamic> tasksData = response['tasks'] ?? [];

        tasksBySpecificDate.value = tasksData.map((task) {
          return Map<String, dynamic>.from(task);
        }).toList();

        print(
          '✅ Successfully fetched ${tasksBySpecificDate.length} tasks for date: $formattedDate',
        );
      } else {
        print(
          '❌ Failed to fetch tasks by date: ${response?['message'] ?? 'Unknown error'}',
        );
        tasksBySpecificDate.clear();
      }
    } catch (e) {
      print('❌ Error fetching tasks by date: $e');
      tasksBySpecificDate.clear();
    } finally {
      tasksByDateLoading.value = false;
    }
  }

  /// Format date for display
  String formatDisplayDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
