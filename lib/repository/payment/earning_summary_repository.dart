























































import '../../data/network/network_api_services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EarningSummaryRepository {
  final _apiServices = NetworkApiServices();

  Future<dynamic> getEarningSummaryAPI() async {
    // Get auth token from secure storage
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'auth_token');

    if (token == null) {
      throw Exception('Authentication token not found');
    }

    // Use GET method to fetch earning summary
    dynamic response = await _apiServices.getEarningSummaryApi(token);
    return response;
  }
}
