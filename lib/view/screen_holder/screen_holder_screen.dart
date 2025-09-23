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
import 'package:gig/view_models/controller/home/home_view_model.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ScreenHolderScreen extends StatefulWidget {
  const ScreenHolderScreen({super.key});

  @override
  _ScreenHolderScreenState createState() => _ScreenHolderScreenState();
}

class _ScreenHolderScreenState extends State<ScreenHolderScreen> {
  final LogoutnVM = Get.put(LogoutViewModel());
  final homeVM = Get.put(HomeViewModel());
  final List<Widget> _screens = [
    HomeScreen(),
    TaskScreen(),

    IncomeTracker(),
    UserProfileScreen(),
    Container(),
  ];
  @override
  Widget build(BuildContext context) {
    final bool isPortrait = Responsive.isPortrait(context);
    final bool isTablet = Responsive.isTablet(context);

    return Scaffold(
      backgroundColor: AppColor.appBodyBG,

      // ✅ BODY: show override screen if set, otherwise show tab screen
      body: Obx(() {
        if (homeVM.overrideScreen.value != null) {
          return homeVM.overrideScreen.value!;
        }
        return _screens[homeVM.selectedIndex.value];
      }),

      // ✅ BOTTOM NAVIGATION - Hide when override screen is active
      bottomNavigationBar: isPortrait
          ? Obx(
              () => homeVM.overrideScreen.value == null
                  ? BottomNavigationBar(
                      currentIndex: homeVM.selectedIndex.value,
                      onTap: homeVM.changeTab,
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
                          label: "Tasks",
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
                  : const SizedBox.shrink(), // Hide bottom navigation when override screen is active
            )
          : null,

      drawer: isPortrait ? _buildDrawer(context) : null,
      endDrawer: !isPortrait && isTablet ? _buildDrawer(context) : null,
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
    // Always return white background for screen holder
    return Colors.white;
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
          color: AppColor.primeColor, // Dark text for white background
          fontSize: radius * 0.6, // Scale font size with radius
          fontWeight: FontWeight.bold,
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
            decoration: BoxDecoration(color: AppColor.whiteColor),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(
                  () => _buildTextAvatar(
                    homeController.userName.value,
                    isTablet
                        ? Responsive.width(5, context)
                        : Responsive.width(6, context),
                  ),
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
            Navigator.pop(context);
            Get.toNamed(route);
          },
    );
  }
}
