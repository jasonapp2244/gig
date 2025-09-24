import 'dart:async';
import 'dart:io';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gig/data/app_exceptions.dart';
import 'package:gig/data/network/network_api_services.dart';
import 'package:gig/models/category_model.dart';
import 'package:gig/res/app_url/app_url.dart';
import 'package:gig/utils/utils.dart';

class MarkeViewModel {
  List<CategoryModel>? categories;
  Future<dynamic> getCategoriesApi() async {
    try {
      String? token = await Utils.readSecureData('auth_token');

      if (token == null || token.isEmpty) {
        Utils.snakBar('Error', 'No authentication token found');
        return '';
      }
      final response = await NetworkApiServices().getCategoriesApi(
        token,
        url: AppUrl.getCategoriesApi,
      );

      return response;
    } catch (e) {
      throw FetchDataException('Unexpected error: $e');
    }
  }
}
