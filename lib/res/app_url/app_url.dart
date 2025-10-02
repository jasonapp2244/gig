class AppUrl {
  static const String baseUrl = 'https://gig.devonlinetestserver.com/api';
  // 'https://lavender-buffalo-882516.hostingersite.com/gig_app/api';
  //http://192.168.100.98/gig_mob_app/public/api";

  // //  'https://lavender-buffalo-882516.hostingersite.com/gig_app/api';

  // AUTH API
  static const String loginApi = "$baseUrl/auth/login";
  static const String registerApi = "$baseUrl/auth/signup";
  static const String logoutApi = "$baseUrl/logout";
  static const String socialLoginApi = '$baseUrl/auth/social-login';

  // PASSWORD API
  static const String forgetPasswordApi = "$baseUrl/auth/forgot-password";
  static const String resetPasswordApi = "$baseUrl/reset-password";

  // OTP API
  static const String otpApi = "$baseUrl/auth/verify-otp";
  static const String resendOtpApi = "$baseUrl/auth/resend-otp";

  // TASK API
  static const String addTaskAPI = "$baseUrl/tasks";
  static const String editTaskAPI = "$baseUrl/api/editTaskAPI";
  static const String getPaymentTaskAPI = "$baseUrl/get_tasks";

  static const String deleteTaskAPI = "$baseUrl/tasks-delete/";
  static const String taskStatusAPI = "$baseUrl/tasks-status";
  static const String showspecTaskAPI = "$baseUrl/show-employer-tasks";
  static const String taskByDate = "$baseUrl/tasks-by-date";

  // PROFILE API
  static const String updateProfileApi = "$baseUrl/update-profile";
  static const String getProfileApi = "$baseUrl/user-profile";

  static const String getEmployerApi = "$baseUrl/get-employer";
  static const String updateEmployeerApi = "$baseUrl/employer/";
  static const String deleteEmployeerApi = "$baseUrl/delete-employer/";

  static const String addmployeerApi = "$baseUrl/employers/";

  static const String paymentApi = '$baseUrl/get_tasks';
  static const String taskPaymentApi = '$baseUrl/task-payment';
  static const String showTasksApi = '$baseUrl/show-task';
  static const String earningSummaryApi = '$baseUrl/earningSummary';
  static const String getCategoriesApi = '$baseUrl/get-list-category';
  static const String supportApi = '$baseUrl/support/send';
}
