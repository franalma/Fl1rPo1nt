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
import 'package:app/ui/elements/FlirtPoint.dart';
import 'package:app/ui/map_explorer/MapExplorerPage.dart';
import 'package:app/ui/utils/CommonUtils.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:app/ui/utils/location.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FlirtListPage extends StatefulWidget {
  final Location _location;

  final int _minAge;
  final int _maxAge;
  final SexAlternative _sexAlternative;
  final RelationShip _relationShip;
  final Gender _genderInterest;
  

  FlirtListPage(this._location, this._minAge, this._maxAge,
      this._sexAlternative, this._relationShip, this._genderInterest);

  @override
  State<FlirtListPage> createState() {
    return _FlirtListState();
  }
}

class _FlirtListState extends State<FlirtListPage> {
  final User _user = Session.user;

  late List<NearByFlirt> _nearbyFlirts = [];
  bool _isLoading = true;
  int _skip = 0;
  int pageSize = 10; 
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _fetchFromHost();    
    _skip = pageSize; 
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            flexibleSpace: FlexibleAppBar(),
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  NavigatorApp.pop(context);
                }),
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
                  Icons.skip_previous_rounded,
                ),
                onPressed: () {
                  if (_skip >= pageSize) {
                    _skip = _skip - pageSize;
                    _fetchFromHost();
                  }
                  print("---skip $_skip");
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.skip_next_rounded,
                ),
                onPressed: () {
                  _skip = _skip + pageSize; 
                   _fetchFromHost();
                  
                  print("---skip $_skip");
                },
              ),
            ]),
        body: _isLoading ? AlertDialogs().buildLoading() : _buildList());
    // body: _buildList());
  }

  Color getSexAlternativeColor(SexAlternative sexAlternative) {
    return Color(CommonUtils.colorToInt(sexAlternative.color));
  }

  Color getRelationshipColor(RelationShip relationShip) {
    return Color(CommonUtils.colorToInt(relationShip.color));
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
                  leading: SizedBox(
                    width: 80, // Set equal width
                    height: 80, // Set equal height
                    child: ClipRRect(
                      child: Image.network(
                        'https://via.placeholder.com/150', // Replace with your image URL
                        fit: BoxFit.cover, // Ensures the image covers the box
                      ),
                    ),
                  ),
                  trailing: SizedBox(
                    child: Column(
                      children: [
                        FlirtPoint().build(
                          50,
                          50,
                          100,
                          getSexAlternativeColor(
                              _nearbyFlirts[index].sexAlternative!),
                          getRelationshipColor(
                              _nearbyFlirts[index].relationShip!),
                        ),
                      ],
                    ),
                  ),
                  title: Text(
                    _nearbyFlirts[index].name!,
                    style: const TextStyle(fontSize: 20),
                  ),
                  subtitle: Align(
                    alignment: Alignment.bottomLeft,
                    child: Column(
                      children: [
                        Text("Edad ${_nearbyFlirts[index].age!.toString()}"),
                        Text(
                            " ${(_nearbyFlirts[index].distance! / 1000).toInt().toString()} Kms"),
                      ],
                    ),
                  )),
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
              pageSize,
              true)
          .then((value) {
        if (value.errorCode!.code == HostErrorCodesValue.NoError.code) {
          if (value.flirts != null && value.flirts!.isNotEmpty) {
            _nearbyFlirts = (value.flirts!);            
          }else{
            _skip = _skip - pageSize; 
          }

         
        }else{
            _skip = _skip - pageSize; 
        }
         setState(() {
            _isLoading = false;
          });
      });
    } catch (error) {}
    
  }
}
