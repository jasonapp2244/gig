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

      if (response != null && response['status'] == true) {
        Utils.snakBar('Success', 'Task deleted successfully!');

        // Refresh data in background to sync with server
        try {
          final GetTaskViewModel taskViewModel = Get.find<GetTaskViewModel>();
          await taskViewModel.refreshData();

          final HomeViewModel homeController = Get.find<HomeViewModel>();
          await homeController.silentRefreshTasksForCalendar();
          print('✅ Home calendar data refreshed after deleting task');
        } catch (e) {
          print('⚠️ Could not update task list: $e');
        }
      } else {
        // If deletion failed, we need to rollback the UI change
        Utils.snakBar('Error', response?['message'] ?? 'Failed to delete task');
        try {
          final GetTaskViewModel taskViewModel = Get.find<GetTaskViewModel>();
          await taskViewModel.refreshData(); // Refresh to restore the deleted item
        } catch (e) {
          print('⚠️ Could not rollback task list: $e');
        }
      }
    } catch (e) {
      print('❌ Error deleting task: $e');
      Utils.snakBar('Error', 'Failed to delete task');
      // Rollback the UI change on error
      try {
        final GetTaskViewModel taskViewModel = Get.find<GetTaskViewModel>();
        await taskViewModel.refreshData(); // Refresh to restore the deleted item
      } catch (e) {
        print('⚠️ Could not rollback task list: $e');
      }
    } finally {
      loadingTasks.remove(taskId);
    }
  }
}
