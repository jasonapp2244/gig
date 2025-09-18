import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gig/test.dart';
import 'package:gig/view/screen_holder/screens/adds/crate_a_add_screen.dart';
import 'package:gig/view/screen_holder/screens/adds/market_place.dart';
import 'package:gig/view/screen_holder/screens/market_place_screen/market_place_screen.dart';
import 'package:gig/view/splash_screen.dart';
import 'package:gig/res/routes/routes.dart';
import 'package:gig/utils/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  Utils.getAndPrintFCMToken();

  Color primeColor = Colors.transparent;
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: primeColor,
      systemNavigationBarColor: primeColor,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const MaterialColor primeSwatch = MaterialColor(
    0xFF0F1828, // Main color
    <int, Color>{
      50: Color(0xFFE6E8EC),
      100: Color(0xFFC2C8D2),
      200: Color(0xFF9BA6B5),
      300: Color(0xFF748497),
      400: Color(0xFF56697F),
      500: Color(0xFF0F1828), // Main color
      600: Color(0xFF0D1523),
      700: Color(0xFF0B121E),
      800: Color(0xFF090F19),
      900: Color(0xFF050A11),
    },
  );

  static const MaterialColor secondSwatch = MaterialColor(
    0xFFFA0101,
    <int, Color>{
      50: Color(0xFFFFE5E5),
      100: Color(0xFFFFB8B8),
      200: Color(0xFFFF8A8A),
      300: Color(0xFFFF5C5C),
      400: Color(0xFFFF3838),
      500: Color(0xFFFA0101), // Main color
      600: Color(0xFFE00101),
      700: Color(0xFFC70101),
      800: Color(0xFFAD0101),
      900: Color(0xFF800101),
    },
  );

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(350, 767),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          getPages: AppRoutes.appRoutes(),
          debugShowCheckedModeBanner: false,
          title: 'GIG',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch(primarySwatch: primeSwatch),
            useMaterial3: true,
          ),
          home: SplashScreen(),
        );
      },
    );
  }
}
