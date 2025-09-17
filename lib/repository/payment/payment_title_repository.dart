import '../../data/network/network_api_services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PaymentTitleRepository {
  final _apiServices = NetworkApiServices();

  Future<dynamic> getPaymentTitlesAPI() async {
    // Get auth token from secure storage
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'auth_token');

    if (token == null) {
      throw Exception('Authentication token not found');
    }

    // Use getTasksApi method to fetch payment titles
    dynamic response = await _apiServices.getPaymentPending(token);
    return response;
  }
}
