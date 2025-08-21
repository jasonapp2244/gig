import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:gig/models/profile/profile_model.dart';
import 'package:gig/res/app_url/app_url.dart';
import '../app_exceptions.dart';
import 'base_api_services.dart';
import 'package:http/http.dart' as http;

class NetworkApiServices extends BaseApiServices {
  @override
  Future<dynamic> getApi(String url, String token) async {
    dynamic responseJson;
    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw InternetException(
        'Please check your internet connection and try again',
      );
    } on RequestTimeout {
      throw RequestTimeout('Server is not responding');
    } catch (e) {
      throw FetchDataException('Unexpected error: $e');
    }
    return responseJson;
  }

  Future<dynamic> getProfileApi(String token) async {
    dynamic responseJson;
    try {
      final response = await http
          .get(
            Uri.parse(
              AppUrl.getProfileApi,
            ), // Replace with your profile endpoint
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $token', // Only token passed
            },
          )
          .timeout(const Duration(seconds: 10));

      responseJson = returnResponse(response);
    } on SocketException {
      throw InternetException(
        'Please check your internet connection and try again',
      );
    } on RequestTimeout {
      throw RequestTimeout('Server is not responding, please try again later');
    } catch (e) {
      throw FetchDataException('Unexpected error: $e');
    }
    return responseJson;
  }

  @override
  Future<dynamic> postApi(var data, String url) async {
    dynamic responseJson;
    try {
      // final userData = await UserPreference().getUser();
      // final token = userData.token;
      print(data);

      final response = await http
          .post(
            Uri.parse(url),
            body: jsonEncode(data),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              //'Authorization': '$data',
            },
          )
          .timeout(Duration(seconds: 15));

      responseJson = returnResponse(response);
    } on SocketException {
      throw InternetException(
        'Please check your internet connection and try again',
      );
    } on RequestTimeout {
      throw RequestTimeout('Server is not responding');
    } catch (e) {
      throw FetchDataException('Unexpected error: $e');
    }
    return responseJson;
  }

  Future<dynamic> postProfileData(var data, String url, String token) async {
    dynamic responseJson;

    try {
      // Debug print request data
      print(" Sending POST request to: $url");
      print(" Data: $data");

      final response = await http
          .post(
            Uri.parse(url),
            body: jsonEncode(data),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token', // Uncomment if you have a token
            },
          )
          .timeout(const Duration(seconds: 10));

      responseJson = returnResponse(response);
    } on SocketException {
      throw InternetException(
        'Please check your internet connection and try again',
      );
    }
    return responseJson;
  }

  Future<dynamic> postTask(var data, String url, String token) async {
    dynamic responseJson;

    try {
      // Debug print request data
      print(" Sending POST request to: $url");
      print(" Data: $data");

      final response = await http
          .post(
            Uri.parse(url),
            body: jsonEncode(data),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token', // Uncomment if you have a token
            },
          )
          .timeout(const Duration(seconds: 10));

      responseJson = returnResponse(response);
    } on SocketException {
      throw InternetException(
        'Please check your internet connection and try again',
      );
    }
    return responseJson;
  }

  Future<dynamic> PostProfileWithFiles(
    ProfileModel profileData,
    File? profileImage,
    File? pdfFile,
    String token,
  ) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(AppUrl.updateProfileApi),
      );

      // Add auth token to headers
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      // Add form fields
      request.fields.addAll(profileData.toFormData());

      // Add profile image if provided
      if (profileImage != null) {
        request.files.add(
          await http.MultipartFile.fromPath('profile_image', profileImage.path),
        );
      }

      // Add PDF file if provided
      if (pdfFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('cv', pdfFile.path),
        );
      }

      print('🚀 Sending multipart request to: ${AppUrl.updateProfileApi}');
      print('📄 Form fields: ${request.fields}');
      print('📎 Files: ${request.files.map((f) => f.field).toList()}');
      print('🔑 Token: Bearer ${token.substring(0, 10)}...');

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print('📈 Response status: ${response.statusCode}');
      print('📝 Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.body;
      } else {
        throw Exception(
          'Failed to update profile: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('❌ Error in _uploadProfileWithFiles: $e');
      rethrow;
    }
  }

  // Post API with Authentication Token
  Future<dynamic> postApiWithToken(var data, String url, String token) async {
    dynamic responseJson;
    try {
      print('🔑 Sending authenticated request to: $url');
      print('📄 Data: $data');
      print('🎫 Token: Bearer ${token.substring(0, 10)}...');

      final response = await http
          .post(
            Uri.parse(url),
            body: jsonEncode(data),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(Duration(seconds: 10));

      responseJson = returnResponse(response);
    } on SocketException {
      throw InternetException(
        'Please check your internet connection and try again',
      );
    } on RequestTimeout {
      throw RequestTimeout('Server is not responding');
    } catch (e) {
      throw FetchDataException('Unexpected error: $e');
    }
    return responseJson;
  }

  Future<dynamic> postLogoutApi(var data, String url) async {
    dynamic responseJson;
    try {
      print(data['token']);
      String token = data['token'];

      final response = await http
          .post(
            Uri.parse(url),
            //     body: jsonEncode(data),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': "Bearer $token",
            },
          )
          .timeout(Duration(seconds: 10));

      responseJson = returnResponse(response);
    } on SocketException {
      throw InternetException(
        'Please check your internet connection and try again',
      );
    } on RequestTimeout {
      throw RequestTimeout('Server is not responding');
    } catch (e) {
      throw FetchDataException('Unexpected error: $e');
    }
    return responseJson;
  }

  Future<dynamic> getEmployerApi(String token) async {
    dynamic responseJson;
    try {
      final response = await http
          .get(
            Uri.parse(AppUrl.getEmployerApi),
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 10));

      responseJson = returnResponse(response);
    } on SocketException {
      throw InternetException(
        'Please check your internet connection and try again',
      );
    } on RequestTimeout {
      throw RequestTimeout('Server is not responding, please try again later');
    } catch (e) {
      throw FetchDataException('Unexpected error: $e');
    }
    return responseJson;
  }

  Future<dynamic> getTasksApi(String token) async {
    dynamic responseJson;
    try {
      final response = await http
          .get(
            Uri.parse(AppUrl.getTaskAPI),
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 30));

      responseJson = returnResponse(response);
    } on SocketException {
      throw InternetException(
        'Please check your internet connection and try again',
      );
    } on RequestTimeout {
      throw RequestTimeout('Server is not responding, please try again later');
    } catch (e) {
      throw FetchDataException('Unexpected error: $e');
    }
    return responseJson;
  }

  Future<dynamic> getTaskStatusApi(String token, {String? status}) async {
    dynamic responseJson;
    try {
      // Prepare request body with optional status parameter
      Map<String, dynamic> requestBody = {};
      if (status != null) {
        requestBody['status'] = status.toLowerCase();
      }

      final response = await http
          .post(
            Uri.parse(AppUrl.taskStatusAPI),
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: jsonEncode(requestBody),
          )
          .timeout(const Duration(seconds: 15));

      responseJson = returnResponse(response);
    } on SocketException {
      throw InternetException(
        'Please check your internet connection and try again',
      );
    } on RequestTimeout {
      throw RequestTimeout('Server is not responding, please try again later');
    } catch (e) {
      throw FetchDataException('Unexpected error: $e');
    }
    return responseJson;
  }

  Future<dynamic> deleteEmployerApi(String employerId, String token) async {
    dynamic responseJson;
    try {
      final deleteUrl = '${AppUrl.deleteEmployeerApi}$employerId';
      print('🗑️ DELETE Request URL: $deleteUrl');
      print('🗑️ DELETE Request Headers: Authorization: Bearer $token');

      // First, get the employer data to use their actual salary
      print('🔍 Fetching employer data for ID: $employerId');
      final employerResponse = await http
          .get(
            Uri.parse(AppUrl.getEmployerApi),
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 10));

      final employerData = jsonDecode(employerResponse.body);
      print('📋 Employer data response: $employerData');

      // Find the specific employer by ID
      Map<String, dynamic>? targetEmployer;
      if (employerData['status'] == true && employerData['data'] != null) {
        List<dynamic> employers = employerData['data'];
        targetEmployer = employers.firstWhere(
          (employer) => employer['id'].toString() == employerId,
          orElse: () => null,
        );
      }

      if (targetEmployer == null) {
        throw Exception('Employer with ID $employerId not found');
      }

      print(
        '✅ Found employer: ${targetEmployer['employer_name']} with salary: ${targetEmployer['salary']}',
      );

      // Use the actual employer data for the delete request
      Map<String, dynamic> requestBody = {
        'salary': targetEmployer['salary']?.toString() ?? '0',
        // Mark as inactive/deleted
      };

      print('🗑️ POST Request Body: $requestBody');

      final response = await http
          .post(
            Uri.parse(deleteUrl),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(requestBody),
          )
          .timeout(const Duration(seconds: 10));

      print(' POST Response Status: ${response.statusCode}');
      print(' POST Response Body: ${response.body}');

      responseJson = returnResponse(response);
    } on SocketException {
      throw InternetException(
        'Please check your internet connection and try again',
      );
    } on RequestTimeout {
      throw RequestTimeout('Server is not responding, please try again later');
    } catch (e) {
      print('🗑️ DELETE Error: $e');
      throw FetchDataException('Unexpected error: $e');
    }
    return responseJson;
  }

  Future<dynamic> deleteTaskApi(int taskId, String token, String url) async {
    dynamic responseJson;
    try {
      final deleteUrl = '${url}$taskId';
      print('🗑️ DELETE Request URL: $deleteUrl');
      print('🗑️ DELETE Request Headers: Authorization: Bearer $token');

      // First, get the task data to verify it exists
      print('🔍 Fetching task data for ID: $taskId');
      final taskResponse = await http
          .get(
            Uri.parse(AppUrl.getTaskAPI),
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 10));

      final tasksData = jsonDecode(taskResponse.body);
      print('📋 Task data response: $tasksData');

      // Find the specific task by ID
      Map<String, dynamic>? targetTask;
      if (tasksData['status'] == true && tasksData['tasks'] != null) {
        List<dynamic> tasks = tasksData['tasks'];
        targetTask = tasks.firstWhere(
          (task) => task['id'].toString() == taskId.toString(),
          orElse: () => null,
        );
      }

      if (targetTask == null) {
        throw Exception('Task with ID $taskId not found');
      }

      final response = await http
          .post(
            Uri.parse(deleteUrl),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 10));

      print(' POST Response Status: ${response.statusCode}');
      print(' POST Response Body: ${response.body}');

      responseJson = returnResponse(response);
    } on SocketException {
      throw InternetException(
        'Please check your internet connection and try again',
      );
    } on RequestTimeout {
      throw RequestTimeout('Server is not responding, please try again later');
    } catch (e) {
      print('🗑️ DELETE Error: $e');
      throw FetchDataException('Unexpected error: $e');
    }
    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    if (kDebugMode) {
      print("Response Body: ${response.body}");
      print("Status Code: ${response.statusCode}");
    }

    try {
      switch (response.statusCode) {
        case 200:
        case 201:
        case 202:
        case 204:
          return jsonDecode(response.body);

        case 400:
        case 422:
          // For 400 and 422 status codes, try to parse JSON response
          // This handles cases like email verification errors and validation errors
          try {
            var jsonResponse = jsonDecode(response.body);
            // If it's a valid JSON with status and message, return it
            if (jsonResponse is Map && jsonResponse.containsKey('message')) {
              return jsonResponse;
            }
          } catch (jsonError) {
            // If JSON parsing fails, fall back to throwing exception
          }
          throw InvalidUrl('Bad request (${response.statusCode})');

        case 401:
          throw FetchDataException('Unauthorized (401)');

        case 403:
          throw FetchDataException('Forbidden (403)');

        case 404:
          throw FetchDataException('Not found (404)');

        case 500:
          throw FetchDataException('Internal server error (500)');

        default:
          throw FetchDataException(
            'Unexpected status code: ${response.statusCode}',
          );
      }
    } catch (e) {
      // If it's already a formatted response from case 400, rethrow it
      if (e is Map) {
        return e;
      }
      throw FetchDataException('Invalid JSON or unexpected error: $e');
    }
  }
}
