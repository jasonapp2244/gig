import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../repository/task/add_task_repository.dart';
import '../../../utils/utils.dart';
import '../user_preference/user_preference_view_model.dart';

class AddTaskViewModel extends GetxController {

  final _api = AddTaskRepository();
  UserPreference userPreference = UserPreference();
  final employerController = TextEditingController().obs;
  final jobTypeController = TextEditingController().obs;
  final locationController = TextEditingController().obs;
  final supervisorController = TextEditingController().obs;
  final workingHoursController = TextEditingController().obs;
  final wagesController = TextEditingController().obs;
  final straightTimeController = TextEditingController().obs;
  final notesController = TextEditingController().obs;

  RxBool loading = false.obs;

  void addTaskApi() {
    loading.value = true;
    Map data = {
      'email': employerController.value.text,
      'password': jobTypeController.value.text,
      'locationController': locationController.value.text,
      'supervisorController': supervisorController.value.text,
      'workingHoursController': workingHoursController.value.text,
      'wagesController': wagesController.value.text,
      'straightTimeController': straightTimeController.value.text,
      'notesController': notesController.value.text,
    };

    _api.addTaskAPI(data).then((value) {
      loading.value = false;

      if (value['status'] == true) {
        // YOUR CONDITIONS HERE
      }
      else {
        print("Task Add failed: $value");
        print("Task Add failed: ${value['errors']}");
        Utils.snakBar('Task Add', value['errors'] ?? 'Something went wrong');
      }

    }).onError((error, stackTrace) {
      loading.value = false;
      print('Task Add API error: ${error.toString()}');
      Utils.snakBar('Error', error.toString());
    });
  }

}
