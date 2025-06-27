import 'package:get/get_navigation/src/root/internacionalization.dart';

class Languages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {

    'en_US': {
      // GLOBAL CONTENT
      'app_name' : 'Renigs',
      'sign_up' : 'Sign Up',
      'sign_in' : 'Sign In',
      'name_label' : 'Full Name',
      'name_hint' : 'Type your name',
      'email_label' : 'Email',
      'email_hint' : 'Type your email',
      'password_label' : 'Password',
      'password_hint' : 'Type your password',


      // LOGIN SCREEN CONTENT
      'you_dont_have_account' : "Don't have an account?",

      // REGISTER SCREEN CONTENT
      'already_have_account' : 'Already have an account?',


    },

    'ur_PK': {
      'email_hint' : 'Email likhen',
    }

  };
}