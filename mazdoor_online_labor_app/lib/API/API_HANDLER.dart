import 'API_CONSTANTS.dart';
import 'package:dio/dio.dart';
import '/models/login_tokens.dart';

final dio = Dio();

class APIHandler {

  late Options JWT_ACCESS_TOKEN_OPTIONS = Options(
      headers: JWT_TOKEN_DATA().getAccessHeader()
  );

  late Options JWT_REFRESH_TOKEN_OPTIONS = Options(
      headers: JWT_TOKEN_DATA().getRefreshHeader()
  );

  void config_dio(){
    dio.options.baseUrl = APIConstants().baseURL;
    dio.options.connectTimeout = Duration(seconds: 10);
    dio.options.receiveTimeout = Duration(seconds: 10);
    dio.options.headers['content-Type'] = 'application/json';
  }

  APIHandler(){
    config_dio();
  }
}