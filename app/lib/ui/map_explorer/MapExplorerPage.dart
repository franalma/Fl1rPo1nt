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
      icon: BitmapDescriptor.defaultMarker,
    );

    setState(() {
      _markers.add(marker);
    });
  }
}
