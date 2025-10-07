import '../../data/network/network_api_services.dart';
import '../../res/app_url/app_url.dart';

class LoginRepository {
  final _apiServiecs = NetworkApiServices();
  Future<dynamic> loginApi(Map<String, String> data) async {
    dynamic responce = await _apiServiecs.postApi2(data, AppUrl.loginApi);
    return responce;
  }
}
