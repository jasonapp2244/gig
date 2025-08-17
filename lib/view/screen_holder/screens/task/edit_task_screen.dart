import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gig/view_models/controller/task/edit_task_view_model.dart';
import '../../../../res/colors/app_color.dart';
import '../../../../res/components/input.dart';
import '../../../../res/components/round_button.dart';
import '../../../../res/routes/routes_name.dart';

// class EditTaskScreen extends StatefulWidget {
//   const EditTaskScreen({super.key});

//   @override
//   State<EditTaskScreen> createState() => _EditTaskScreenState();
// }

// class _EditTaskScreenState extends State<EditTaskScreen> {
//   final editTaskVM = Get.put(EditTaskViewModel());
//   final _formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColor.appBodyBG,
//       body: SafeArea(
//         child: Column(
//           children: [
//             Stack(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(left: 20, bottom: 10, top: 10),
//                   child: Align(
//                     alignment: Alignment.centerLeft,
//                     child: InkWell(
//                       onTap: () {
//                         Navigator.pop(context);
//                       },
//                       child: Icon(Icons.arrow_back, color: AppColor.primeColor),
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   top: 10,
//                   right: 35,
//                   left: 35,
//                   child: Text(
//                     'Add Task',
//                     style: TextStyle(
//                       fontSize: 18,
//                       color: AppColor.secondColor,
//                       fontWeight: FontWeight.w400,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 15),
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(left: 20, right: 20),
//                         child: CustomInputField(
//                           controller: editTaskVM.employerController.value,
//                           fieldType: 'email',
//                           hintText: "Task Name",
//                           requiredField: true,
//                           validator: (value) {
//                             if (value!.isEmpty) {
//                               return 'Name is required';
//                             }
//                             return 'Name is Required';
//                           },
//                         ),
//                       ),
//                       SizedBox(height: 15),
//                       Padding(
//                         padding: const EdgeInsets.only(left: 20, right: 20),
//                         child: CustomInputField(
//                           controller: editTaskVM.jobTypeController.value,
//                           fieldType: 'number',
//                           hintText: "Income",
//                           requiredField: true,
//                           validator: (value) {
//                             if (value!.isEmpty) {
//                               return 'Name is required';
//                             }
//                             return 'Name is Required';
//                           },
//                         ),
//                       ),
//                       SizedBox(height: 15),
//                       Padding(
//                         padding: const EdgeInsets.only(left: 20, right: 20),
//                         child: CustomInputField(
//                           controller: editTaskVM.locationController.value,
//                           fieldType: 'text',
//                           hintText: "Location",
//                           requiredField: true,
//                           validator: (value) {
//                             if (value!.isEmpty) {
//                               return 'Name is required';
//                             }
//                             return 'Name is Required';
//                           },
//                         ),
//                       ),
//                       SizedBox(height: 15),
//                       Padding(
//                         padding: const EdgeInsets.only(left: 20, right: 20),
//                         child: CustomInputField(
//                           controller: editTaskVM.supervisorController.value,
//                           fieldType: 'number',
//                           hintText: "Supervisor & their contact",
//                           requiredField: true,
//                           validator: (value) {
//                             if (value!.isEmpty) {
//                               return 'Name is required';
//                             }
//                             return 'Name is Required';
//                           },
//                         ),
//                       ),
//                       SizedBox(height: 15),
//                       Padding(
//                         padding: const EdgeInsets.only(left: 20, right: 20),
//                         child: CustomInputField(
//                           controller: editTaskVM.workingHoursController.value,
//                           fieldType: 'number',
//                           hintText: "Working Hours",
//                           requiredField: true,
//                           validator: (value) {
//                             if (value!.isEmpty) {
//                               return 'Name is required';
//                             }
//                             return 'Name is Required';
//                           },
//                         ),
//                       ),
//                       SizedBox(height: 15),
//                       Padding(
//                         padding: const EdgeInsets.only(left: 20, right: 20),
//                         child: CustomInputField(
//                           controller: editTaskVM.wagesController.value,
//                           fieldType: 'number',
//                           hintText: "Wages",
//                           requiredField: true,
//                           validator: (value) {
//                             if (value!.isEmpty) {
//                               return 'Name is required';
//                             }
//                             return 'Name is Required';
//                           },
//                         ),
//                       ),
//                       SizedBox(height: 15),
//                       Padding(
//                         padding: const EdgeInsets.only(left: 20, right: 20),
//                         child: CustomInputField(
//                           controller: editTaskVM.straightTimeController.value,
//                           fieldType: 'number',
//                           hintText: "Straight time",
//                           requiredField: true,
//                           validator: (value) {
//                             if (value!.isEmpty) {
//                               return 'Name is required';
//                             }
//                             return 'Name is Required';
//                           },
//                         ),
//                       ),
//                       SizedBox(height: 15),
//                       Padding(
//                         padding: const EdgeInsets.only(left: 20, right: 20),
//                         child: CustomInputField(
//                           controller: editTaskVM.notesController.value,
//                           fieldType: 'number',
//                           hintText: "Notes",
//                           requiredField: true,
//                           validator: (value) {
//                             if (value!.isEmpty) {
//                               return 'Name is required';
//                             }
//                             return 'Name is Required';
//                           },
//                         ),
//                       ),
//                       SizedBox(height: 15),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
//               child: Obx(
//                 () => RoundButton(
//                   width: double.infinity,
//                   height: 50,
//                   title: 'Add Task',
//                   loading: editTaskVM.loading.value,
//                   buttonColor: AppColor.primeColor,
//                   onPress: () {
//                     Get.toNamed(RoutesName.taskScreen);
//                     if (_formKey.currentState!.validate()) {
//                       editTaskVM.editTaskApi();
//                     }
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
class EditTaskScreen extends StatefulWidget {
  const EditTaskScreen({super.key});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final editTaskVM = Get.put(EditTaskViewModel());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBodyBG,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 15),
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildTaskName(),
                      const SizedBox(height: 15),
                      _buildIncome(),
                      const SizedBox(height: 15),
                      _buildLocation(),
                      const SizedBox(height: 15),
                      _buildSupervisor(),
                      const SizedBox(height: 15),
                      _buildWorkingHours(),
                      const SizedBox(height: 15),
                      _buildWages(),
                      const SizedBox(height: 15),
                      _buildStraightTime(),
                      const SizedBox(height: 15),
                      _buildNotes(),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
            ),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  /// ---------------- Widgets ----------------

  Widget _buildHeader(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 10, top: 10),
          child: Align(
            alignment: Alignment.centerLeft,
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.arrow_back, color: AppColor.primeColor),
            ),
          ),
        ),
        const Positioned(
          top: 10,
          right: 35,
          left: 35,
          child: Text(
            'Edit Task',
            style: TextStyle(
              fontSize: 18,
              color: AppColor.secondColor,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildTaskName() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: CustomInputField(
        controller: editTaskVM.employerController.value,
        fieldType: 'text',
        hintText: "Task Name",
        requiredField: true,
        validator: (value) =>
            (value == null || value.isEmpty) ? 'Task name is required' : null,
      ),
    );
  }

  Widget _buildIncome() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: CustomInputField(
        controller: editTaskVM.jobTypeController.value,
        fieldType: 'number',
        hintText: "Income",
        requiredField: true,
        validator: (value) =>
            (value == null || value.isEmpty) ? 'Income is required' : null,
      ),
    );
  }

  Widget _buildLocation() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: CustomInputField(
        controller: editTaskVM.locationController.value,
        fieldType: 'text',
        hintText: "Location",
        requiredField: true,
        validator: (value) =>
            (value == null || value.isEmpty) ? 'Location is required' : null,
      ),
    );
  }

  Widget _buildSupervisor() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: CustomInputField(
        controller: editTaskVM.supervisorController.value,
        fieldType: 'text',
        hintText: "Supervisor & their contact",
        requiredField: true,
        validator: (value) => (value == null || value.isEmpty)
            ? 'Supervisor contact is required'
            : null,
      ),
    );
  }

  Widget _buildWorkingHours() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: CustomInputField(
        controller: editTaskVM.workingHoursController.value,
        fieldType: 'number',
        hintText: "Working Hours",
        requiredField: true,
        validator: (value) => (value == null || value.isEmpty)
            ? 'Working hours are required'
            : null,
      ),
    );
  }

  Widget _buildWages() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: CustomInputField(
        controller: editTaskVM.wagesController.value,
        fieldType: 'number',
        hintText: "Wages",
        requiredField: true,
        validator: (value) =>
            (value == null || value.isEmpty) ? 'Wages are required' : null,
      ),
    );
  }

  Widget _buildStraightTime() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: CustomInputField(
        controller: editTaskVM.straightTimeController.value,
        fieldType: 'number',
        hintText: "Straight Time",
        requiredField: true,
        validator: (value) => (value == null || value.isEmpty)
            ? 'Straight time is required'
            : null,
      ),
    );
  }

  Widget _buildNotes() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: CustomInputField(
        controller: editTaskVM.notesController.value,
        fieldType: 'text',
        hintText: "Notes",
        requiredField: true,
        validator: (value) =>
            (value == null || value.isEmpty) ? 'Notes are required' : null,
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
      child: Obx(
        () => RoundButton(
          width: double.infinity,
          height: 50,
          title: 'Save Changes',
          loading: editTaskVM.loading.value,
          buttonColor: AppColor.primeColor,
          onPress: () {
            if (_formKey.currentState!.validate()) {
              editTaskVM.editTaskApi();
              Get.toNamed(RoutesName.taskScreen);
            }
          },
        ),
      ),
    );
  }
}
