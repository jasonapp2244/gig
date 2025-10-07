abstract class BaseApiServices {
  Future<dynamic> getApi(String url, String token);
  Future<dynamic> postApi(dynamic data, String url);
  Future<dynamic> postApi2(Map<String, String> data, String url);
}
