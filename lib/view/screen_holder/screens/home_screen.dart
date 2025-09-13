import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gig/res/fonts/app_fonts.dart';
import 'package:gig/res/routes/routes_name.dart';
import 'package:gig/utils/responsive.dart';
import 'package:gig/view/screen_holder/screens/task/add_task_screen.dart';
import 'package:gig/view_models/controller/auth/logout_view_model.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../view_models/controller/home/home_view_model.dart';

import '../../../res/colors/app_color.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    // Refresh calendar data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final HomeViewModel homeController = Get.find<HomeViewModel>();
      homeController.silentRefreshTasksForCalendar();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh calendar data when screen becomes visible
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final HomeViewModel homeController = Get.find<HomeViewModel>();
        homeController.silentRefreshTasksForCalendar();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final HomeViewModel homeController = Get.put(HomeViewModel());

    return Scaffold(
      backgroundColor: Colors.transparent,
      drawer: _buildDrawer(context),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          Responsive.isPortrait(context)
              ? Responsive.height(22, context)
              : Responsive.height(28, context),
        ),
        child: Container(
          padding: EdgeInsets.only(
            top:
                MediaQuery.of(context).padding.top +
                (Responsive.isTablet(context) ? 20 : 10),
            left: Responsive.width(2, context),
            right: Responsive.width(2, context),
            bottom: Responsive.height(1, context),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(Responsive.width(3, context)),
              bottomRight: Radius.circular(Responsive.width(3, context)),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 5, top: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Welcome Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize:
                          MainAxisSize.min, // Prevent inner column overflow
                      children: [
                        Text(
                          "Welcome",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Responsive.fontSize(14, context),
                          ),
                        ),
                        Obx(
                          () => Text(
                            homeController.userName.value,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Responsive.fontSize(18, context),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/images/user.png'),
                      radius: Responsive.isTablet(context)
                          ? Responsive.width(4, context)
                          : Responsive.width(5, context),
                    ),
                  ],
                ),
                SizedBox(height: Responsive.height(1, context)),
                // Search Row
                Row(
                  children: [
                    Expanded(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: Responsive.height(
                            5,
                            context,
                          ), // Limit height
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Search...",
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: Responsive.height(0.5, context),
                              horizontal: Responsive.width(4, context),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                Responsive.width(8, context),
                              ),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              size: Responsive.fontSize(20, context),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (!Responsive.isTablet(context))
                      SizedBox(width: Responsive.width(2, context)),
                    if (!Responsive.isTablet(context))
                      Builder(
                        builder: (context) => Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.menu,
                              size: Responsive.fontSize(20, context),
                              color: Colors.black,
                            ),
                            onPressed: () => Scaffold.of(context).openDrawer(),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          spacing: 15,
          children: [
            SizedBox(height: 20),

            // Calendar with task indicators
            Obx(() {
              if (homeController.tasksLoading.value) {
                return Container(
                  height: 400,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColor.primeColor,
                    ),
                  ),
                );
              }

              return TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                calendarFormat: _calendarFormat,
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                daysOfWeekVisible: true,
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                  _handleDateSelection(selectedDay, homeController);
                },
                // Add event loader to show task indicators
                eventLoader: (day) {
                  return homeController.getEventsForDate(day);
                },
                // Custom calendar builder to show task count
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, date, events) {
                    if (events.isNotEmpty) {
                      if (events.length == 1) {
                        // Show only a dot for 1 task
                        return Positioned(
                          bottom: 1,
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: AppColor.primeColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        );
                      } else {
                        // Show number for 2+ tasks
                        return Positioned(
                          bottom: 1,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColor.primeColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${events.length}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }
                    }
                    return null;
                  },
                ),
                calendarStyle: CalendarStyle(
                  todayDecoration: const BoxDecoration(
                    color: AppColor.primeColor,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    border: Border.all(color: AppColor.primeColor, width: 2),
                    color: const Color(0xFF2D2F3A),
                    shape: BoxShape.circle,
                  ),
                  defaultTextStyle: const TextStyle(color: Colors.white),
                  weekendTextStyle: const TextStyle(color: Colors.white),
                  outsideDaysVisible: false,
                  // Remove default markers since we're using custom builder
                  markerDecoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  markerSize: 0,
                  markerMargin: EdgeInsets.zero,
                ),
                headerStyle: const HeaderStyle(
                  titleCentered: true,
                  formatButtonVisible: false,
                  titleTextStyle: TextStyle(color: Colors.white),
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: Colors.white,
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                  ),
                ),
                daysOfWeekStyle: const DaysOfWeekStyle(
                  weekdayStyle: TextStyle(color: Colors.white70),
                  weekendStyle: TextStyle(color: Colors.white70),
                ),
              );
            }),

            SizedBox(height: 10),

            InkWell(
              onTap: () {
                final homeVM = Get.find<HomeViewModel>();
                Get.toNamed(RoutesName.addTaskScreen);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                decoration: BoxDecoration(
                  color: AppColor.inputBGColor100,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1, color: Colors.white38),
                ),
                child: Row(
                  spacing: 10,
                  children: [
                    Icon(
                      LucideIcons.history400,
                      color: AppColor.textColor,
                      size: 25,
                    ),
                    Text(
                      'work history',
                      style: TextStyle(
                        color: AppColor.textColor,
                        fontFamily: AppFonts.appFont,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Get.toNamed(RoutesName.incomeTracker);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                decoration: BoxDecoration(
                  color: AppColor.inputBGColor100,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1, color: Colors.white38),
                ),
                child: Row(
                  spacing: 10,
                  children: [
                    Icon(
                      LucideIcons.handCoins400,
                      color: AppColor.textColor,
                      size: 25,
                    ),
                    Text(
                      'Track Income',
                      style: TextStyle(
                        color: AppColor.textColor,
                        fontFamily: AppFonts.appFont,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Get.toNamed(RoutesName.detailScreenView);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                decoration: BoxDecoration(
                  color: AppColor.inputBGColor100,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1, color: Colors.white38),
                ),
                child: Row(
                  spacing: 10,
                  children: [
                    Icon(
                      LucideIcons.store400,
                      color: AppColor.textColor,
                      size: 25,
                    ),
                    Text(
                      'Marketplace',
                      style: TextStyle(
                        color: AppColor.textColor,
                        fontFamily: AppFonts.appFont,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Handle date selection - show existing tasks or go to add task
  void _handleDateSelection(
    DateTime selectedDate,
    HomeViewModel homeController,
  ) {
    
    List<Map<String, dynamic>> tasksForDate = homeController.getTasksForDate(
      selectedDate,
    );

    if (tasksForDate.isNotEmpty) {
      // Show existing tasks for this date
      print(
        '📅 HomeScreen - Found ${tasksForDate.length} existing tasks for this date',
      );
      _showTasksForDateDialog(selectedDate, tasksForDate, homeController);
    } else {
      // No tasks for this date, go to add task screen
      print(
        '📅 HomeScreen - No existing tasks, navigating to AddTaskScreen with date: $selectedDate',
      );
      print(
        '📅 HomeScreen - Arguments being passed: ${{'selectedDate': selectedDate}}',
      );
      final homeVM = Get.find<HomeViewModel>();
      homeVM.openScreen(AddTaskScreen(selectedDate: selectedDate));
    }
  }

  /// Show dialog with tasks for selected date
  void _showTasksForDateDialog(
    DateTime selectedDate,
    List<Map<String, dynamic>> tasks,
    HomeViewModel homeController,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColor.appBodyBG,
          title: Text(
            'Tasks for ${homeController.formatTaskDate(selectedDate.toString())}',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Container(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Task list
                  ...tasks
                      .map((task) => _buildTaskItem(task, homeController))
                      .toList(),
                  SizedBox(height: 20),
                  // Add new task button
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      final homeVM = Get.find<HomeViewModel>();
                      homeVM.openScreen(
                        AddTaskScreen(selectedDate: selectedDate),
                      );
                    },
                    icon: Icon(Icons.add, color: Colors.white),
                    label: Text('Add New Task'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primeColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Close',
                style: TextStyle(color: AppColor.primeColor),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Build individual task item for dialog
  Widget _buildTaskItem(
    Map<String, dynamic> task,
    HomeViewModel homeController,
  ) {
    String status = homeController.mapTaskStatus(
      task['status'],
      task['has_entry'],
    );
    Color statusColor = status == 'Completed'
        ? Colors.green
        : AppColor.primeColor;

    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColor.inputBGColor100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  task['job_title'] ?? 'Untitled Task',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          if (task['location'] != null &&
              task['location'].toString().isNotEmpty)
            Text(
              '📍 ${task['location']}',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          if (task['employer'] != null &&
              task['employer'].toString().isNotEmpty)
            Text(
              '👤 ${task['employer']}',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final bool isTablet = Responsive.isTablet(context);
    final HomeViewModel homeController = Get.find<HomeViewModel>();
    final LogoutViewModel logoutController = Get.find<LogoutViewModel>();
    return Drawer(
      width: isTablet ? Responsive.width(40, context) : null,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: AppColor.primeColor),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/images/user.png'),
                  radius: isTablet
                      ? Responsive.width(5, context)
                      : Responsive.width(6, context),
                ),
                SizedBox(height: Responsive.height(1, context)),
                Obx(
                  () => Text(
                    homeController.userName.value,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Responsive.fontSize(18, context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Obx(
                  () => Text(
                    homeController.userEmail.value,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Responsive.fontSize(14, context),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.post_add,
            text: "Create Adds",
            route: RoutesName.createAddsScreen,
          ),
          _buildDrawerItem(
            context,
            icon: Icons.account_circle_outlined,
            text: "Profile",
            route: RoutesName.userProfileScreen,
          ),
          _buildDrawerItem(
            context,
            icon: LucideIcons.bellDot,
            text: "Notification",
            route: RoutesName.notificationScreen,
          ),
          _buildDrawerItem(
            context,
            icon: LucideIcons.building400,
            text: "Employer",
            route: RoutesName.employerScreen,
          ),
          _buildDrawerItem(
            context,
            icon: LucideIcons.building400,
            text: "Reset Password",
            route: RoutesName.resetPassword,
          ),

          _buildDrawerItem(
            context,
            icon: Icons.logout,
            text: "Logout",
            route: "",
            onTap: () async {
              logoutController.logout(); // Call logout API
              await Navigator.pushNamed(context, RoutesName.loginScreen);

              // Show confirmation dialog
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String text,
    required String route,
    void Function()? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, size: Responsive.fontSize(20, context)),
      title: Text(
        text,
        style: TextStyle(fontSize: Responsive.fontSize(16, context)),
      ),
      onTap:
          onTap ??
          () {
            Navigator.pop(context); // Close the drawer
            if (route.isNotEmpty) {
              Get.toNamed(route);
            }
          },
    );
  }
}
