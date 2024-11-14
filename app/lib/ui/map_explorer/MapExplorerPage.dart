import 'dart:convert';

import 'package:app/comms/model/request/HostGetPeopleArroundRequest.dart';
import 'package:app/model/User.dart';
import 'package:app/model/Session.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:app/ui/utils/location.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapExplorerController extends StatefulWidget {
  LatLng _location;

  MapExplorerController(this._location);

  @override
  State<MapExplorerController> createState() {
    return _MapExplorerController();
  }
}

class _MapExplorerController extends State<MapExplorerController> {
  @override
  late GoogleMapController mapController;
  Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    _fetchFromHost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: widget._location,
          zoom: 11.0,
        ),
        myLocationEnabled: true,
        markers: _markers,
      ),
    );
  }

  void _addMarker(LatLng position, String markerId) {
    final marker = Marker(
      markerId: MarkerId(markerId),
      position: position,
      infoWindow: InfoWindow(title: markerId),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    
    );
      setState(() {
        _markers.add(marker);
      });
    
  }

  Future<void> _fetchFromHost() async {
    Log.d("Starts");
    User user = Session.user;
    Location location = Session.location!;
    HostGetPeopleArroundRequest()
        .run(location.lat,location.lon, 5000)
        .then((value) {
      for (var item in value) {      
        Log.d("lat: ${item.latitude}  lon:${item.longitude}");
        _addMarker(LatLng(item.latitude, item.longitude), item.userId.toString());
      }
    });

  
  }
}
