import 'API_HANDLER.dart';
import '/models/login_tokens.dart';
import 'package:dio/dio.dart';
import '/models/user.dart';


class UserApiHandler extends APIHandler{
  Future<bool> get_user_data() async {
    // first we need to check if JWT_TOKENS ARE NULL OR NOT
    if (JWT_TOKEN_DATA().accessToken == Null) {
      throw Exception("JWT ACCESS TOKENS ARE MISSING");
    }

    Response response = await dio.get('/api/v1/users/current-user/',
        options: JWT_ACCESS_TOKEN_OPTIONS);
    if (response.statusCode != 200) {
      throw Exception("An error occurred when communicating with server");
    }

    UserData userData = UserData();
    userData.update_values_from_json(response.data['user']);
    return true;
  }

  Future<void> register_labor(String fullName, String phoneNumber, String email, String password, int category_id) async {
    try {
      Response response;
      response = await dio.post('/auth/register-labor', data: {
        "email": email,
        "full_name": fullName,
        "password": password,
        "phone_number": phoneNumber,
        "category_id": category_id.toInt(),
      });

      JWT_TOKEN_DATA().accessToken = response.data["access_token"];
      JWT_TOKEN_DATA().refreshToken = response.data["refresh_token"];
    } catch (e) {
      if (e is DioError) {
        throw Exception(e.response?.data['msg']);
      }
    }
  }

  Future<void> register_user(String fullName, String phoneNumber, String email, String password) async {
    Response response;
    response = await dio.post('/auth/register-user', data: {
      "email": email,
      "full_name": fullName,
      "password": password,
      "phone_number": phoneNumber,
    });

    if (response.statusCode != 200) {
      throw Exception("Error in communicating with server");
    }

    JWT_TOKEN_DATA().accessToken = response.data["access_token"];
    JWT_TOKEN_DATA().refreshToken = response.data["refresh_token"];

  }

  Future<void> login_user(String email, String password) async {
    Response response;
    try {
      response = await dio.post('/auth/login', data: {
        "email": email,
        "password": password,
      });

      if (response.data['role'] != 2) {
        throw Exception("You are not allowed to login from this application");
      }

      JWT_TOKEN_DATA().accessToken = response.data["access_token"];
      JWT_TOKEN_DATA().refreshToken = response.data["refresh_token"];

    } catch(e){
      if (e is DioError) {
        throw Exception(e.response?.data['msg']);
      }
      if (e is Exception) {
        throw Exception(e.toString());
      }
    }
  }

}
