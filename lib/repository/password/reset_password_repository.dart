import '../../data/network/network_api_services.dart';
import '../../res/app_url/app_url.dart';

class ResetPasswordRepository {
  final _apiServiecs = NetworkApiServices();
  Future<dynamic> resetPasswordApi(var data) async {
    dynamic responce = _apiServiecs.postApi(data, AppUrl.resetPasswordApi);
    return responce;
  }
}