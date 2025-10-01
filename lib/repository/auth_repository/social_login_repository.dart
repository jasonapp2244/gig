import '../../data/network/network_api_services.dart';
import '../../res/app_url/app_url.dart';

class SocialLoginRepository {
  final _apiServiecs = NetworkApiServices();
  Future<dynamic> SocialLoginApi(var data) async {
    dynamic responce = await _apiServiecs.postApi(data, AppUrl.socialLoginApi);
    return responce;
  }
}
