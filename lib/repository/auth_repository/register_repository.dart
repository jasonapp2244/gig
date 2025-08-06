
import '../../data/network/network_api_services.dart';
import '../../res/app_url/app_url.dart';

class RegisterRepository {
  final _apiServiecs = NetworkApiServices();
  Future<dynamic> registerApi(var data) async {
    dynamic response = await _apiServiecs.postApi(data, AppUrl.registerApi);
    return response;
  }
}