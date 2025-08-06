import '../../data/network/network_api_services.dart';
import '../../res/app_url/app_url.dart';

class OtpRepository {
  final _apiServieces = NetworkApiServices();
  Future<dynamic> otpApi(var data) async {
    dynamic responce = await _apiServieces.postApi(data, AppUrl.otpApi);

    return responce;
  }
}
