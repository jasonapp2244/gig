import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gig/res/fonts/app_fonts.dart';
import 'package:gig/res/routes/routes_name.dart';
import 'package:gig/utils/responsive.dart';
import 'package:gig/utils/utils.dart';
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
  Widget build(BuildContext context) {
    final HomeViewModel homeController = Get.put(HomeViewModel());

    return Scaffold(
      backgroundColor: Colors.transparent,
      drawer: _buildDrawer(context),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          Responsive.isPortrait(context)
              ? Responsive.height(18, context)
              : Responsive.height(24, context),
        ),
        child: Container(
          padding: EdgeInsets.only(
            top:
                MediaQuery.of(context).padding.top +
                (Responsive.isTablet(context) ? 20 : 10),
            left: Responsive.width(4, context),
            right: Responsive.width(4, context),
            bottom: Responsive.height(1, context),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(Responsive.width(3, context)),
              bottomRight: Radius.circular(Responsive.width(3, context)),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 10, top: 10),
            child: Column(
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
                            fontSize: Responsive.fontSize(16, context),
                          ),
                        ),
                        Obx(
                          () => Text(
                            homeController.userName.value,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Responsive.fontSize(22, context),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/images/user.png'),
                      radius: Responsive.isTablet(context)
                          ? Responsive.width(5, context)
                          : Responsive.width(6, context),
                    ),
                  ],
                ),
                SizedBox(height: Responsive.height(1.5, context)),
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
                              vertical: Responsive.height(1, context),
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

            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              calendarFormat: _calendarFormat, // required
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
                Get.toNamed(
                  RoutesName.addTaskScreen,
                  arguments: {'selectedDate': selectedDay},
                );
              },
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
              ),
              headerStyle: const HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
                titleTextStyle: TextStyle(color: Colors.white),
                leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
                rightChevronIcon: Icon(
                  Icons.chevron_right,
                  color: Colors.white,
                ),
              ),
              daysOfWeekStyle: const DaysOfWeekStyle(
                weekdayStyle: TextStyle(color: Colors.white70),
                weekendStyle: TextStyle(color: Colors.white70),
              ),
            ),

            SizedBox(height: 10),
            InkWell(
              onTap: () {
                Get.toNamed(RoutesName.taskScreen);
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
                Get.toNamed(RoutesName.marketPlaceScreen);
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

  Widget _buildDrawer(BuildContext context) {
    final bool isTablet = Responsive.isTablet(context);
    final HomeViewModel homeController = Get.find<HomeViewModel>();

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
            icon: Icons.notification_important,
            text: "Get FCM Token",
            route: "",
            onTap: () async {
              Navigator.pop(context); // Close drawer first
              // Get and print FCM token
              String? token = await Utils.getAndPrintFCMToken();
              if (token != null) {
                Utils.snakBar(
                  "FCM Token",
                  "Token retrieved and printed to console!",
                );
              } else {
                Utils.snakBar("Error", "Failed to get FCM token");
              }
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.storage,
            text: "Show Stored FCM Token",
            route: "",
            onTap: () async {
              Navigator.pop(context); // Close drawer first
              String? storedToken = await Utils.getStoredFCMToken();
              if (storedToken != null) {
                Utils.snakBar(
                  "Stored FCM Token",
                  "Check console for full token",
                );
              } else {
                Utils.snakBar("No Token", "No FCM token found in storage");
              }
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.logout,
            text: "Logout",
            route: "",
            onTap: () {
              Navigator.pop(context); // Close drawer first
              // Add logout functionality here
              Get.toNamed(RoutesName.loginScreen);
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
