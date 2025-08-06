import '../../data/network/network_api_services.dart';
import '../../res/app_url/app_url.dart';

class LogoutRepository {
  final _apiServiecs = NetworkApiServices();
  Future<dynamic> logoutApi(var data) async {
    dynamic responce = await _apiServiecs.postLogoutApi(data, AppUrl.logoutApi);
    return responce;
  }
}
