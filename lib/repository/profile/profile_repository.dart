import 'dart:io';
import 'package:gig/data/network/base_api_services.dart';
import 'package:gig/data/network/network_api_services.dart';
import 'package:gig/res/app_url/app_url.dart';
import 'package:gig/models/profile/profile_model.dart';
import 'package:gig/utils/utils.dart';
import 'package:http/http.dart' as http;

class ProfileRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> updateProfile(
    ProfileModel profileData, {
    File? profileImage,
    File? pdfFile,
  }) async {
    try {
      // Get auth token
      String? token = await Utils.readSecureData('auth_token');
      if (token == null) {
        throw Exception('Authentication token not found. Please login again.');
      }

      // If we have files to upload, use multipart
      if (profileImage != null || pdfFile != null) {
        return await _uploadProfileWithFiles(
          profileData,
          profileImage,
          pdfFile,
          token,
        );
      } else {
        // Simple JSON post with token
        return await NetworkApiServices().postProfileData(
          profileData.toJson(),
          AppUrl.updateProfileApi,
          token,
        );
      }
    } catch (e) {
      print('Error in updateProfile: $e');
      rethrow;
    }
  }

  Future<dynamic> _uploadProfileWithFiles(
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
}
