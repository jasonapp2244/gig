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
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ScreenHolderScreen extends StatefulWidget {
  const ScreenHolderScreen({super.key});

  @override
  _ScreenHolderScreenState createState() => _ScreenHolderScreenState();
}

class _ScreenHolderScreenState extends State<ScreenHolderScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    TaskScreen(),
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

      // body: _screens[_selectedIndex],
      // appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(
      //     isPortrait
      //         ? Responsive.height(16, context)
      //         : Responsive.height(22, context),
      //   ),
      //   child: Container(
      //     padding: EdgeInsets.only(
      //       top: MediaQuery.of(context).padding.top + (isTablet ? 20 : 10),
      //       left: Responsive.width(4, context),
      //       right: Responsive.width(4, context),
      //       bottom: Responsive.height(1, context),
      //     ),
      //     decoration: BoxDecoration(
      //       borderRadius: BorderRadius.only(
      //         bottomLeft: Radius.circular(Responsive.width(3, context)),
      //         bottomRight: Radius.circular(Responsive.width(3, context)),
      //       ),
      //     ),
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //         Row(
      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //           children: [
      //             Column(
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: [
      //                 Text(
      //                   "Welcome",
      //                   style: TextStyle(
      //                     color: Colors.white,
      //                     fontSize: Responsive.fontSize(16, context),
      //                   ),
      //                 ),
      //                 Text(
      //                   "John Doe",
      //                   style: TextStyle(
      //                     color: Colors.white,
      //                     fontSize: Responsive.fontSize(22, context),
      //                     fontWeight: FontWeight.bold,
      //                   ),
      //                 ),
      //               ],
      //             ),
      //             CircleAvatar(
      //               backgroundImage: AssetImage('assets/images/user.png'),
      //               radius: isTablet
      //                   ? Responsive.width(5, context)
      //                   : Responsive.width(6, context),
      //             ),
      //           ],
      //         ),

      //         SizedBox(height: Responsive.height(1.5, context)),
      //         Row(
      //           children: [
      //             Expanded(
      //               child: TextField(
      //                 decoration: InputDecoration(
      //                   hintText: "Search...",
      //                   filled: true,
      //                   fillColor: Colors.white,
      //                   contentPadding: EdgeInsets.symmetric(
      //                     vertical: Responsive.height(1, context),
      //                     horizontal: Responsive.width(4, context),
      //                   ),
      //                   border: OutlineInputBorder(
      //                     borderRadius: BorderRadius.circular(
      //                       Responsive.width(8, context),
      //                     ),
      //                     borderSide: BorderSide.none,
      //                   ),
      //                   prefixIcon: Icon(
      //                     Icons.search,
      //                     size: Responsive.fontSize(20, context),
      //                   ),
      //                 ),
      //               ),
      //             ),
      //             if (!isTablet) SizedBox(width: Responsive.width(2, context)),
      //             if (!isTablet)
      //               Builder(
      //                 builder: (context) => Container(
      //                   decoration: BoxDecoration(
      //                     color: Colors.white,
      //                     shape: BoxShape.circle,
      //                   ),
      //                   child: IconButton(
      //                     icon: Icon(
      //                       Icons.menu,
      //                       size: Responsive.fontSize(20, context),
      //                       color: Colors.black,
      //                     ),
      //                     onPressed: () => Scaffold.of(context).openDrawer(),
      //                   ),
      //                 ),
      //               ),
      //           ],
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
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
          child: ListView(
            // mainAxisSize: MainAxisSize.min, // This prevents overflow
            // crossAxisAlignment: CrossAxisAlignment.start,
            shrinkWrap: true,
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
                      Text(
                        "John Doe",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Responsive.fontSize(22, context),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/images/user.png'),
                    radius: Responsive.isTablet(context)
                        ? Responsive.width(3, context)
                        : Responsive.width(4, context),
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
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String text,
    required String route,
  }) {
    return ListTile(
      leading: Icon(icon, size: Responsive.fontSize(20, context)),
      title: Text(
        text,
        style: TextStyle(fontSize: Responsive.fontSize(16, context)),
      ),
      onTap: () {
        Navigator.pop(context); // Close the drawer
        Get.toNamed(route);
      },
    );
  }
}

