import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gig/view_models/controller/task/get_task_view_model.dart';
import '../../../../res/colors/app_color.dart';
import '../../../../res/components/input.dart';
import '../../../../res/components/round_button.dart';
import '../../../../res/components/employer_dropdown.dart';
import '../../../../view_models/controller/task/add_task_view_model.dart';
import '../../../../utils/utils.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final getTaskVM = Get.put(GetTaskViewModel());
  final addTaskVM = Get.put(AddTaskViewModel());
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Get the selected date from navigation arguments
    final args = Get.arguments;
    if (args != null && args['selectedDate'] != null) {
      addTaskVM.selectedDate = args['selectedDate'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.appBodyBG,
        body: Column(
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
            // Display selected date if available
            if (addTaskVM.selectedDate != null)
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                  color: AppColor.primeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColor.primeColor.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: AppColor.primeColor,
                      size: 20,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Selected Date: ${addTaskVM.selectedDate!.day}/${addTaskVM.selectedDate!.month}/${addTaskVM.selectedDate!.year}',
                      style: TextStyle(
                        color: AppColor.primeColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
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
                          controller: addTaskVM.jobTypeController.value,
                          fieldType: 'text',
                          hintText: "Task Name",
                          requiredField: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Task name is required';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(
                              () => EmployerDropdown(
                                controller: addTaskVM.employerController.value,
                                employers: addTaskVM.employers,
                                filteredEmployers: addTaskVM.filteredEmployers,
                                onSearchChanged: (query) {
                                  addTaskVM.filterEmployers(query);
                                },
                                onDeleteEmployer: (employerId) {
                                  addTaskVM.deleteEmployer(employerId);
                                },
                                isLoading: addTaskVM.employerLoading.value,
                              ),
                            ),
                          ],
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
                            if (value == null || value.isEmpty) {
                              return 'Location is required';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: CustomInputField(
                          controller: addTaskVM.supervisorController.value,
                          fieldType: 'text',
                          hintText: "Supervisor & their contact",
                          requiredField: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Supervisor contact is required';
                            }
                            return null;
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
                            if (value == null || value.isEmpty) {
                              return 'Wages is required';
                            }
                            return null;
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
                            if (value == null || value.isEmpty) {
                              return 'Straight time is required';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: CustomInputField(
                          controller: addTaskVM.notesController.value,
                          fieldType: 'text',
                          hintText: "Notes",
                          requiredField: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Notes is required';
                            }
                            return null;
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
                    // Check if employer is entered
                    if (addTaskVM.employerController.value.text.isEmpty) {
                      Utils.snakBar('Error', 'Please enter an employer name');
                      return;
                    }

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
