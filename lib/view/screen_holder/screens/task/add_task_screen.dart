import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gig/res/components/bottom_banner_ads.dart';
import 'package:gig/view_models/controller/task/get_task_view_model.dart';
import '../../../../res/colors/app_color.dart';
import '../../../../res/components/input.dart';
import '../../../../res/components/round_button.dart';
import '../../../../res/components/employer_dropdown.dart';
import '../../../../view_models/controller/task/add_task_view_model.dart';
import '../../../../view_models/controller/home/home_view_model.dart';
import '../../../../utils/utils.dart';

class AddTaskScreen extends StatefulWidget {
  final DateTime? selectedDate;

  const AddTaskScreen({super.key, this.selectedDate});

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

    // Use constructor parameter first, then fallback to Get.arguments
    DateTime? dateToUse;

    if (widget.selectedDate != null) {
      dateToUse = widget.selectedDate;
      print('🔍 AddTaskScreen - Using constructor selectedDate: $dateToUse');
      print(
        '🔍 AddTaskScreen - Constructor date components: ${widget.selectedDate!.year}-${widget.selectedDate!.month}-${widget.selectedDate!.day}',
      );
    } else {
      final args = Get.arguments;
      print('🔍 AddTaskScreen - Received arguments: $args');
      print('🔍 AddTaskScreen - Arguments type: ${args.runtimeType}');

      if (args != null && args['selectedDate'] != null) {
        dateToUse = args['selectedDate'];
        print(' AddTaskScreen - Using arguments selectedDate: $dateToUse');
      }
    }

