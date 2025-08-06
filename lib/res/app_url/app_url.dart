class AppUrl {
  // static const String baseurl = "http://192.168.100.80/part_synch_mob_app";
  static const String baseUrl =
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
  static const String addTaskAPI = "$baseUrl/api/addTaskAPI";
  static const String editTaskAPI = "$baseUrl/api/editTaskAPI";
}
