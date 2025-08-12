import 'package:gig/data/network/network_api_services.dart';
import 'package:gig/res/app_url/app_url.dart';

class TaskRepository {
  final _apiServiecs = NetworkApiServices();
  Future<dynamic> taskRepo(var data) async {
    dynamic response = await _apiServiecs.postApi(data, AppUrl.resendOtpApi);
    return response;
  }
}
