import 'package:app/app_localizations.dart';
import 'package:app/model/session.dart';
import 'package:app/ui/elements/AppDrawerMenu.dart';
import 'package:app/ui/utils/location.dart';
import 'package:app/ui/utils/toast_message.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AppDrawerMenu().getDrawer(context),
        appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.translate('app_name'))),
        body: Center(
          child: _isEnabled
              ? _buildEnabledFlirtPanel()
              : _buildDisabledFlirtPanel(),
        ));
  }

  Widget _buildDisabledFlirtPanel() {
    return Column(
      children: [
        Expanded(
          child: Container(
            color: const Color.fromARGB(255, 243, 243, 244),
          ),
        ),
        Expanded(
          child: Container(
             color: const Color.fromARGB(255, 243, 243, 244),
          ),
        ),
        Positioned(
          top: 50, // Ajusta la posición del botón en la primera parte
          left: 20,
          child: FloatingActionButton(
            onPressed: () {
              _onStartFlirt();
            },
            child: const Text("Dale!"),
          ),
        ),
      ],
    );
  }

  Widget _buildEnabledFlirtPanel() {
    return Column(
      children: [
        Expanded(
          child: Container(
            color: Color.fromARGB(255, 240, 243, 33),
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.green,
          ),
        ),
        Positioned(
          top: 50, // Ajusta la posición del botón en la primera parte
          left: 20,
          child: FloatingActionButton(
            onPressed: () {
              _onStopFlirt();
            },
            child: const Text("Parar!"),
          ),
        ),
      ],
    );
  }

  void onErrorLocationHandler(String message) {
    FlutterToast().showToast(message);
  }

  void _onStartFlirt() async {
    setState(() {
      _isEnabled=true; 
    });
    LocationHandler handler = LocationHandler(this.onErrorLocationHandler);
    Location location = await handler.getCurrentLocation();
    print("location lat: ${location.lat}, ${location.lon}");
    Session.user.latitude = location.lat; 
    Session.user.longitude = location.lon; 
  }


  void _onStopFlirt() async {    
    
    setState(() {
      _isEnabled = false; 
    });
  }


}
