import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gig/res/colors/app_color.dart';
import 'package:gig/res/routes/routes_name.dart';
import 'package:gig/utils/responsive.dart';
import 'package:gig/view/screen_holder/screens/home_screen.dart';
import 'package:gig/view/screen_holder/screens/income_tracker/income_tracker_screen.dart';
import 'package:gig/view/screen_holder/screens/notification/notification.dart';
import 'package:gig/view/screen_holder/screens/task/task_screen.dart';
import 'package:gig/view/screen_holder/screens/user_profile/user_profile_screen.dart';
import 'package:gig/view_models/controller/auth/logout_view_model.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ScreenHolderScreen extends StatefulWidget {
  const ScreenHolderScreen({super.key});

  @override
  _ScreenHolderScreenState createState() => _ScreenHolderScreenState();
}

class _ScreenHolderScreenState extends State<ScreenHolderScreen> {
  int _selectedIndex = 0;
  final LogoutnVM = Get.put(LogoutViewModel());
  final List<Widget> _screens = [
    HomeScreen(),

    NotificationScreen(),
    IncomeTracker(),
    UserProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isPortrait = Responsive.isPortrait(context);
    final bool isTablet = Responsive.isTablet(context);

    return Scaffold(
      backgroundColor: AppColor.appBodyBG,

      body: _screens[_selectedIndex],

      bottomNavigationBar: isPortrait
          ? BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              selectedItemColor: AppColor.secondColor,
              unselectedItemColor: Colors.grey,
              type: BottomNavigationBarType.fixed,
              selectedFontSize: Responsive.fontSize(12, context),
              unselectedFontSize: Responsive.fontSize(12, context),
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                    size: Responsive.fontSize(24, context),
                  ),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.task,
                    size: Responsive.fontSize(24, context),
                  ),
                  label: "Task",
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.notifications,
                    size: Responsive.fontSize(24, context),
                  ),
                  label: "Notification",
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.monetization_on,
                    size: Responsive.fontSize(24, context),
                  ),
                  label: "Income",
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person,
                    size: Responsive.fontSize(24, context),
                  ),
                  label: "User",
                ),
              ],
            )
          : null,
      drawer: isPortrait ? _buildDrawer(context) : null,
      // For landscape mode on tablets/desktops
      endDrawer: !isPortrait && isTablet ? _buildDrawer(context) : null,
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final bool isTablet = Responsive.isTablet(context);

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
                Text(
                  "John Doe",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Responsive.fontSize(18, context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "johndoe@gmail.com",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Responsive.fontSize(14, context),
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
            text: "logout",
            route: RoutesName.employerScreen,
            onTap: () {
              LogoutnVM.logoutApi();
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
            Get.toNamed(route);
          },
    );
  }
}
