import 'dart:async';
import 'package:app/comms/model/request/flirt/HostUpdateFlirtLocationByFlirtIdRequest.dart';
import 'package:app/model/Flirt.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:app/ui/utils/location.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  Timer? _timer;

  Flirt _flirt;
  final _locationInterval = 300;

  LocationService(this._flirt);

  void startSendingLocation() {
    Log.d("Statts startSendingLocation");
    _timer?.cancel();
    _timer =
        Timer.periodic(Duration(seconds: _locationInterval), (timer) async {
      try {
        Position position = await getCurrentLocation();
        Location location = Location(position.latitude, position.longitude);
        _sendLocationToServer(location);
      } catch (e) {
        Log.d("Error while sending location: $e");
      }
    });
  }

  // Detener el envío periódico
  void stopSendingLocation() {
    Log.d("Stopping location service");
    _timer?.cancel();
  }

  // Obtener la ubicación actual
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  // Enviar ubicación al servidor
  Future<void> _sendLocationToServer(Location locationData) async {
    try {
      _flirt.location = locationData;
      await HostUpdateFlirtLocationByFlirtIdRequest().run(_flirt);
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
  }
}
