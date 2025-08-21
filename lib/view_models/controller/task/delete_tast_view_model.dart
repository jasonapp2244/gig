import 'package:get/get.dart';
import 'package:gig/repository/task/delete_task_repository.dart';
import 'package:gig/utils/utils.dart';
import 'package:gig/view_models/controller/task/get_task_view_model.dart';
import 'package:gig/view_models/controller/home/home_view_model.dart';

class DeleteTaskViewModel extends GetxController {
  RxBool loading = false.obs;
  final _deleteTaskRepository = DeleteTaskRepository();

  Future<void> deleteTask(int taskId) async {
    try {
      loading.value = true;

      dynamic response = await _deleteTaskRepository.deleteTaskAPI(taskId);

      print('📋 Delete response: $response');

      if (response != null) {
        if (response['status'] == true) {
          Utils.snakBar('Success', 'Task deleted successfully!');

          // Update the UI immediately by removing the task from local list
          try {
            final GetTaskViewModel taskViewModel = Get.find<GetTaskViewModel>();

            print('🗑️ Before deletion: ${taskViewModel.tasks.length} tasks');
            print('🗑️ Deleting task with ID: $taskId');

            // Remove the deleted task from the local list immediately for instant UI update
            taskViewModel.tasks.removeWhere((task) {
              final taskIdFromList = task['id'];
              print(
                '🗑️ Comparing task ID: $taskIdFromList (${taskIdFromList.runtimeType}) with $taskId (${taskId.runtimeType})',
              );
              // Handle both string and int ID types
              if (taskIdFromList is String) {
                return int.tryParse(taskIdFromList) == taskId;
              } else if (taskIdFromList is int) {
                return taskIdFromList == taskId;
              }
              return false;
            });

            print('🗑️ After deletion: ${taskViewModel.tasks.length} tasks');

            // Force UI update by triggering a rebuild
            await taskViewModel.refreshData();

            // Also refresh home screen calendar data
            try {
              final HomeViewModel homeController = Get.find<HomeViewModel>();
              await homeController.silentRefreshTasksForCalendar();
              print('✅ Home calendar data refreshed after deleting task');
            } catch (e) {
              print('⚠️ Could not refresh home calendar: $e');
            }
          } catch (e) {
            print('⚠️ Could not update task list: $e');
          }
        } else {
          Utils.snakBar(
            'Error',
            response['message'] ?? 'Failed to delete task',
          );
        }
      } else {
        Utils.snakBar('Error', 'No response from server');
      }
    } catch (e) {
      print('❌ Error deleting task: $e');
      Utils.snakBar('Error', 'Failed to delete task');
    } finally {
      loading.value = false;
    }
  }
}
