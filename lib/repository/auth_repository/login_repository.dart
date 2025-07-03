
import '../../data/network/network_api_services.dart';
import '../../res/app_url/app_url.dart';

class LoginRepository {
  final _apiServiecs = NetworkApiServices();
  Future<dynamic> loginApi(var data) async {
    dynamic responce = _apiServiecs.postApi(data, AppUrl.loginApi);
    return responce;
  }
}