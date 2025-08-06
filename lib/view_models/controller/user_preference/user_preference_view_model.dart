import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/user_data.dart';
import '../../../models/auth/user_model.dart';

class UserPreference {
  Future<bool> saveUser(UserModel responseModel) async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    // Save all the necessary data
    sp.setString('token', responseModel.token ?? '');
    sp.setString('message', responseModel.message ?? '');
    sp.setBool('status', responseModel.status ?? false);
    sp.setString('token_type', responseModel.tokenType ?? '');

    if (responseModel.user != null) {
      sp.setInt('user_id', responseModel.user!.id ?? 0);
      sp.setInt('user_role_id', responseModel.user!.roleId ?? 0);
      sp.setString('user_email', responseModel.user!.email ?? '');
      sp.setString('user_phone_number', responseModel.user!.phoneNumber ?? '');
      sp.setString('user_address', responseModel.user!.address ?? '');
      sp.setString('user_city', responseModel.user!.city ?? '');
      sp.setString('user_state', responseModel.user!.state ?? '');
      sp.setString('user_country', responseModel.user!.country ?? '');
      sp.setString('user_zipcode', responseModel.user!.zipcode ?? '');

      // SAVE VANDOR DATA
      sp.setString('user_first_name', responseModel.user!.firstName ?? '');
      sp.setString('user_avatar', responseModel.user!.avatar ?? '');
      sp.setString(
        'user_profile_image',
        responseModel.user!.profileImage ?? '',
      );
    }

    return true;
  }

  Future<UserModel> getUser() async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    // Retrieve user data from SharedPreferences
    String? token = sp.getString('token');
    String? message = sp.getString('message');
    bool? status = sp.getBool('status');
    String? tokenType = sp.getString('token_type');

    UserData? user;
    if (sp.containsKey('user_id')) {
      user = UserData(
        id: sp.getInt('user_id'),
        roleId: sp.getInt('user_role_id'),
        email: sp.getString('user_email'),
        phoneNumber: sp.getString('user_phone_number'),
        address: sp.getString('user_address'),
        city: sp.getString('user_city'),
        state: sp.getString('user_state'),
        country: sp.getString('user_country'),
        zipcode: sp.getString('user_zipcode'),

        // SAVE VANDOR DATA
        firstName: sp.getString('user_first_name'),
        avatar: sp.getString('user_avatar'),
        profileImage: sp.getString('user_profile_image'),
      );
    }

    return UserModel(
      token: token,
      message: message,
      status: status,
      tokenType: tokenType,
      user: user,
    );
  }

  Future<bool> removeUser() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.clear();
    return true;
  }
}
