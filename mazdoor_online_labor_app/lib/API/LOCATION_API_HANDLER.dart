import 'package:dio/dio.dart';
import '../models/login_tokens.dart';
import 'API_HANDLER.dart';

class LocationApiHandler {
  Future<void> update_location(double lat, double long) async {
    Response response;
    response = await dio.put('/location/update_location',
        options: Options(headers: JWT_TOKEN_DATA().getAccessHeader()
        ),
        data: {
          "latitude": lat.toDouble(),
          "longitude": long.toDouble(),
        }
    );

    if (response.statusCode != 200) {
      throw Exception("Error in communicating with server");
    }
  }

}