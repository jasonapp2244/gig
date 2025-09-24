import 'package:get/get.dart';
import 'package:gig/res/routes/routes_name.dart';
import 'package:gig/view/auth/register.dart';
import 'package:gig/view/otp/otp_screen.dart';
import 'package:gig/view/password/reset_password.dart';
import 'package:gig/view/payment/payment_method_screen.dart';
import 'package:gig/view/screen_holder/screen_holder_screen.dart';
import 'package:gig/view/screen_holder/screens/adds/add_payement_screen.dart';
import 'package:gig/view/screen_holder/screens/employer/employer_detail_screen.dart';
import 'package:gig/view/screen_holder/screens/income_tracker/income_tracker_screen.dart';
import 'package:gig/view/screen_holder/screens/market_place_screen/market_place_screen.dart';
import 'package:gig/view/screen_holder/screens/market_place_screen/single_product_screen.dart';
import 'package:gig/view/screen_holder/screens/notification/notification.dart';
import 'package:gig/view/screen_holder/screens/user_profile/add_profile_screen.dart';
import 'package:gig/view/screen_holder/screens/user_profile/user_profile_screen.dart';
import 'package:gig/view/subscription/subscription_screen.dart';
import '../../view/auth/get_started_secreen.dart';
import '../../view/auth/login.dart';
import '../../view/onboarding_screen/onboarding_screen.dart';
import '../../view/password/forget_password.dart';
import '../../view/screen_holder/screens/adds/crate_a_add_screen.dart';
import '../../view/screen_holder/screens/employer/employer_screen.dart';
import '../../view/screen_holder/screens/task/add_task_screen.dart';
import '../../view/screen_holder/screens/task/task_screen.dart';

class AppRoutes {
  static List<GetPage> appRoutes() => [
    //////////// GENERAL ROUTES
    GetPage(
      name: RoutesName.onBoardingScreen,
      page: () => OnboardingScreen(),
      transitionDuration: Duration(milliseconds: 300),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: RoutesName.getStartedScreen,
      page: () => GetStartedSecreen(),
      transitionDuration: Duration(milliseconds: 300),
      transition: Transition.rightToLeft,
    ),

    //////////// AUTH ROUTES
    GetPage(
      name: RoutesName.loginScreen,
      page: () => Login(),
      transitionDuration: Duration(milliseconds: 300),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: RoutesName.registerScreen,
      page: () => RegisterScreen(),
      transitionDuration: Duration(milliseconds: 300),
      transition: Transition.rightToLeft,
    ),

    //////////// PASSWORD ROUTES
    GetPage(
      name: RoutesName.forgetPassword,
      page: () => ForgetPassword(),
      transitionDuration: Duration(milliseconds: 300),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: RoutesName.resetPassword,
      page: () => ResetPassword(),
      transitionDuration: Duration(milliseconds: 300),
      transition: Transition.rightToLeft,
    ),

    //////////// OTP ROUTES
    GetPage(
      name: RoutesName.otpScreen,
      page: () => OtpScreen(),
      transitionDuration: Duration(milliseconds: 300),
      transition: Transition.rightToLeft,
    ),

    //////////// SUBSCRIPTION ROUTES
    GetPage(
      name: RoutesName.subscriptionScreen,
      page: () => SubscriptionScreen(),
      transitionDuration: Duration(milliseconds: 300),
      transition: Transition.rightToLeft,
    ),

    //////////// PAYMENT METHOD ROUTES
    GetPage(
      name: RoutesName.paymentMethodScreen,
      page: () => PaymentMethodScreen(),
      transitionDuration: Duration(milliseconds: 300),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: RoutesName.addPaymentScreen,
      page: () => AddPaymentScreen(),
      transitionDuration: Duration(milliseconds: 300),
      transition: Transition.rightToLeft,
    ),

    //////////// SCREEN HOLDER ROUTES
    GetPage(
      name: RoutesName.screenHolderScreen,
      page: () => ScreenHolderScreen(),
      transitionDuration: Duration(milliseconds: 300),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: RoutesName.addTaskScreen,
      page: () => AddTaskScreen(),
      transitionDuration: Duration(milliseconds: 300),
      transition: Transition.rightToLeft,
    ),

    //////////// TASK SCREEN ROUTES
    GetPage(
      name: RoutesName.taskScreen,
      page: () => TaskScreen(),
      transitionDuration: Duration(milliseconds: 300),
      transition: Transition.rightToLeft,
    ),

    /////////// INCOME TRACKER SCREEN ROUTES
    GetPage(
      name: RoutesName.incomeTracker,
      page: () => IncomeTracker(),
      transitionDuration: Duration(milliseconds: 300),
      transition: Transition.rightToLeft,
    ),

    ////////// MARKET PLACE ROUTES
    GetPage(
      name: RoutesName.detailScreenView,
      page: () => MarketPlaceView(),
      transitionDuration: Duration(milliseconds: 300),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: RoutesName.singleProductScreen,
      page: () => SingleProductScreen(),
    ),

    // GetPage(
    //   name: RoutesName.singleProductScreen,
    //   // page: () => SingleProductScreen(),
    //   transitionDuration: Duration(milliseconds: 300),
    //   transition: Transition.rightToLeft,
    // ),

    ////////// CREATE ADDS ROUTES
    GetPage(
      name: RoutesName.createAddsScreen,
      page: () => CreaAAddScreen(),
      transitionDuration: Duration(milliseconds: 300),
      transition: Transition.rightToLeft,
    ),

    // GetPage(
    //   name: RoutesName.createAAddsScreen,
    //   page: () => CreaAAddScreen(),
    //   transitionDuration: Duration(milliseconds: 300),
    //   transition: Transition.rightToLeft,
    // ),
    GetPage(
      name: RoutesName.userProfileScreen,
      page: () => UserProfileScreen(),
      transitionDuration: Duration(milliseconds: 300),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: RoutesName.profileViewScreen,
      page: () => AddProfileScreen(),
      transitionDuration: Duration(milliseconds: 300),
      transition: Transition.rightToLeft,
    ),

    GetPage(
      name: RoutesName.notificationScreen,
      page: () => NotificationScreen(),
      transitionDuration: Duration(milliseconds: 300),
      transition: Transition.rightToLeft,
    ),

    GetPage(
      name: RoutesName.employerScreen,
      page: () => EmployerScreen(),
      transitionDuration: Duration(milliseconds: 300),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: RoutesName.employerDetailScreen,
      page: () => EmployerDetailScreen(),
      transitionDuration: Duration(milliseconds: 300),
      transition: Transition.rightToLeft,
    ),

    GetPage(name: RoutesName.home, page: () => ScreenHolderScreen()),
  ];
}
