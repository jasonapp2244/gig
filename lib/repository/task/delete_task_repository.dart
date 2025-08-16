import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gig/data/network/network_api_services.dart';
import 'package:gig/res/app_url/app_url.dart';

class DeleteTaskRepository {
  final _apiServiecs = NetworkApiServices();

  Future<dynamic> deleteTaskAPI(int taskId) async {
    // Get auth token from secure storage
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'auth_token');

    if (token == null) {
      throw Exception('Authentication token not found');
    }

    // Use deleteTaskApi method with correct parameter order
    dynamic response = await _apiServiecs.deleteTaskApi(
      taskId,
      token,
      AppUrl.deleteTaskAPI,
    );
    return response;
  }
}
