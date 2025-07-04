
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../../view_models/controller/user_preference/user_preference_view_model.dart';
import '../app_exceptions.dart';
import 'base_api_services.dart';
import 'package:http/http.dart' as http;
class NetworkApiServices extends BaseApiServices {
  @override
  Future<dynamic> getApi(String url) async {
    dynamic responseJson;
    try {
      final response = await http.get(Uri.parse(url)).timeout(Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw InternetException('Please check your internet connection and try again');
    } on RequestTimeout {
      throw RequestTimeout('Server is not responding');
    } catch (e) {
      throw FetchDataException('Unexpected error: $e');
    }
    return responseJson;
  }

  @override
  Future<dynamic> postApi(var data, String url) async {
    dynamic responseJson;
    try {
      final userData = await UserPreference().getUser();
      final token = userData.token;

      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(Duration(seconds: 10));

      responseJson = returnResponse(response);
    } on SocketException {
      throw InternetException('Please check your internet connection and try again');
    } on RequestTimeout {
      throw RequestTimeout('Server is not responding');
    } catch (e) {
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
          throw InvalidUrl('Bad request (400)');

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
              'Unexpected status code: ${response.statusCode}');
      }
    } catch (e) {
      throw FetchDataException('Invalid JSON or unexpected error: $e');
    }
  }
}
