import 'package:app/comms/model/request/fix_values/HostGetAllSexRelationshipRequest.dart';
import 'package:app/model/Gender.dart';
import 'package:app/model/Session.dart';
import 'package:app/model/User.dart';
import 'package:app/model/UserInterest.dart';
import 'package:app/ui/NavigatorApp.dart';
import 'package:app/ui/elements/DefaultModalDialog.dart';
import 'package:app/ui/elements/FlexibleAppBar.dart';
import 'package:app/ui/elements/my_button.dart';
import 'package:app/ui/map_explorer/MapExplorerPage.dart';
import 'package:app/ui/user_profile/UserGenderSelection.dart';
import 'package:app/ui/user_state/SelectRelationshipOptionPage.dart';
import 'package:app/ui/user_state/SelectSexOptionPage.dart';
import 'package:app/ui/utils/CommonUtils.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapFilterCriterialsPage extends StatefulWidget {
  @override
  State<MapFilterCriterialsPage> createState() {
    return _MapFilterCriterialsState();
  }
}

class _MapFilterCriterialsState extends State<MapFilterCriterialsPage> {
  List<SexAlternative> sexAlternatives = [];
  List<RelationShip> relationship = [];
  bool _isLoading = true;
  late RelationShip _relationshipSelected;
  late SexAlternative _sexAlternativeSelected;
  late Gender _genderSelected;
  User user = Session.user;
  final List<int> _ages = List.generate(82, (index) => index + 18);
  late int _selectedMinAge;
  late int _selectedMaxAge;

  Color _getSexAlternativeColor() {
    Color color = Colors.white;
    if (_sexAlternativeSelected.color.isNotEmpty) {
      color = Color(CommonUtils.colorToInt(_sexAlternativeSelected.color));
    }
    return color;
  }

  Color _getRelationshipAlternativeColor() {
    Color color = Colors.white;
    if (_relationshipSelected.color.isNotEmpty) {
      color = Color(CommonUtils.colorToInt(_relationshipSelected.color));
    }
    return color;
  }

  Color _getGenderColor() {
    Color color = Colors.white;
    if (_genderSelected.color != null) {
      color = Color(CommonUtils.colorToInt(_genderSelected.color!));
    }
    return color;
  }

  Widget _buildSexOrientation() {
    return ListTile(
      leading: SizedBox(
        height: 50,
        width: 50,
        child: Container(color: _getSexAlternativeColor()),
      ),
      trailing: const Icon(Icons.arrow_forward_ios_sharp),
      title: const Text("Orientación sexual"),
      subtitle: Text(_sexAlternativeSelected.name),
      onTap: () async {
        var selected = await NavigatorApp.pushAndWait(
            SelectSexOptionPage(sexAlternatives), context) as SexAlternative;
        setState(() {
          _sexAlternativeSelected = selected;
        });
        Log.d("value selected: $selected");
      },
    );
  }

  Widget _buidRelationShip() {
    return ListTile(
      leading: SizedBox(
        height: 50,
        width: 50,
        child: Container(color: _getRelationshipAlternativeColor()),
      ),
      trailing: const Icon(Icons.arrow_forward_ios_sharp),
      title: const Text("Relación que buscas"),
      subtitle: Text(_relationshipSelected.value),
      onTap: () async {
        var selected = await NavigatorApp.pushAndWait(
                SelectRelationshipOptionPage(relationship), context)
            as RelationShip;
        setState(() {
          _relationshipSelected = selected;
        });
        Log.d("value selected: $selected");
      },
    );
  }

  Widget _buildLookingForGender() {
    return ListTile(
        leading: SizedBox(
          height: 50,
          width: 50,
          child: Container(color: _getGenderColor()),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_sharp),
        title: const Text("Género que buscas"),
        subtitle: Text(_genderSelected.name ?? ""),
        onTap: () async {
          var selected =
              await NavigatorApp.pushAndWait(UserGenderSelection(), context)
                  as Gender;
          setState(() {
            _genderSelected = selected;
          });
        });
  }

  Future<void> _fetchFromHost() async {
    Log.d("Starts _fetchFromHost");
    HostGetAllSexRelationshipRequest().run().then((value) async {
      relationship = value.relationships;
      sexAlternatives = value.sexAlternatives;
      setState(() {
        _isLoading = false;
      });
    });
  }

  Widget _buildGoSearch() {
    return MyButton(
        onTap: () {
          if (Session.location != null) {
            var location = LatLng(Session.location!.lat, Session.location!.lon);
            NavigatorApp.push(
                MapExplorerController(
                    location,
                    _selectedMinAge,
                    _selectedMaxAge,
                    _sexAlternativeSelected,
                    _relationshipSelected,
                    _genderSelected),
                context);
          } else {
            DefaultModalDialog.showErrorDialog(
                context,
                "Debes activar tu ubicación para poder acceder al mapa",
                "Cerrar",
                FontAwesomeIcons.exclamation);
          }
        },
        text: "Buscar");
  }

  Widget _buildLookingFromAge() {
    return ListTile(
      title: Text("Edad mínima"),
      leading: Icon(Icons.apps_outage_sharp),
      trailing: DropdownButton<int>(
        value: _selectedMinAge,
        hint: Text("Select"),
        items: _ages.map((age) {
          return DropdownMenuItem<int>(
            value: age,
            child: Text(age.toString()),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedMinAge = value!;
          });
        },
      ),
    );
  }

  Widget _buildLookingToAge() {
    return ListTile(
      title: Text("Edad máxima"),
      leading: Icon(Icons.apps_outage_sharp),
      trailing: DropdownButton<int>(
        value: _selectedMaxAge,
        items: _ages.map((age) {
          return DropdownMenuItem<int>(
            value: age,
            child: Text(age.toString()),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedMaxAge = value!;
          });
        },
      ),
    );
  }

  Widget _buildBody() {
    return ListView(children: [
      _buildSexOrientation(),
      const Divider(),
      _buidRelationShip(),
      const Divider(),
      _buildLookingForGender(),
      const Divider(),
      _buildLookingFromAge(),
      const Divider(),
      _buildLookingToAge(),
      const Divider(),
      SizedBox(height: 100),
      _buildGoSearch()
    ]);
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  @override
  void initState() {
    _relationshipSelected = user.relationShip;
    _genderSelected = user.genderInterest;
    _sexAlternativeSelected = user.sexAlternatives;
    _selectedMinAge = _ages[0];
    _selectedMaxAge = _ages[10];
    _fetchFromHost();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(flexibleSpace: FlexibleAppBar()),
        body: _isLoading ? _buildLoading() : _buildBody());
  }
}
