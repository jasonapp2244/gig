
import 'package:gig/data/network/network_api_services.dart';
import 'package:gig/res/app_url/app_url.dart';

class ResetOtpRepository {
  final _apiServiecs = NetworkApiServices();
  Future<dynamic> resendOtpApi(var data) async {
    dynamic responce = await _apiServiecs.postApi(data, AppUrl.resendOtpApi);
    return responce;
  }
}
