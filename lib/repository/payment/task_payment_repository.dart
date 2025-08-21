import '../../data/network/network_api_services.dart';
import '../../res/app_url/app_url.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TaskPaymentRepository {
  final _apiServices = NetworkApiServices();

  Future<dynamic> addTaskPaymentAPI(Map<String, dynamic> data) async {
    // Get auth token from secure storage
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'auth_token');

    if (token == null) {
      throw Exception('Authentication token not found');
    }

    // Use postApiWithToken method to include authentication
    dynamic response = await _apiServices.postApiWithToken(
      data,
      AppUrl.taskPaymentApi,
      token,
    );
    return response;
  }
}
