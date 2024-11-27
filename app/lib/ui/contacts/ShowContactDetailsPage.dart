import 'package:app/model/Session.dart';
import 'package:app/model/User.dart';
import 'package:app/model/UserMatch.dart';
import 'package:app/ui/elements/FlexibleAppBar.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:flutter/material.dart';

class ShowContactDetailsPage extends StatefulWidget {
  UserMatch _match;

  ShowContactDetailsPage(this._match);

  @override
  State<ShowContactDetailsPage> createState() {
    return _ShowContactDetailsPage();
  }
}

class _ShowContactDetailsPage extends State<ShowContactDetailsPage> {
  User _user = Session.user;

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
      ),
      body: _buildBody(),
    );
  }

  Widget _buildNameBlock() {
    String? name = widget._match.contactInfo!.name;
    if (name != null && name.isNotEmpty) {
      return Row(children: [Text("Nombre:"), Text(name)]);
    }
    return Container();
  }

  Widget _buildHowToContactInfo() {
    return Container();
  }

  Widget _buildBiography() {
    return Container();
  }

  Widget _buildHobbies() {
    return Container();
  }

  Widget _buildLookingFor() {
    return Container();
  }

  Widget _buildSource() {
    return Container();
  }

  Widget _buildBody() {
    return Column(
      children: [
        Container(
          color: Colors.amber,
          child: const Padding(
            padding: EdgeInsets.all(18.0),
            child: Center(
                child:
                    CircleAvatar(maxRadius: 80, backgroundColor: Colors.red)),
          ),
        ),
        Container(
          child: Column(children: [
            Text(
              "Datos del contacto",
              style: TextStyle(fontSize: 30),
            ),
            _buildNameBlock(),
            _buildHowToContactInfo(),
            _buildBiography(),
            _buildHobbies(),
            _buildLookingFor(),
            _buildSource()
            
          ]),
        )
      ],
    );
  }

  Future<void> _fetchFromHost() async {
    try {} catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
  }
}
