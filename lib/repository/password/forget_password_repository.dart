import '../../data/network/network_api_services.dart';
import '../../res/app_url/app_url.dart';

class ForgetPasswordRepository {
  final _apiServiecs = NetworkApiServices();
  Future<dynamic> forgetPasswordApi(var data) async {
    dynamic responce = await _apiServiecs.postApi(
      data,
      AppUrl.forgetPasswordApi,
    );
    return responce;
  }
}
