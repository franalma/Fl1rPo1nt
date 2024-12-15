import 'package:app/comms/model/request/flirt/HostGetPeopleArroundRequest.dart';
import 'package:app/model/Gender.dart';
import 'package:app/model/HostErrorCode.dart';
import 'package:app/model/NearByFlirt.dart';
import 'package:app/model/Session.dart';
import 'package:app/model/User.dart';
import 'package:app/model/UserInterest.dart';
import 'package:app/ui/NavigatorApp.dart';
import 'package:app/ui/elements/AlertDialogs.dart';
import 'package:app/ui/elements/FlexibleAppBar.dart';
import 'package:app/ui/map_explorer/MapExplorerPage.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:app/ui/utils/location.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FlirtListPage extends StatefulWidget {
  final Location _location;

  int _minAge;
  int _maxAge;
  SexAlternative _sexAlternative;
  RelationShip _relationShip;
  Gender _genderInterest;

  FlirtListPage(this._location, this._minAge, this._maxAge,
      this._sexAlternative, this._relationShip, this._genderInterest);

  @override
  State<FlirtListPage> createState() {
    return _FlirtListState();
  }
}

class _FlirtListState extends State<FlirtListPage> {
  final User _user = Session.user;
  bool _filtersEnabled = true;
  late List<NearByFlirt> _nearbyFlirts = [];
  bool _isLoading = true;
  int _skip = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _fetchFromHost();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            flexibleSpace: FlexibleAppBar(),
            leading: IconButton(
                icon: const Icon(Icons.arrow_back), onPressed: () {}),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.map,
                ),
                onPressed: () {
                  LatLng latLng =
                      LatLng(widget._location.lat, widget._location.lon);
                  NavigatorApp.push(
                      MapExplorerController(
                          latLng,
                          widget._minAge,
                          widget._maxAge,
                          widget._sexAlternative,
                          widget._relationShip,
                          widget._genderInterest),
                      context);
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.backspace_sharp,
                ),
                onPressed: () {
                  _skip = _skip - 10;
                  _fetchFromHost();
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.forward,
                ),
                onPressed: () {
                  _skip = _skip + 10;
                  _fetchFromHost();
                },
              ),
            ]),
        // body: _isLoading ? AlertDialogs().buildLoading() : _buildList());
        body: _buildList());
  }

  Widget _buildList() {
    Log.d("Starts _buildList");

    return ListView.builder(
        controller: _scrollController,
        itemCount: _nearbyFlirts.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                title: Text(_nearbyFlirts[index].name!),
                subtitle: Text(_nearbyFlirts[index].distance!.toString()),
              ),
              const Divider(),
            ],
          );
        });
  }

  Future<void> _fetchFromHost() async {
    Log.d("Starts");

    try {
      setState(() {
        _isLoading = true;
      });

      HostGetPeopleArroundRequest()
          .run(
              Session.currentFlirt!.id,
              _user.userId,
              widget._sexAlternative,
              widget._relationShip,
              widget._genderInterest,
              _user.gender,
              widget._minAge,
              widget._maxAge,
              widget._location.lat,
              widget._location.lon,
              _user.radioVisibility,
              _skip,
              10,
              _filtersEnabled)
          .then((value) {
        if (value.errorCode!.code == HostErrorCodesValue.NoError.code) {
          if (value.flirts != null && value.flirts!.isNotEmpty) {
            _nearbyFlirts = (value.flirts!);
          }

          setState(() {
            _isLoading = false;
          });
        }
      });
    } catch (error) {}
  }
}
