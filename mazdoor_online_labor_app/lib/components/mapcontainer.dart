import 'dart:typed_data';
import 'package:flutter_config/flutter_config.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:mazdoor_online_labor_app/API/LOCATION_API_HANDLER.dart';
import 'package:provider/provider.dart';
import '/models/location.dart';
import 'package:location/location.dart' as loc;

class MapsCont extends StatefulWidget {
  late LatLng center;

  MapsCont({required LatLng cords}) {
    center = cords;
  }

  @override
  State<MapsCont> createState() => _MapsCont();
}

class _MapsCont extends State<MapsCont> {
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    var mapController = controller;

    final marker = Marker(
      markerId: MarkerId('client_location'),
      position: widget.center,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      // icon: BitmapDescriptor.,
      infoWindow: InfoWindow(
        title: 'Client Location',
      ),
    );

    setState(() {
      markers[MarkerId('Client_Location')] = marker;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.35,
      child: GoogleMap(
        mapType: MapType.normal,
        zoomControlsEnabled: true,
        mapToolbarEnabled: true,
        zoomGesturesEnabled: true,
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: widget.center,
          zoom: 15.0,
        ),
        markers: markers.values.toSet(),
      ),
    );
  }
}

class NavigationMapContainer extends StatefulWidget {
  late LatLng client_location;
  late LatLng worker_location;
  NavigationMapContainer(
      {required LatLng client_location_, required LatLng worker_location_}) {
    client_location = client_location_;
    worker_location = worker_location_;
  }

  @override
  State<NavigationMapContainer> createState() => _NavigationMapContainer();
}

class _NavigationMapContainer extends State<NavigationMapContainer> {
  Set<Marker> _markers = Set<Marker>(); // for my drawn routes on the map
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  late PolylinePoints polylinePoints;
  late CameraPosition initialCameraPosition;
  late loc.LocationData currentLocation;
  LocationApiHandler api = LocationApiHandler();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    polylinePoints = PolylinePoints();
    initialCameraPosition = CameraPosition(
        zoom: 16, tilt: 80, bearing: 30, target: widget.worker_location);

    loc.onLocationChanged().listen((loc.LocationData cloc){
      // cLoc contains the lat and long of the
      // current user's position in real time,
      // so we're holding on to it
      currentLocation = cloc;
      updateBackendlocation();
      updatePinOnMap();
    });
  }

  final Completer<GoogleMapController> _controller = Completer();

  void showPinsOnMap() {
    _markers.add(Marker(
      markerId: MarkerId('client_location'),
      position: widget.client_location,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      // icon: BitmapDescriptor.,
      infoWindow: InfoWindow(
        title: 'Client Location',
      ),
    ));

    _markers.add(Marker(
      markerId: MarkerId('worker_location'),
      position: widget.worker_location,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      // icon: BitmapDescriptor.,
      infoWindow: const InfoWindow(
        title: 'Worker Location',
      ),
    ));

    setPolylines();
  }

  void setPolylines() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        FlutterConfig.get("GOOGLE_MAPS_API_KEY"),
        PointLatLng(
            widget.worker_location.latitude, widget.worker_location.longitude),
        PointLatLng(
            widget.client_location.latitude, widget.client_location.longitude));

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }

      setState(() {
        _polylines.add(Polyline(
            width: 5, // set the width of the polylines
            polylineId: PolylineId('poly'),
            color: Color.fromARGB(255, 40, 122, 198),
            points: polylineCoordinates));
      });
    }
  }

  void updatePinOnMap() async {
    CameraPosition cPosition = CameraPosition(
      zoom: 16,
      tilt: 80,
      bearing: 30,
      target: LatLng(currentLocation.latitude as double, currentLocation.longitude as double),
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        cPosition)); // do this inside the setState() so Flutter gets notified
    // that a widget update is due
    setState(() {
      // updated position
      var pinPosition = LatLng(
          (currentLocation.latitude) as double, (currentLocation.longitude) as double);

      // the trick is to remove the marker (by id)
      // and add it again at the updated location
      _markers.removeWhere((m) => m.markerId.value == "worker_location");
      _markers.add(Marker(
        markerId: MarkerId("worker_location"),
        position: pinPosition, // updated position
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ));
    });
  }

  void updateBackendlocation() async {
    await api.update_location(
        currentLocation.latitude as double,
        currentLocation.longitude as double);
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: GoogleMap(
        myLocationEnabled: false,
        myLocationButtonEnabled: false,
        mapType: MapType.normal,
        zoomControlsEnabled: false,
        mapToolbarEnabled: true,
        zoomGesturesEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          showPinsOnMap();
        },
        initialCameraPosition: initialCameraPosition,
        markers: _markers,
        polylines: _polylines,
      ),
    );
  }
}
