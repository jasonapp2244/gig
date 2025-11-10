class AppUrl {
  static const String baseUrl = 'https://portal.gigfmi.com';

  // AUTH API
  static const String loginApi = "$baseUrl/api/auth/login";
  static const String registerApi = "$baseUrl/api/auth/signup";
  static const String logoutApi = "$baseUrl/api/logout";
  static const String socialLoginApi = '$baseUrl/api/auth/social-login';

  // PASSWORD API
  static const String forgetPasswordApi = "$baseUrl/api/auth/forgot-password";
  static const String resetPasswordApi = "$baseUrl/api/reset-password";

  // OTP API
  static const String otpApi = "$baseUrl/api/auth/verify-otp";
  static const String resendOtpApi = "$baseUrl/api/auth/resend-otp";

  // TASK API
  static const String addTaskAPI = "$baseUrl/api/tasks";
  static const String editTaskAPI = "$baseUrl/api/editTaskAPI";
  static const String getPaymentTaskAPI = "$baseUrl/api/get_tasks";

  static const String deleteTaskAPI = "$baseUrl/api/tasks-delete/";
  static const String taskStatusAPI = "$baseUrl/api/tasks-status";
  static const String showspecTaskAPI = "$baseUrl/api/show-employer-tasks";
  static const String taskByDate = "$baseUrl/api/tasks-by-date";

  // PROFILE API
  static const String updateProfileApi = "$baseUrl/api/update-profile";
  static const String getProfileApi = "$baseUrl/api/user-profile";

  static const String getEmployerApi = "$baseUrl/api/get-employer";
  static const String updateEmployeerApi = "$baseUrl/api/employer/";
  static const String deleteEmployeerApi = "$baseUrl/api/delete-employer/";

  static const String addmployeerApi = "$baseUrl/api/employers/";

  static const String paymentApi = '$baseUrl/api/get_tasks';
  static const String taskPaymentApi = '$baseUrl/api/task-payment';
  static const String showTasksApi = '$baseUrl/api/show-task';
  static const String earningSummaryApi = '$baseUrl/api/earningSummary';
  static const String getCategoriesApi = '$baseUrl/api/get-list-category';
  static const String supportApi = '$baseUrl/api/support/send';
}
