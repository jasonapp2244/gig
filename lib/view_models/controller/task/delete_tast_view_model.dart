import 'package:get/get.dart';
import 'package:gig/repository/task/delete_task_repository.dart';
import 'package:gig/utils/utils.dart';
import 'package:gig/view_models/controller/task/get_task_view_model.dart';

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
          
          // Refresh the tasks list automatically
          try {
            final GetTaskViewModel taskViewModel = Get.find<GetTaskViewModel>();
            await taskViewModel.fetchTasks(); // Refresh without showing another snackbar
          } catch (e) {
            print('⚠️ Could not refresh task list: $e');
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
