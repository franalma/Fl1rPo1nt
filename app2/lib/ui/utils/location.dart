import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Location{
  double lat;  
  double lon; 
  Location(this.lat, this.lon);
}

class LocationHandler {

  void Function(String message)onError; 

   

  LocationHandler(this.onError);

  // Método para obtener la ubicación actual
  Future<Location> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verificar si los servicios de ubicación están habilitados
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      onError("Los servicios de ubicación están deshabilitados");
    
      return Location(0,0);
    }

    // Verificar si se tienen los permisos adecuados
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        onError("Los permisos de ubicación han sido denegados");    
        return Location(0,0);
      }
    }

    if (permission == LocationPermission.deniedForever) {
       onError("Los permisos de ubicación han sido denegados permanentemente.");        
      return Location(0,0);
    }

    // Obtener la ubicación actual
    Position position = await Geolocator.getCurrentPosition();
    return Location(position.latitude, position.longitude);
    
  }
}