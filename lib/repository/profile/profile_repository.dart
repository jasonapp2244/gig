import 'dart:io';
import 'package:gig/data/network/base_api_services.dart';
import 'package:gig/data/network/network_api_services.dart';
import 'package:gig/res/app_url/app_url.dart';
import 'package:gig/models/profile/profile_model.dart';
import 'package:gig/utils/utils.dart';

class ProfileRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> getProfile() async {
    try {
      // Get auth token
      String? token = await Utils.readSecureData('auth_token');
      if (token == null) {
        throw Exception('Authentication token not found. Please login again.');
      }

      // Call the get profile API
      return await NetworkApiServices().getProfileApi(token);
    } catch (e) {
      print('Error in getProfile: $e');
      rethrow;
    }
  }

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
        return await NetworkApiServices().PostProfileWithFiles(
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
}
