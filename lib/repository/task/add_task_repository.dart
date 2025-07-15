
import '../../data/network/network_api_services.dart';
import '../../res/app_url/app_url.dart';

class AddTaskRepository {
  final _apiServiecs = NetworkApiServices();
  Future<dynamic> addTaskAPI(var data) async {
    dynamic responce = _apiServiecs.postApi(data, AppUrl.addTaskAPI);
    return responce;
  }
}