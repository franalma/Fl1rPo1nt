import 'package:app/app_localizations.dart';

import 'package:app/comms/model/request/user/profile/HostUpdateUserInterestRequest.dart';
import 'package:app/model/Gender.dart';
import 'package:app/model/Session.dart';
import 'package:app/model/User.dart';
import 'package:app/model/UserInterest.dart';
import 'package:app/ui/NavigatorApp.dart';
import 'package:app/ui/elements/FlexibleAppBar.dart';
import 'package:app/ui/user_profile/UserGenderSelection.dart';
import 'package:app/ui/user_state/SelectRelationshipOptionPage.dart';
import 'package:app/ui/user_state/SelectSexOptionPage.dart';
import 'package:app/ui/utils/CommonUtils.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:app/ui/utils/toast_message.dart';
import 'package:flutter/material.dart';

import '../../comms/model/request/fix_values/HostGetAllSexRelationshipRequest.dart';

class UserStatePage extends StatefulWidget {
  @override
  State<UserStatePage> createState() {
    return _UserStatePage();
  }
}

class _UserStatePage extends State<UserStatePage> {
  List<SexAlternative> sexAlternatives = [];
  List<RelationShip> relationship = [];

  bool _isLoading = true;

  late RelationShip _relationshipSelected;
  late SexAlternative _sexAlternativeSelected;
  late Gender _genderSelected;
  User user = Session.user;

  @override
  void initState() {
    _sexAlternativeSelected = user.sexAlternatives;
    _relationshipSelected = user.relationShip;
    _genderSelected = user.genderInterest;

    _fetchFromHost();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: FlexibleAppBar(),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_outlined),
            onPressed: () {
              _onSaveData();
            },
          ),
        ),
        body: _isLoading ? _buildLoading() : _buildBody());
  }

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
    if (_genderSelected?.color != null) {
      color = Color(CommonUtils.colorToInt(_genderSelected!.color!));
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

  Widget _buildBody() {
    return ListView(children: [
      _buildSexOrientation(),
      const Divider(),
      _buidRelationShip(),
      const Divider(),
      _buildLookingForGender()
    ]);
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  Future<void> _fetchFromHost() async {
    Log.d("Starts _fetchFromHost");
    HostGetAllSexRelationshipRequest().run().then((value) {
      relationship = value.relationships;
      sexAlternatives = value.sexAlternatives;
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> _onSaveData() async {
    HostUpdateUserInterestRequest()
        .run(user.userId, _relationshipSelected, _sexAlternativeSelected,
            _genderSelected)
        .then((value) {
      if (!value) {
        FlutterToast()
            .showToast("No ha sido posible actualizar tus preferencias");
      } else {
        user.relationShip = _relationshipSelected;
        user.sexAlternatives = _sexAlternativeSelected;
        user.genderInterest = _genderSelected;
      }
      NavigatorApp.pop(context);
    });
  }
}
