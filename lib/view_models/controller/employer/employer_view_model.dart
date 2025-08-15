import 'package:get/get.dart';
import '../../../repository/employer/employer_repository.dart';
import '../../../utils/utils.dart';

class EmployerViewModel extends GetxController {
  final EmployerRepository _employerRepository = EmployerRepository();

  RxBool loading = false.obs;
  RxList<Map<String, dynamic>> employers = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> filteredEmployers = <Map<String, dynamic>>[].obs;
  RxString error = ''.obs;
  RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchEmployers();
  }

  Future<void> fetchEmployers() async {
    try {
      loading.value = true;
      error.value = '';

      print('🔄 Fetching employers...');

      dynamic response = await _employerRepository.getEmployers();

      print('📋 Employers response: $response');

      if (response != null) {
        if (response['status'] == true) {
          List<dynamic> employersList = response['data'] ?? [];
          employers.value = employersList.map((employer) {
            return Map<String, dynamic>.from(employer);
          }).toList();

          // Initialize filtered employers with all employers
          filteredEmployers.value = List.from(employers);

          print(
            '✅ Employers loaded successfully: ${employers.length} employers',
          );
        } else {
          error.value = response['message'] ?? 'Failed to load employers';
          Utils.snakBar('Error', error.value);
        }
      } else {
        error.value = 'No response from server';
        Utils.snakBar('Error', error.value);
      }
    } catch (e) {
      loading.value = false;
      print('❌ Error fetching employers: $e');

      String errorMessage = 'Failed to load employers';
      if (e.toString().contains('InternetException')) {
        errorMessage = 'Please check your internet connection';
      } else if (e.toString().contains('FetchDataException')) {
        errorMessage = 'Server error. Please try again later';
      } else if (e.toString().contains('RequestTimeout')) {
        errorMessage = 'Request timeout. Please try again';
      } else {
        errorMessage = e.toString();
      }

      error.value = errorMessage;
      Utils.snakBar('Error', errorMessage);
    } finally {
      loading.value = false;
    }
  }

  void filterEmployers(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredEmployers.value = List.from(employers);
    } else {
      filteredEmployers.value = employers.where((employer) {
        final name = (employer['name'] ?? '').toString().toLowerCase();
        final company = (employer['company'] ?? '').toString().toLowerCase();
        final location = (employer['location'] ?? '').toString().toLowerCase();
        final searchLower = query.toLowerCase();

        return name.contains(searchLower) ||
            company.contains(searchLower) ||
            location.contains(searchLower);
      }).toList();
    }
  }

  Future<void> deleteEmployer(String employerId) async {
    try {
      loading.value = true;
      error.value = '';

      print('🗑️ Deleting employer with ID: $employerId');

      dynamic response = await _employerRepository.deleteEmployer(employerId);

      print('📋 Delete response: $response');

      if (response != null) {
        if (response['status'] == true) {
          Utils.snakBar('Success', 'Employer deleted successfully!');
          // Refresh the employers list
          await fetchEmployers();
        } else {
          error.value = response['message'] ?? 'Failed to delete employer';
          Utils.snakBar('Error', error.value);
        }
      } else {
        error.value = 'No response from server';
        Utils.snakBar('Error', error.value);
      }
    } catch (e) {
      loading.value = false;
      print('❌ Error deleting employer: $e');

      String errorMessage = 'Failed to delete employer';
      if (e.toString().contains('InternetException')) {
        errorMessage = 'Please check your internet connection';
      } else if (e.toString().contains('FetchDataException')) {
        errorMessage = 'Server error. Please try again later';
      } else if (e.toString().contains('RequestTimeout')) {
        errorMessage = 'Request timeout. Please try again';
      } else {
        errorMessage = e.toString();
      }

      error.value = errorMessage;
      Utils.snakBar('Error', errorMessage);
    } finally {
      loading.value = false;
    }
  }
}
