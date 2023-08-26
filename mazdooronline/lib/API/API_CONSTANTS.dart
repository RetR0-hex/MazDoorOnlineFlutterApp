import 'package:flutter_config/flutter_config.dart';

class APIConstants {
  final String baseURL = FlutterConfig.get('BASE_API_URL');
  static final APIConstants _singleton = APIConstants._internal();

  factory APIConstants() {
    return _singleton;
  }
  APIConstants._internal();
}
