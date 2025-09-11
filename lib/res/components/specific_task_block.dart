import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/state_manager.dart';
import 'package:gig/res/components/bottom_sheet.dart';
import 'package:gig/view_models/controller/task/delete_tast_view_model.dart';
import 'package:gig/view_models/controller/task/get_task_view_model.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class TaskSpecficBlock extends StatelessWidget {
  int? id;
  final String title;
  final String startDate;
  final String endDate;
  final String profileImage;

  final String? employer; // Add employer field

  final int totalTasks;
  final int count;
  final String status;

  TaskSpecficBlock({
    super.key,
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
  Widget build(BuildContext context) {
    final deleteTaskVM = Get.put(DeleteTaskViewModel());
    final GetTaskViewModel taskViewModel = Get.put(GetTaskViewModel());

    return InkWell(
     onTap: (){
      
     },
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
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(profileImage),
                ),
              ],
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
                Text(startDate, style: TextStyle(color: Colors.grey.shade400)),
                const SizedBox(width: 12),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Colors.grey.shade500,
                ),
                const SizedBox(width: 12),
                Icon(Icons.access_time, color: Colors.amber, size: 16),
                const SizedBox(width: 6),
                Text(endDate, style: const TextStyle(color: Colors.amber)),
              ],
            ),
            const SizedBox(height: 12),

            // Progress bar
            if (status != 'Completed')
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Row(
                  spacing: 20,
                  children: [
                    Icon(
                      LucideIcons.squarePen400,
                      color: Colors.green,
                      size: 20,
                    ),
                    Obx(
                      () => InkWell(
                        onTap: deleteTaskVM.loading.value
                            ? null
                            : () {
                                customBottomSheet(
                                  context,
                                  title: 'Are you sure you want to delete?',
                                  btnText1: 'Yes, Delete',
                                  btnText2: 'Cancel',
                                  onFirstTap: () async {
                                    await deleteTaskVM.deleteTask(id ?? 0);

                                    // The DeleteTaskViewModel will handle the refresh automatically
                                    print('Deleted!');
                                  },
                                  onSecondTap: () {
                                    print('Cancelled!');
                                  },
                                );
                              },
                        child: deleteTaskVM.loading.value
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
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
