import 'package:geolocator/geolocator.dart';

class DistanceCalculator {
  static double calculateDistanceinKm(double lat1, double long1, double lat2,
      double long2) {
    double distanceInMeters = Geolocator.distanceBetween(
        lat1, long1, lat2, long2);
    return (distanceInMeters / 1000).roundToDouble();
  }
}