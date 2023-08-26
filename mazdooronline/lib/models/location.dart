import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class LocationData with ChangeNotifier {

  static final LocationData _singleton = LocationData._internal();

  late double latitude;
  late double longitude;

  factory LocationData() {
    return _singleton;
  }

  LocationData._internal();

  void update_location(lat, long){
    latitude = lat;
    longitude = long;
    notifyListeners();
  }
}