//------------static Ui

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:gig/res/colors/app_color.dart';
// import 'package:gig/res/routes/routes_name.dart';
// import 'package:gig/view/screen_holder/screens/home_screen.dart';
// import 'package:gig/view/screen_holder/screens/income_tracker/income_tracker_screen.dart';
// import 'package:gig/view/screen_holder/screens/notification/notification.dart';
// import 'package:gig/view/screen_holder/screens/task/task_screen.dart';
// import 'package:gig/view/screen_holder/screens/user_profile/user_profile_screen.dart';
// import 'package:lucide_icons_flutter/lucide_icons.dart';

// class ScreenHolderScreen extends StatefulWidget {
//   const ScreenHolderScreen({super.key});

//   @override
//   _ScreenHolderScreenState createState() => _ScreenHolderScreenState();
// }

// class _ScreenHolderScreenState extends State<ScreenHolderScreen> {
//   int _selectedIndex = 0;

//   final List<Widget> _screens = [
//     HomeScreen(),
//     TaskScreen(),
//     NotificationScreen(),
//     IncomeTracker(),
//     UserProfileScreen(),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColor.appBodyBG,
//       // extendBodyBehindAppBar: true,
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(160),
//         child: Container(
//           padding: EdgeInsets.only(top: 60, left: 10, right: 10),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12), // optional rounded corners
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Welcome",
//                         style: TextStyle(color: Colors.white, fontSize: 16),
//                       ),
//                       Text(
//                         "John Doe",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                   CircleAvatar(
//                     backgroundImage: AssetImage('assets/images/user.png'),
//                     radius: 25,
//                   ),
//                 ],
//               ),
//               SizedBox(height: 15),
//               Row(
//                 children: [
//                   Flexible(
//                     child: TextField(
//                       decoration: InputDecoration(
//                         hintText: "Search...",
//                         filled: true,
//                         fillColor: Colors.white,
//                         contentPadding: EdgeInsets.symmetric(
//                           vertical: 5,
//                           horizontal: 15,
//                         ),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(30),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 10),
//                   Builder(
//                     builder: (context) => Container(
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         shape: BoxShape.circle,
//                       ),
//                       child: IconButton(
//                         icon: Icon(Icons.menu, color: Colors.black),
//                         onPressed: () => Scaffold.of(context).openDrawer(),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: AnimatedSwitcher(
//               duration: Duration(milliseconds: 300),
//               transitionBuilder: (Widget child, Animation<double> animation) {
//                 return FadeTransition(opacity: animation, child: child);
//               },
//               child: _screens[_selectedIndex],
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         // backgroundColor: Color(0xFFBFE9DB),
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         selectedItemColor: AppColor.secondColor,
//         unselectedItemColor: Colors.grey,
//         type: BottomNavigationBarType.fixed,
//         items: [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home, size: 30),
//             label: "Home",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.task, size: 30),
//             label: "Task",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.notifications, size: 30),
//             label: "Notification",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.monetization_on, size: 30),
//             label: "Income",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person, size: 30),
//             label: "User",
//           ),
//         ],
//       ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             DrawerHeader(
//               decoration: BoxDecoration(color: AppColor.primeColor),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 spacing: 10,
//                 children: [
//                   CircleAvatar(
//                     backgroundImage: AssetImage('assets/images/user.png'),
//                     radius: 25,
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Text(
//                         "John Doe",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       Text(
//                         "johndoe@gmail.com",
//                         style: TextStyle(color: Colors.white, fontSize: 16),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             ListTile(
//               leading: Icon(Icons.post_add),
//               title: Text("Create Adds"),
//               onTap: () {
//                 Get.toNamed(RoutesName.createAddsScreen);
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.account_circle_outlined),
//               title: Text("Profile"),
//               onTap: () {
//                 Get.toNamed(RoutesName.userProfileScreen);
//               },
//             ),
//             ListTile(
//               leading: Icon(LucideIcons.bellDot),
//               title: Text("Notification"),
//               onTap: () {
//                 Get.toNamed(RoutesName.notificationScreen);
//               },
//             ),
//             ListTile(
//               leading: Icon(LucideIcons.building400),
//               title: Text("Employer"),
//               onTap: () {
//                 Get.toNamed(RoutesName.employerScreen);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
