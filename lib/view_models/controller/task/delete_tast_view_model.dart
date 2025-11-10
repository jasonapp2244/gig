import 'package:get/get.dart';
import 'package:gig/repository/task/delete_task_repository.dart';
import 'package:gig/utils/utils.dart';
import 'package:gig/view_models/controller/task/get_task_view_model.dart';
import 'package:gig/view_models/controller/home/home_view_model.dart';

class DeleteTaskViewModel extends GetxController {
  final _deleteTaskRepository = DeleteTaskRepository();

  // Track loading per task ID
  var loadingTasks = <int>{}.obs;

  Future<void> deleteTask(int taskId) async {
    loadingTasks.add(taskId);
    try {
      dynamic response = await _deleteTaskRepository.deleteTaskAPI(taskId);
      print('📋 Delete response: $response');

      if (response != null && response['success'] == true) {
        Utils.snakBar('Test', 'Task deleted successfully!');

        try {
          final GetTaskViewModel taskViewModel = Get.find<GetTaskViewModel>();
          taskViewModel.tasks.removeWhere((task) {
            final taskIdFromList = task['id'];
            if (taskIdFromList is String) {
              return int.tryParse(taskIdFromList) == taskId;
            } else if (taskIdFromList is int) {
              return taskIdFromList == taskId;
            }
            return false;
          });

          // Notify listeners/UI immediately
          taskViewModel.tasks.refresh();

          // Update calendar silently
          final HomeViewModel homeController = Get.find<HomeViewModel>();
          await homeController.silentRefreshTasksForCalendar();

          print('✅ Task removed and calendar refreshed');
        } catch (e) {
          print('⚠️ Could not update task list: $e');
        }
      }
      // if (response != null && response['status'] == true) {
      //   Utils.snakBar('Success', 'Task deleted successfully!');
      //   // Update UI as you already do
      //   try {
      //     final GetTaskViewModel taskViewModel = Get.find<GetTaskViewModel>();
      //     taskViewModel.tasks.removeWhere((task) {
      //       final taskIdFromList = task['id'];
      //       if (taskIdFromList is String) {
      //         return int.tryParse(taskIdFromList) == taskId;
      //       } else if (taskIdFromList is int) {
      //         return taskIdFromList == taskId;
      //       }
      //       return false;
      //     });
      //     await taskViewModel.refreshData();
      //     final HomeViewModel homeController = Get.find<HomeViewModel>();
      //     await homeController.silentRefreshTasksForCalendar();
      //     print('✅ Home calendar data refreshed after deleting task');
      //   } catch (e) {
      //     print('⚠️ Could not update task list: $e');
      //   }
      // }
      else {
        Utils.snakBar('Error', response?['message'] ?? 'Failed to delete task');
      }
    } catch (e) {
      print('❌ Error deleting task: $e');
      Utils.snakBar('Error', 'Failed to delete task');
    } finally {
      loadingTasks.remove(taskId);
    }
  }
}
