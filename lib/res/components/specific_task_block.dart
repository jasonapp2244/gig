import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gig/res/components/bottom_sheet.dart';
import 'package:gig/view/screen_holder/screen_holder_screen.dart';
import 'package:gig/view/screen_holder/screens/task/edit_task_screen.dart';
import 'package:gig/view_models/controller/task/delete_tast_view_model.dart';
import 'package:gig/view_models/controller/task/edit_task_view_model.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class TaskSpecficBlock extends StatefulWidget {
  int? id;
  final String title;
  final String startDate;
  final String endDate;
  final String profileImage;
  final String? employer; // Add employer field
  String employeerId;

  final int totalTasks;
  final int count;
  final String status;

  TaskSpecficBlock({
    super.key,
    required this.employeerId,
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.profileImage,

    this.employer,

    required this.totalTasks,
    required this.status,
    required this.count,
  });

  @override
  State<TaskSpecficBlock> createState() => _TaskSpecficBlockState();
}

class _TaskSpecficBlockState extends State<TaskSpecficBlock> {
  var taskData;

  @override
  Widget build(BuildContext context) {
    final deleteTaskVM = Get.put(DeleteTaskViewModel());
    // final GetTaskViewModel taskViewModel = Get.put(GetTaskViewModel());

    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF141C2F),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and profile image
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              widget.employer ?? '',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            // Dates row
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: Colors.grey.shade400,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(widget.startDate, style: TextStyle(color: Colors.grey.shade400)),
                const SizedBox(width: 12),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Colors.grey.shade500,
                ),
                const SizedBox(width: 12),
                Icon(Icons.access_time, color: Colors.amber, size: 16),
                const SizedBox(width: 6),
                Text(widget.endDate, style: const TextStyle(color: Colors.amber)),
              ],
            ),
            const SizedBox(height: 12),

            // Progress bar
            if (widget.status != 'Completed')
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Row(
                  spacing: 20,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final editTaskVM = Get.put(EditTaskViewModel());

                        // 1. Fetch details
                        taskData = await editTaskVM.getTasksDetails(
                          taskId: widget.id.toString(),
                        );

                        // 2. Set values into controllers
                        editTaskVM.employerController.value.text =
                            taskData['employer'];
                        editTaskVM.jobTypeController.value.text =
                            taskData['job_title'] ?? '';

                        editTaskVM.locationController.value.text =
                            taskData['location'] ?? '';
                        editTaskVM.supervisorController.value.text =
                            taskData['supervisor'] ?? '';
                        editTaskVM.workingHoursController.value.text =
                            taskData['working_hours']?.toString() ?? '';
                        editTaskVM.wagesController.value.text =
                            taskData['pay']?.toString() ?? '';
                        editTaskVM.straightTimeController.value.text =
                            taskData['working_hours']?.toString() ?? '';
                        editTaskVM.notesController.value.text =
                            taskData['notes'] ?? '';
                        editTaskVM.supervisorController.value.text =
                            taskData['supervisor_contact_number'] ?? '';

                        // 3. Navigate to EditTaskScreen
                        Get.to(() => const EditTaskScreen());
                      },
                      child: Icon(
                        LucideIcons.squarePen,
                        color: Colors.green,
                        size: 20,
                      ),
                    ),

                    Obx(() {
                      final isLoading = deleteTaskVM.loadingTasks.contains(widget.id);
                      return InkWell(
                        onTap: isLoading
                            ? null
                            : () {
                              customBottomSheet(
                                  context,
                                  title: 'Are you sure you want to delete?',
                                  btnText1: 'Yes, Delete',
                                  btnText2: 'Cancel',
                                  onFirstTap: () async {
                                    await deleteTaskVM.deleteTask(widget.id ?? 0);
                                    // Navigator.of(context).pop();
                                    Get.to(() => const ScreenHolderScreen());
                                    print('Deleted!');
                                  },
                                  onSecondTap: () {
                                    print('Cancelled!');
                                  },
                                );
                              },
                        child: isLoading
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.red,
                                ),
                              )
                            : Icon(
                                Icons.delete_outline_rounded,
                                color: Colors.red,
                              ),
                      );
                    }),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
