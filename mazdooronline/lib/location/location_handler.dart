import 'package:geolocator/geolocator.dart';
import '/API/LOCATION_API_HANDLER.dart';
import '/models/location.dart';


class LocationHandler {

  Future<void> getCurrentLocation() async {
    try {
      await getPermission();
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);

      LocationData().update_location(position.latitude, position.longitude);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> getPermission() async {

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
  }

}

Future<void> updateLocationData() async {
  await LocationHandler().getCurrentLocation();
  LocationApiHandler api = LocationApiHandler();
  await api.update_location(LocationData().latitude, LocationData().longitude);
}