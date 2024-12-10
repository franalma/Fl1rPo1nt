import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:app/comms/model/request/flirt/HostGetPeopleArroundRequest.dart';
import 'package:app/comms/model/request/user/profile/HostGetUserPublicProfile.dart';
import 'package:app/model/HostErrorCode.dart';
import 'package:app/model/NearByFlirt.dart';
import 'package:app/model/Session.dart';
import 'package:app/model/User.dart';
import 'package:app/model/UserPublicProfile.dart';
import 'package:app/ui/NavigatorApp.dart';
import 'package:app/ui/contacts/ContactDetailsPage.dart';
import 'package:app/ui/contacts/ContactDetailsPageFromMap.dart';
import 'package:app/ui/elements/FlexibleAppBar.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:app/ui/utils/location.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapExplorerController extends StatefulWidget {
  final LatLng _location;

  MapExplorerController(this._location);

  @override
  State<MapExplorerController> createState() {
    return _MapExplorerController();
  }
}

class _MapExplorerController extends State<MapExplorerController> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};
  BitmapDescriptor? bitmapDescriptor;
  bool _isShowInfoWindow = false;
  final User _user = Session.user;
  bool _filtersEnabled = true;
  UserPublicProfile? _profile; 
  

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    _fetchFromHost();
    createFontAwesomeIconBitmap(Colors.red, Colors.green).then((value) {
      bitmapDescriptor = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: FlexibleAppBar(),
        actions: [
          Row(
            children: [
              IconButton(
                  onPressed: () {
                     if (_filtersEnabled) {
                        _filtersEnabled = false;
                      } else {
                        _filtersEnabled = true;
                      }
                    setState(() {
                      _fetchFromHost(); 
                    });
                  },
                  icon: Icon(_filtersEnabled ?Icons.filter_alt_off: Icons.filter_alt))
            ],
          )
        ],
      ),
      body: Stack(children: [
        GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: widget._location,
            zoom: 18.0,
          ),
          myLocationEnabled: true,
          markers: _markers,
          onTap: (_) {
            setState(() {
              _isShowInfoWindow = false;
            });
          },
        ),
        _isShowInfoWindow ? showInfoWindow() : Container()
      ]),
    );
  }

  Widget showInfoWindow() {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.4, // Adjust the position
      left: MediaQuery.of(context).size.width * 0.3, // Adjust the position
      child: Column(
        children: [
          Container(
            width: 200,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Column(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(_profile!.profileImage!),
                  radius: 40,
                ),
                const SizedBox(height: 8),
                Text(
                  _profile!.name!,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Container(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 200,
                    
                    child: Row(
                      children: [
                        Text(
                          "40",
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          ",Madrid",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),

                IconButton(
                  onPressed: () {
                    NavigatorApp.push(ContactDetailsPageFromMap(_profile!), context);
                  },
                  icon: Icon(FontAwesomeIcons.heartCircleBolt),
                  color: Colors.red,
                  iconSize: 30,
                )
                // Text('A beautiful city!'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget twoColorsIcon() {
    return const Center(
      child: Stack(
        children: [
          Icon(
            Icons.star,
            size: 100,
            color: Colors.blue,
          ),
          ClipRect(
            child: Align(
              alignment: Alignment.topCenter,
              heightFactor: 0.5, // Show only the top half
              child: Icon(
                Icons.star,
                size: 100,
                color: Colors.purple,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<BitmapDescriptor> createFontAwesomeIconBitmap(
      Color foreground, Color background) async {
    final PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    const Size size = Size(100, 100); // Define the icon size

    // Create a Paint for background (optional, for visibility)
    final Paint paint = Paint()
      ..color = const ui.Color.fromARGB(0, 207, 11, 11);
    canvas.drawRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height), paint);

    // Draw the FontAwesomeIcon widget
    const Icon icon = Icon(
      FontAwesomeIcons.solidCircle,
      size: 80.0, // Icon size
    );
    // var stack = twoColorsIcon();
    // Use a painter to draw the icon
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: String.fromCharCode(icon.icon!.codePoint),
        style: TextStyle(
          fontSize: icon.size,
          fontFamily: icon.icon!.fontFamily,
          package: icon.icon!.fontPackage,
          color: ui.Color.fromARGB(255, 62, 77, 247),
        ),
      ),
    );
    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset((size.width - textPainter.width) / 2,
            (size.height - textPainter.height) / 2));

    // Convert the canvas into an image
    final ui.Image image = await pictureRecorder
        .endRecording()
        .toImage(size.width.toInt(), size.height.toInt());
    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
  }

  Future<void> _addMarker(LatLng position, NearByFlirt flirtNearBy) async {
    final marker = Marker(
        markerId: MarkerId(flirtNearBy.flirtId!),
        position: position,
        onTap: () async {
          HostGetUserPublicProfile().run(flirtNearBy.userId!).then((value) {
            _profile = value.profile;             
            setState(() {
              _isShowInfoWindow = true;
            });
          });
        },
        icon: bitmapDescriptor!);
    setState(() {
      _markers.add(marker);
    });
  }

  Future<void> _fetchFromHost() async {
    Log.d("Starts");
    Location location = Session.location!;
    _markers.clear(); 
    HostGetPeopleArroundRequest()
        .run(
            Session.currentFlirt!.id,
            _user.sexAlternatives,
            _user.relationShip,
            _user.genderInterest,
            location.lat,
            location.lon,
            _user.radioVisibility,
            _filtersEnabled)
        .then((value) {
      if (value.errorCode!.code == HostErrorCodesValue.NoError.code) {
        for (var item in value.flirts!) {
          _addMarker(item.latLng!, item);
        }
      }
    });
  }
}
