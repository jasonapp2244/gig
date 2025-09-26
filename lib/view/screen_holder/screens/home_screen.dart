import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gig/res/colors/app_color.dart';
import 'package:gig/res/fonts/app_fonts.dart';
import 'package:gig/res/routes/routes_name.dart';
import 'package:gig/utils/responsive.dart';
import 'package:gig/utils/utils.dart';
import 'package:gig/view/screen_holder/screens/task/add_task_screen.dart';
import 'package:gig/view_models/controller/auth/logout_view_model.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../view_models/controller/home/home_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  bool _isDialogOpen = false;
  bool _isLoadingTasks = false;

  /// Refresh calendar and maintain current selection
  Future<void> _refreshCalendarState([DateTime? maintainSelectedDate]) async {
    if (!mounted) return;

    final HomeViewModel homeController = Get.find<HomeViewModel>();
    await homeController.silentRefreshTasksForCalendar();

    if (mounted) {
      setState(() {
        if (maintainSelectedDate != null) {
          _selectedDay = maintainSelectedDate;
          _focusedDay = maintainSelectedDate;
        }
        // Force calendar rebuild to show updated markers
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Refresh calendar data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final HomeViewModel homeController = Get.find<HomeViewModel>();
      // Force initial calendar refresh
      homeController.silentRefreshTasksForCalendar();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh calendar data when screen becomes visible
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // Use the new refresh method to maintain selected state
        _refreshCalendarState(_selectedDay);
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
                    Obx(
                      () => _buildTextAvatar(
                        homeController.userName.value,
                        Responsive.isTablet(context)
                            ? Responsive.width(4, context)
                            : Responsive.width(5, context),
                      ),
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

              return TableCalendar<Map<String, dynamic>>(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                calendarFormat: _calendarFormat,
                onFormatChanged: (format) {
                  if (mounted) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                daysOfWeekVisible: true,
                onDaySelected: (selectedDay, focusedDay) {
                  if (mounted) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                    _handleDateSelection(selectedDay, homeController);
                  }
                },
                onPageChanged: (focusedDay) {
                  if (mounted) {
                    setState(() {
                      _focusedDay = focusedDay;
                    });
                  }
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

  /// Handle date selection - always fetch from tasks-by-date API and show appropriate response
  void _handleDateSelection(
    DateTime selectedDate,
    HomeViewModel homeController,
  ) async {
    // Prevent multiple concurrent requests or dialog openings
    if (_isLoadingTasks || _isDialogOpen) {
      print('🚫 Already loading tasks or dialog is open, ignoring tap');
      return;
    }

    print('📅 Calendar date clicked: $selectedDate');
    _isLoadingTasks = true;

    // Format the date for API call verification
    String formattedDate =
        "${selectedDate.year.toString().padLeft(4, '0')}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
    print('📅 Formatted date for API: $formattedDate');

    String? token = await Utils.readSecureData('auth_token');

    if (token == null || token.isEmpty) {
      _isLoadingTasks = false;
      if (mounted) {
        Utils.snakBar('Error', 'No authentication token found');
      }
      return;
    }

    try {
      await homeController.fetchTasksByDate(selectedDate, token);

      // Check if widget is still mounted before proceeding
      if (!mounted) {
        _isLoadingTasks = false;
        return;
      }

      // Check if API returned any tasks
      if (homeController.tasksBySpecificDate.isNotEmpty) {
        // Show dialog with tasks from API
        _showTasksByDateDialog(selectedDate, homeController);
      } else {
        // No tasks found from API - go directly to AddTaskScreen
        print('🔍 No tasks found from API, navigating to AddTaskScreen...');
        homeController.openScreen(AddTaskScreen(selectedDate: selectedDate));

        // Keep the selected date marked and refresh calendar
        await _refreshCalendarState(selectedDate);
      }
    } catch (e) {
      print('❌ Error in _handleDateSelection: $e');
      if (mounted) {
        Utils.snakBar('Error', 'Failed to fetch tasks for selected date');
      }
    } finally {
      _isLoadingTasks = false;
    }
  }

  /// Show dialog with tasks fetched from API for selected date (as cards)
  void _showTasksByDateDialog(
    DateTime selectedDate,
    HomeViewModel homeController,
  ) {
    if (_isDialogOpen) {
      print('🚫 Dialog is already open, ignoring request');
      return;
    }

    _isDialogOpen = true;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColor.appBodyBG,
          title: Text(
            'Tasks for ${homeController.formatDisplayDate(selectedDate)}',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Container(
            width: double.maxFinite,
            height: MediaQuery.of(context).size.height * 0.6, // Fixed height
            child: Column(
              children: [
                // Loading indicator
                Obx(() {
                  if (homeController.tasksByDateLoading.value) {
                    return Container(
                      height: 100,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColor.primeColor,
                        ),
                      ),
                    );
                  }
                  return SizedBox.shrink();
                }),

                // Task list as cards
                Expanded(
                  child: Obx(() {
                    print(
                      '🔍 Dialog: tasksBySpecificDate length: ${homeController.tasksBySpecificDate.length}',
                    );
                    print(
                      '🔍 Dialog: tasksBySpecificDate data: ${homeController.tasksBySpecificDate}',
                    );

                    if (homeController.tasksBySpecificDate.isEmpty) {
                      return Center(
                        child: Text(
                          'No tasks found for this date',
                          style: TextStyle(color: Colors.white70),
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: homeController.tasksBySpecificDate.length,
                      itemBuilder: (context, index) {
                        final task = homeController.tasksBySpecificDate[index];
                        print(
                          '🔍 Dialog: Building card for task: ${task['job_title']}',
                        );
                        return _buildTaskCard(task, homeController);
                      },
                    );
                  }),
                ),

                SizedBox(height: 20),
                // Add new task button
                ElevatedButton.icon(
                  onPressed: () async {
                    _isDialogOpen = false;
                    Navigator.pop(context);
                    final homeVM = Get.find<HomeViewModel>();
                    homeVM.openScreen(
                      AddTaskScreen(selectedDate: selectedDate),
                    );

                    // Keep the selected date marked and refresh calendar
                    await _refreshCalendarState(selectedDate);
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
          actions: [
            TextButton(
              onPressed: () {
                _isDialogOpen = false;
                Navigator.pop(context);
              },
              child: Text(
                'Close',
                style: TextStyle(color: AppColor.primeColor),
              ),
            ),
          ],
        );
      },
    ).then((_) {
      // Reset dialog flag when dialog is dismissed (including back button/barrier tap)
      _isDialogOpen = false;
    });
  }

  Widget _buildTaskCard(
    Map<String, dynamic> task,
    HomeViewModel homeController,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Job Title (Header)
          Text(
            task['job_title'] ?? 'Untitled Task',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColor.primeColor,
            ),
          ),
          SizedBox(height: 12),

          // Employer Information
          _buildTaskDetailRow(
            'Employer ID:',
            task['employer_id']?.toString() ?? 'N/A',
            Icons.business,
          ),
          _buildTaskDetailRow(
            'Employer:',
            task['employer'] ?? 'N/A',
            Icons.apartment,
          ),

          // Job Details
          _buildTaskDetailRow(
            'Job Type:',
            task['job_type'] ?? 'N/A',
            Icons.work,
          ),
          _buildTaskDetailRow(
            'Job Category:',
            task['job_category'] ?? 'N/A',
            Icons.category,
          ),

          // Location
          _buildTaskDetailRow(
            'Location:',
            task['location'] ?? 'N/A',
            Icons.location_on,
          ),

          // Contact Information
          _buildTaskDetailRow(
            'Supervisor Contact:',
            task['supervisor_contact_number'] ?? 'N/A',
            Icons.phone,
          ),
        ],
      ),
    );
  }

  // Helper method to build consistent detail rows
  Widget _buildTaskDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.black87, fontSize: 14),
                children: [
                  TextSpan(
                    text: '$label ',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(
                    text: value,
                    style: TextStyle(fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Format task date for display
  String _formatTaskDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return 'N/A';
    }
  }

  /// Map task status for display
  String _mapTaskStatus(String? status, bool? hasEntry) {
    if (hasEntry == true) return 'Completed';
    if (status == 'ongoing') return 'Ongoing';
    return status ?? 'Unknown';
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
            icon: LucideIcons.headset,
            text: "Support",
            route: RoutesName.support_view,
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

  /// Build a text avatar with user initials
  Widget _buildTextAvatar(String name, double radius) {
    // Generate initials from name
    String initials = _getInitials(name);

    // Generate a consistent color based on name
    Color avatarColor = _getAvatarColor(name);

    return CircleAvatar(
      radius: radius,
      backgroundColor: avatarColor,
      child: Text(
        initials,
        style: TextStyle(
          color: Colors.black,
          fontSize: radius * 0.6, // Scale font size with radius
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Extract initials from name
  String _getInitials(String name) {
    if (name.isEmpty) return 'U';

    List<String> words = name.trim().split(' ');
    if (words.length == 1) {
      // Single word - take first two characters
      return words[0].substring(0, words[0].length > 2 ? 2 : 1).toUpperCase();
    } else {
      // Multiple words - take first character of first two words
      String first = words[0].isNotEmpty ? words[0][0] : '';
      String second = words.length > 1 && words[1].isNotEmpty
          ? words[1][0]
          : '';
      return (first + second).toUpperCase();
    }
  }

  /// Generate a consistent color for the avatar based on name
  Color _getAvatarColor(String name) {
    if (name.isEmpty) return AppColor.primeColor;

    // Use name hash to generate consistent color
    int hash = name.hashCode;
    List<Color> colors = [AppColor.whiteColor];

    return colors[hash.abs() % colors.length];
  }
}
