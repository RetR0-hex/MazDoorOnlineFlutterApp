import 'package:dio/dio.dart';
import '../models/login_tokens.dart';
import 'API_HANDLER.dart';


class AuthApiHandler {
  Future<void> refresh_access_token() async {
    Response response;
    response = await dio.get('/auth/refresh', options: Options(
        headers: JWT_TOKEN_DATA().getRefreshHeader()
    ));

    JWT_TOKEN_DATA().accessToken = response.data["access_token"];
  }
}