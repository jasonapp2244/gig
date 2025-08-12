import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../res/colors/app_color.dart';
import '../../../../res/components/input.dart';
import '../../../../res/components/round_button.dart';
import '../../../../res/routes/routes_name.dart';
import '../../../../view_models/controller/task/add_task_view_model.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final addTaskVM = Get.put(AddTaskViewModel());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBodyBG,
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, bottom: 10, top: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back, color: AppColor.primeColor),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 35,
                  left: 35,
                  child: Text(
                    'Add Task',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColor.secondColor,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: CustomInputField(
                          controller: addTaskVM.employerController.value,
                          fieldType: 'email',
                          hintText: "Task Name",
                          requiredField: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Name is required';
                            }
                            return 'Name is Required';
                          },
                        ),
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: CustomInputField(
                          controller: addTaskVM.jobTypeController.value,
                          fieldType: 'number',
                          hintText: "Income",
                          requiredField: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Name is required';
                            }
                            return 'Name is Required';
                          },
                        ),
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: CustomInputField(
                          controller: addTaskVM.locationController.value,
                          fieldType: 'text',
                          hintText: "Location",
                          requiredField: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Name is required';
                            }
                            return 'Name is Required';
                          },
                        ),
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: CustomInputField(
                          controller: addTaskVM.supervisorController.value,
                          fieldType: 'number',
                          hintText: "Supervisor & their contact",
                          requiredField: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Name is required';
                            }
                            return 'Name is Required';
                          },
                        ),
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: CustomInputField(
                          controller: addTaskVM.workingHoursController.value,
                          fieldType: 'number',
                          hintText: "Working Hours",
                          requiredField: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Name is required';
                            }
                            return 'Name is Required';
                          },
                        ),
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: CustomInputField(
                          controller: addTaskVM.wagesController.value,
                          fieldType: 'number',
                          hintText: "Wages",
                          requiredField: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Name is required';
                            }
                            return 'Name is Required';
                          },
                        ),
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: CustomInputField(
                          controller: addTaskVM.straightTimeController.value,
                          fieldType: 'number',
                          hintText: "Straight time",
                          requiredField: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Name is required';
                            }
                            return 'Name is Required';
                          },
                        ),
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: CustomInputField(
                          controller: addTaskVM.notesController.value,
                          fieldType: 'number',
                          hintText: "Notes",
                          requiredField: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Name is required';
                            }
                            return 'Name is Required';
                          },
                        ),
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
              child: Obx(
                () => RoundButton(
                  width: double.infinity,
                  height: 50,
                  title: 'Add Task',
                  loading: addTaskVM.loading.value,
                  buttonColor: AppColor.primeColor,
                  onPress: () {
                    Get.toNamed(RoutesName.taskScreen);
                    if (_formKey.currentState!.validate()) {
                      addTaskVM.addTaskApi();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
