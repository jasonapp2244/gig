
import '../../data/network/network_api_services.dart';
import '../../res/app_url/app_url.dart';

class EditTaskRepository {
  final _apiServiecs = NetworkApiServices();
  Future<dynamic> editTaskAPI(var data) async {
    dynamic responce = _apiServiecs.postApi(data, AppUrl.editTaskAPI);
    return responce;
  }
}