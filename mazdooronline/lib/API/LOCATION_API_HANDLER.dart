import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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

  Future<LatLng> get_labor_location(int labor_id) async {

    try {
      Response response;
      response = await dio.get('/location/get-location-by-user-id/$labor_id',
        options: Options(headers: JWT_TOKEN_DATA().getAccessHeader()
        ),
      );
      return LatLng(response.data["latitude"], response.data["longitude"]);

    } catch (e) {
      if (e is DioError) {
        throw Exception(e.response?.data['msg']);
      }
      return LatLng(12.0495, 12.0495);
    }
  }

}