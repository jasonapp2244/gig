class AppUrl {
  static const String baseurl = "http://192.168.100.80/part_synch_mob_app";

  // AUTH API
  static const String loginApi = "$baseurl/public/api/signin";
  static const String registerApi = "$baseurl/public/api/signin";
  static const String logoutApi = "$baseurl/public/api/logout";

  // PASSWORD API
  static const String forgetPasswordApi = "$baseurl/public/api/forget_password";
  static const String resetPasswordApi = "$baseurl/public/api/reset_password";

  // OTP API
  static const String otpApi = "$baseurl/public/api/otp";
  static const String resendOtpApi = "$baseurl/public/api/resend_otp";

  // TASK API
  static const String addTaskAPI = "$baseurl/public/api/addTaskAPI";
  static const String editTaskAPI = "$baseurl/public/api/editTaskAPI";
}