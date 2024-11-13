import 'package:app/app_localizations.dart';
import 'package:app/comms/model/request/HostGetAllSexRelationshipRequest.dart';
import 'package:app/model/UserInterest.dart';
import 'package:app/ui/elements/AppDrawerMenu.dart';
import 'package:app/ui/utils/Log.dart';
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

  @override
  void initState() {
    super.initState();
    _fetchFromHost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AppDrawerMenu().getDrawer(context),
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.translate('app_name')),
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
      child: Container(
        color: const Color.fromARGB(255, 243, 243, 244),
      ),
    );
  }

  Widget _buildRelationship() {
    return Expanded(
      child: Container(
        color: const Color.fromARGB(255, 243, 243, 244),
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

      setState(() {
        _isLoading = false;
      });
    });
  }
}
