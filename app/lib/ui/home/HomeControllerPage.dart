import 'package:app/app_localizations.dart';
import 'package:app/model/Session.dart';
import 'package:app/ui/NavigatorApp.dart';
import 'package:app/ui/elements/Gradient1.dart';
import 'package:app/ui/home/home.dart';
import 'package:app/ui/map_explorer/MapExplorerPage.dart';
import 'package:app/ui/user_profile/UserProfilePage.dart';
import 'package:app/ui/utils/location.dart';
import 'package:app/ui/utils/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home2 extends StatefulWidget {
  @override
  _Home2 createState() => _Home2();
}

class _Home2 extends State<Home2> {
  int _currentIndex = 0;
  // List of widgets to display for each tab
  final List<Widget> _screens = [
    Center(child: Home()),
    const Center(child: Text('Search Screen')),
    const Center(child: Text('Profile Screen')),
    Center(child: Container()),
    Center(child: UserProfilePage()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _screens[_currentIndex],
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                  gradient: Gradient1().get([
                    Colors.green,
                    Colors.orange,
                    Colors.purple,
                    Colors.red,
                    Colors.blue,
                  ])),
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: Icon(Icons.home,
                        size: 30,
                        color: _currentIndex == 0
                            ? Colors.white
                            : const Color.fromARGB(255, 18, 17, 17)),
                    onPressed: () => setState(() => _currentIndex = 0),
                  ),
                  IconButton(
                    icon: Icon(Icons.search,
                        size: 30,
                        color: _currentIndex == 1
                            ? Colors.white
                            : const Color.fromARGB(255, 18, 17, 17)),
                    onPressed: () => setState(() => _currentIndex = 1),
                  ),
                  IconButton(
                    icon: Icon(Icons.map,
                        size: 30,
                        color: _currentIndex == 2
                            ? Colors.white
                            : const Color.fromARGB(255, 18, 17, 17)),
                    onPressed: () => setState(() {
                      _currentIndex = 2;
                      launchMapExplorer(context);
                    }),
                  ),
                  IconButton(
                      icon: Icon(Icons.message,
                          size: 30,
                          color: _currentIndex == 3
                              ? Colors.white
                              : const Color.fromARGB(255, 18, 17, 17)),
                      onPressed: () => setState(() {
                            _currentIndex = 3;
                          })),
                  IconButton(
                      icon: Icon(Icons.person,
                          size: 30,
                          color: _currentIndex == 4
                              ? Colors.white
                              : const Color.fromARGB(255, 18, 17, 17)),
                      onPressed: () {
                        setState(() => _currentIndex = 4);
                      }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onErrorLocation(String message) {}
  void launchMapExplorer(BuildContext context) async {
    if (Session.user.isFlirting) {
      LocationHandler(onErrorLocation).getCurrentLocation().then((value) {
        LatLng coordinates = LatLng(value.lat, value.lon);

        NavigatorApp.push(MapExplorerController(coordinates), context);
      });
    } else {
      FlutterToast().showToast(AppLocalizations.of(context)!.translate("map_start_required"));
    }
  }
}
