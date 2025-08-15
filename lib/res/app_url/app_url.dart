class AppUrl {
  // static const String baseurl = "http://192.168.100.80/part_synch_mob_app";
  static const String baseUrl =
      //'http://192.168.18.159/gig_mob_app/public/api';
      'https://lavender-buffalo-882516.hostingersite.com/gig_app/api';

  // AUTH API
  static const String loginApi = "$baseUrl/auth/login";
  static const String registerApi = "$baseUrl/auth/signup";
  static const String logoutApi = "$baseUrl/logout";

  // PASSWORD API
  static const String forgetPasswordApi = "$baseUrl/auth/forgot-password";
  static const String resetPasswordApi = "$baseUrl/api/reset_password";

  // OTP API
  static const String otpApi = "$baseUrl/auth/verify-otp";
  static const String resendOtpApi = "$baseUrl/auth/resend-otp";

  // TASK API
  static const String addTaskAPI = "$baseUrl/tasks";
  static const String editTaskAPI = "$baseUrl/api/editTaskAPI";
  static const String getTaskAPI = "$baseUrl/tasks";
  static const String deleteTaskAPI = "$baseUrl/tasks-delete/";

  // PROFILE API
  static const String updateProfileApi = "$baseUrl/update-profile";
  static const String getProfileApi = "$baseUrl/get-user";

  static const String getEmployerApi = "$baseUrl/get-employer";
  static const String updateEmployeerApi = "$baseUrl/employer/";
  static const String deleteEmployeerApi = "$baseUrl/delete-employer/";

  static const String addmployeerApi = "$baseUrl/employers/";
}
