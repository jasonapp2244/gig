import '../../data/network/network_api_services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class GetTaskRepository {
  final _apiServices = NetworkApiServices();

  Future<dynamic> getTasksAPI() async {
    // Get auth token from secure storage
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'auth_token');

    if (token == null) {
      throw Exception('Authentication token not found');
    }

    // Use getTasksApi method to fetch tasks
    dynamic response = await _apiServices.getTasksApi(token);
    return response;
  }

  Future<dynamic> getTaskStatusAPI({String? status}) async {
    // Get auth token from secure storage
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'auth_token');

    if (token == null) {
      throw Exception('Authentication token not found');
    }

    // Use getTaskStatusApi method to fetch task status summary with optional status parameter
    dynamic response = await _apiServices.getTaskStatusApi(
      token,
      status: status,
    );
    return response;
  }
}
