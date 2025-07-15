import '../../data/network/network_api_services.dart';
import '../../res/app_url/app_url.dart';

class ResendOtpRepository {
  final _apiServieces = NetworkApiServices();
  Future<dynamic> resendOtpApi(var data) async {
    dynamic responce = _apiServieces.postApi(data, AppUrl.resendOtpApi);

    return responce;
  }


}