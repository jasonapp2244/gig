// import '../../data/user_data.dart';
//
// class UserModel {
//   String? message;
//   bool? status;
//   UserData? user;
//   String? tokenType;
//   String? token;
//   List<dynamic>? data;
//
//   UserModel({
//     this.message,
//     this.status,
//     this.user,
//     this.tokenType,
//     this.token,
//     this.data,
//   });
//
//   UserModel.fromJson(Map<String, dynamic> json) {
//     message = json['message'];
//     status = json['status'];
//     user = json['user'] != null ? UserData.fromJson(json['user']) : null;
//     tokenType = json['token_type'];
//     token = json['token'];
//     if (json['data'] != null) {
//       data = json['data'];
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = {};
//     data['message'] = message;
//     data['status'] = status;
//     if (user != null) {
//       data['user'] = user!.toJson();
//     }
//     data['token_type'] = tokenType;
//     data['token'] = token;
//     if (this.data != null) {
//       data['data'] = this.data;
//     }
//     return data;
//   }
// }


import '../../data/user_data.dart';

class UserModel {
  String? message;
  bool? status;
  UserData? user;
  String? tokenType;
  String? token;

  UserModel({
    this.message,
    this.status,
    this.user,
    this.tokenType,
    this.token,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    tokenType = json['token_type'];
    token = json['token'];

    // 💡 Smart: Handle both auth and update response
    if (json['user'] != null) {
      user = UserData.fromJson(json['user']);
    } else if (json['data'] != null) {
      user = UserData.fromJson(json['data']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['message'] = message;
    data['status'] = status;
    data['token_type'] = tokenType;
    data['token'] = token;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}