    if (dateToUse != null) {
      addTaskVM.selectedDate = dateToUse;
      print(' AddTaskScreen - Selected date set: ${addTaskVM.selectedDate}');
      print(
        ' AddTaskScreen - Selected date type: ${addTaskVM.selectedDate.runtimeType}',
      );
      if (addTaskVM.selectedDate != null) {
        print(
          ' AddTaskScreen - Selected date components: ${addTaskVM.selectedDate!.year}-${addTaskVM.selectedDate!.month}-${addTaskVM.selectedDate!.day}',
        );
      }
    } else {
      print(' AddTaskScreen - No selected date provided, using current date');
      addTaskVM.selectedDate = DateTime.now();
      print('AddTaskScreen - Current date set: ${addTaskVM.selectedDate}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.appBodyBG,
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildHeader(context),
              const SizedBox(height: 15),
              if (addTaskVM.selectedDate != null) _buildSelectedDate(),
              const SizedBox(height: 15),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildTaskName(),
                      const SizedBox(height: 15),
                      _buildEmployerDropdown(),
                      const SizedBox(height: 15),
                      _buildLocation(),
                      const SizedBox(height: 15),
                      _buildPosition(),
                      const SizedBox(height: 15),
                      _buildTimeSelector(),
                      const SizedBox(height: 15),
                      _buildSupervisor(),
                      const SizedBox(height: 15),
                      _buildStraightTime(),
                      const SizedBox(height: 15),
                      _buildWages(),
                      const SizedBox(height: 15),
                      _buildNotes(),
                      const SizedBox(height: 15),
                      //const SizedBox(height: 15),
                      _buildSubmitButton(),
                    ],
                  ),
                ),
              ),BottomBannerAd(),
            ],
          ),
        ),
      ),
    );
  }

  /// ------------------- Widgets -------------------

  Widget _buildHeader(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 10, top: 10),
          child: Align(
            alignment: Alignment.centerLeft,
            child: InkWell(
              onTap: () {
                // Clear the override screen to go back to the main screen
                try {
                  final HomeViewModel homeController =
                      Get.find<HomeViewModel>();
                  homeController.overrideScreen.value = null;
                  Get.back();
                } catch (e) {
                  // Fallback to regular navigation if HomeViewModel not found
                  Navigator.pop(context);
                }
              },
              child: Icon(Icons.arrow_back, color: AppColor.primeColor),
            ),
          ),
        ),
        const Positioned(
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
    );
  }

  Widget _buildSelectedDate() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: AppColor.primeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColor.primeColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_today, color: AppColor.primeColor, size: 20),
          const SizedBox(width: 10),
          Text(
            'Selected Date: ${addTaskVM.selectedDate!.day}/${addTaskVM.selectedDate!.month}/${addTaskVM.selectedDate!.year}',
            style: TextStyle(
              color: AppColor.primeColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskName() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: CustomInputField(
        controller: addTaskVM.jobTypeController.value,
        fieldType: 'text',
        hintText: "Task Name",
        requiredField: true,
        validator: (value) =>
            (value == null || value.isEmpty) ? 'Task name is required' : null,
      ),
    );
  }

  Widget _buildEmployerDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => EmployerDropdown(
              controller: addTaskVM.employerController.value,
              employers: addTaskVM.employers,
              filteredEmployers: addTaskVM.filteredEmployers,
              onSearchChanged: addTaskVM.filterEmployers,
              onDeleteEmployer: addTaskVM.deleteEmployer,
              isLoading: addTaskVM.employerLoading.value,
            ),
          ),
          // Validation error message
          Obx(() {
            final employerText = addTaskVM.employerController.value.text.trim();
            if (employerText.isEmpty && addTaskVM.loading.value) {
              return const Padding(
                padding: EdgeInsets.only(top: 8, left: 12),
                child: Text(
                  'Employer is required',
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildLocation() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: CustomInputField(
        controller: addTaskVM.locationController.value,
        fieldType: 'text',
        hintText: "Location",
        requiredField: true,
        validator: (value) =>
            (value == null || value.isEmpty) ? 'Location is required' : null,
      ),
    );
  }

  Widget _buildPosition() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: CustomInputField(
        controller: addTaskVM.positionController.value,
        fieldType: 'text',
        hintText: "Position",
        requiredField: true,
        validator: (value) =>
            (value == null || value.isEmpty) ? 'Position is required' : null,
      ),
    );
  }

  Widget _buildSupervisor() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: CustomInputField(
        controller: addTaskVM.supervisorController.value,
        fieldType: 'number',
        hintText: "Supervisor & their contact",
        requiredField: true,
        validator: (value) => (value == null || value.isEmpty)
            ? 'Supervisor contact is required'
            : null,
      ),
    );
  }

  Widget _buildStraightTime() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: CustomInputField(
        controller: addTaskVM.straightTimeController.value,
        fieldType: 'number',
        hintText: "Straight/Overtime Hours",
        requiredField: true,
        validator: (value) => (value == null || value.isEmpty)
            ? 'Supervisor contact is required'
            : null,
      ),
    );
  }

  Widget _buildTimeSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white24, width: 1.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: GestureDetector(
          onTap: () => addTaskVM.selectTime(context),
          child: AbsorbPointer(
            child: Obx(
              () => CustomInputField(
                controller: addTaskVM.timeController.value,
                fieldType: 'text',
                hintText: "Select Time",
                requiredField: true,
                isEdit: false, // This makes it non-editable
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Time is required'
                    : null,
                prefixIcon: Icon(Icons.access_time, color: AppColor.primeColor),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWages() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: CustomInputField(
        controller: addTaskVM.wagesController.value,
        fieldType: 'number',
        hintText: "Wages",
        requiredField: true,
        validator: (value) =>
            (value == null || value.isEmpty) ? 'Wages is required' : null,
      ),
    );
  }

  Widget _buildNotes() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: CustomInputField(
        controller: addTaskVM.notesController.value,
        fieldType: 'text',
        hintText: "Notes",
        requiredField: true,
        validator: (value) =>
            (value == null || value.isEmpty) ? 'Notes is required' : null,
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
          title: 'Add Task',
          loading: addTaskVM.loading.value,
          buttonColor: AppColor.primeColor,
          onPress: () {
            // Additional validation for employer field
            final employerText = addTaskVM.employerController.value.text.trim();
            print('🔍 Submit button pressed - Employer text: "$employerText"');
            print(
              '🔍 Employer controller value: "${addTaskVM.employerController.value.text}"',
            );

            if (employerText.isEmpty) {
              Utils.snakBar('Error', 'Please select or enter an employer name');
              return;
            }

            if (_formKey.currentState!.validate()) {
              addTaskVM.addTaskApi();
              // Remove Get.back() - let the view model handle navigation after API response
            }
          },
        ),
      ),
    );
  }
}
