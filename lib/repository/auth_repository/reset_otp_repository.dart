import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gig/data/network/network_api_services.dart';
import 'package:gig/res/app_url/app_url.dart';

class ResetOtpRepository {
  final _apiServiecs = NetworkApiServices();
  Future<dynamic> resetOtpApi(var data) async {
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'auth_token');

    if (token == null) {
      throw Exception('Authentication token not found');
    }
    dynamic responce = await _apiServiecs.postApiWithToken(
      data,
      AppUrl.resetPasswordApi,
      token,
    );
    return responce;
  }
}
