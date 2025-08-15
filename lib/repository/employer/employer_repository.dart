import '../../data/network/network_api_services.dart';
import '../../utils/utils.dart';

class EmployerRepository {
  final _apiServices = NetworkApiServices();

  Future<dynamic> getEmployers() async {
    try {
      // Get auth token
      String? token = await Utils.readSecureData('auth_token');
      if (token == null) {
        throw Exception('Authentication token not found. Please login again.');
      }

      // Call the get employers API with authentication
      return await _apiServices.getEmployerApi(token);
    } catch (e) {
      print('Error in getEmployers: $e');
      rethrow;
    }
  }

  Future<dynamic> deleteEmployer(String employerId) async {
    try {
      print('🔍 Repository: Starting delete for employer ID: $employerId');
      // Get auth token
      String? token = await Utils.readSecureData('auth_token');
      if (token == null) {
        throw Exception('Authentication token not found. Please login again.');
      }
      print('🔍 Repository: Token retrieved successfully');

      // Call the delete employer API with authentication
      dynamic result = await _apiServices.deleteEmployerApi(employerId, token);
      print('🔍 Repository: Delete API call completed: $result');
      return result;
    } catch (e) {
      print('❌ Repository Error in deleteEmployer: $e');
      rethrow;
    }
  }
}
