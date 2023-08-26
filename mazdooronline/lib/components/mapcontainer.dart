import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:mazdooronline/models/location.dart';
import 'package:location/location.dart' as loc;

import '../API/LOCATION_API_HANDLER.dart';
import '../location/location_handler.dart';

class MapsCont extends StatefulWidget {
  @override
  State<MapsCont> createState() => _MapsCont();
}

class _MapsCont extends State<MapsCont> {
  Completer<GoogleMapController> _controller = Completer();

  static const LatLng _center = LatLng(31.59055926426574, 74.31668325117184);


  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: GoogleMap(
        mapType: MapType.terrain,
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
      ),
    );
  }
}

class CenteredMapContainer extends StatefulWidget {

  late LatLng user_location;

  CenteredMapContainer({required LatLng user_location}) {
    this.user_location = user_location;
  }

  @override
  State<CenteredMapContainer> createState() => _CenteredMapContainerState();
}

class _CenteredMapContainerState extends State<CenteredMapContainer> {

  late CameraPosition initialCameraPosition;
  Set<Marker> _markers = Set<Marker>(); // for my drawn routes on the map

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialCameraPosition = CameraPosition(
        zoom: 16, tilt: 80, bearing: 30, target: widget.user_location);
  }

  final Completer<GoogleMapController> _controller = Completer();

  void showPinsOnMap() {
    _markers.add(Marker(
      markerId: MarkerId('client_location'),
      position: widget.user_location,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      // icon: BitmapDescriptor.,
      infoWindow: InfoWindow(
        title: 'User Location',
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GoogleMap(
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
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
      ),
    );
  }
}

class NavigationMapContainer extends StatefulWidget {
  late LatLng client_location;
  late LatLng worker_location;
  late int labor_id;
  NavigationMapContainer(
      {required LatLng client_location_, required LatLng worker_location_, required int labor_id}) {
    client_location = client_location_;
    worker_location = worker_location_;
    this.labor_id = labor_id;
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
  LocationApiHandler api = LocationApiHandler();
  Timer? timer;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    polylinePoints = PolylinePoints();
    initialCameraPosition = CameraPosition(
        zoom: 16, tilt: 80, bearing: 30, target: widget.worker_location);
    timer = Timer.periodic(Duration(seconds: 60), (Timer t) => updateLaborLocation());
  }

  void updateLaborLocation() async {
   LatLng location_labor = await LocationApiHandler().get_labor_location(widget.labor_id);
   widget.worker_location = location_labor;
   updateBackendlocation();
   updatePinOnMap();
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
      target: widget.worker_location
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        cPosition)); // do this inside the setState() so Flutter gets notified
    // that a widget update is due
    setState(() {
      // updated position
      var pinPosition = widget.worker_location;

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
    await updateLocationData();
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


