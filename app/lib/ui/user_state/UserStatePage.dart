

import 'package:app/app_localizations.dart';
import 'package:app/comms/model/request/HostGetAllSexRelationshipRequest.dart';
import 'package:app/comms/model/request/HostUpdateUserInterestRequest.dart';
import 'package:app/model/Session.dart';
import 'package:app/model/User.dart';
import 'package:app/model/UserInterest.dart';
import 'package:app/ui/NavigatorApp.dart';
import 'package:app/ui/utils/CommonUtils.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:app/ui/utils/toast_message.dart';
import 'package:flutter/material.dart';

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
  SexAlternative? sexAlternativeSelected;
  RelationShip? relationshipSelected;
  User user = Session.user;

  Color? sexAlternativeColor;
  Color? relationshipColor;

  @override
  void initState() {
    super.initState();
    _fetchFromHost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(       
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.translate('app_name')),
          actions: [
            IconButton(
                onPressed: () => _onSaveData(), icon: const Icon(Icons.save))
          ],
        ),
        body: _isLoading
            ? _buildLoading()
            : Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Centers vertically
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Centers horizontally
                children: [_buildSexualInterest(), _buildRelationship()],
              ));
  }

  Widget _buildSexualInterest() {
    return Expanded(
      child: Column(
        children: [
          DropdownButton<String>(
            value: sexAlternativeSelected?.name,
            hint: Text("¿Cómo te identificas?"),
            onChanged: (String? newValue) {
              setState(() {
                sexAlternativeSelected =
                    sexAlternatives.firstWhere((e) => e.name == newValue);
                sexAlternativeColor = Color(
                    CommonUtils.colorToInt(sexAlternativeSelected!.color));
              });
            },
            items: sexAlternatives.map<DropdownMenuItem<String>>((value) {
              return DropdownMenuItem<String>(
                  value: value.name, child: Text(value.name));
            }).toList(),
          ),
          Expanded(
            child: Container(color: sexAlternativeColor),
          ),
        ],
      ),
    );
  }

  Widget _buildRelationship() {
    return Expanded(
      child: Column(
        children: [
          DropdownButton<String>(
            value: relationshipSelected?.value,
            hint: Text("¿Qué relación que buscas?"),
            onChanged: (String? newValue) {
              setState(() {
                relationshipSelected =
                    relationship.firstWhere((e) => e.value == newValue);
                relationshipColor =
                    Color(CommonUtils.colorToInt(relationshipSelected!.color));
              });
            },
            items: relationship.map<DropdownMenuItem<String>>((value) {
              return DropdownMenuItem<String>(
                  value: value.value, child: Text(value.value));
            }).toList(),
          ),
          Expanded(
            child: Container(color: relationshipColor),
          ),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  Future<void> _fetchFromHost() async {
    Log.d("Starts _fetchFromHost");
    HostGetAllSexRelationshipRequest().run().then((value) {
      relationship = value.relationships;
      sexAlternatives = value.sexAlternatives;
      try {
        sexAlternativeSelected = user.sexAlternatives;
        relationshipSelected = user.relationShip;
        if (sexAlternativeSelected != null && sexAlternativeSelected!.color.isNotEmpty) {
          print("---from host sexAlt: ${sexAlternativeSelected!.name} color: ${sexAlternativeSelected!.color}");
          sexAlternativeColor =
              Color(CommonUtils.colorToInt(sexAlternativeSelected!.color));
        }else{
          sexAlternativeSelected = sexAlternatives[0];
        }

        if (relationshipSelected != null && relationshipSelected!.color.isNotEmpty) {
          relationshipColor =
              Color(CommonUtils.colorToInt(relationshipSelected!.color));
        }else{
          relationshipSelected = relationship[0];
        }
      } catch (error) {
        Log.d(error.toString());
      }
      // relationship
      //     .map((item) => print("${item.value} + ${item.color}"))
      //     .toList();
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> _onSaveData() async {
    if (relationshipSelected != null && sexAlternativeSelected != null) {
      HostUpdateUserInterestRequest()
          .run(user.userId, relationshipSelected!, sexAlternativeSelected!)
          .then((value) {
        if (!value) {
          FlutterToast()
              .showToast("No ha sido posible actualizar tus preferencias");
        }else{
          user.relationShip = relationshipSelected!; 
          user.sexAlternatives = sexAlternativeSelected!;
          NavigatorApp.pop(context);
        }
      });
    } else {
      FlutterToast().showToast("Selecciona todos los valores");
    }
  }
}
