import 'package:get/get.dart';
import 'package:gig/utils/utils.dart';
import '../auth/logout_view_model.dart';
import '../task/get_task_view_model.dart';

class HomeViewModel extends GetxController {
  final LogoutViewModel logoutViewModel = Get.put(LogoutViewModel());
  final GetTaskViewModel taskViewModel = Get.put(GetTaskViewModel());

  RxString userName = 'User'.obs;
  RxString userEmail = 'user@example.com'.obs;
  RxString profileImage = ''.obs;

  // Task-related observables
  RxList<Map<String, dynamic>> tasks = <Map<String, dynamic>>[].obs;
  RxSet<DateTime> taskDates = <DateTime>{}.obs;
  RxMap<DateTime, List<Map<String, dynamic>>> tasksByDate =
      <DateTime, List<Map<String, dynamic>>>{}.obs;
  RxBool tasksLoading = false.obs;

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

      print('✅ Loaded user data: $name, $email');
    } catch (e) {
      print('❌ Error loading user data: $e');
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
        '✅ Calendar tasks loaded: ${tasks.length} tasks, ${taskDates.length} unique dates',
      );
    } catch (e) {
      print('❌ Error fetching tasks for calendar: $e');
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
          DateTime taskDate = DateTime.parse(taskDateTimeStr);
          // Normalize to date only (remove time)
          DateTime normalizedDate = DateTime(
            taskDate.year,
            taskDate.month,
            taskDate.day,
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
        print('⚠️ Error processing task date: $e for task: ${task['id']}');
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
      return status == 'pending' && !hasEntry;
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
    if (status == 'pending') return 'Ongoing';
    return status ?? 'Unknown';
  }
}
