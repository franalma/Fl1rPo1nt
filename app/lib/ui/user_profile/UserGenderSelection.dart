import 'package:app/comms/model/request/fix_values/HostGetAllGendersRequest.dart';
import 'package:app/model/Gender.dart';
import 'package:app/model/Session.dart';
import 'package:app/model/User.dart';
import 'package:app/ui/NavigatorApp.dart';
import 'package:app/ui/elements/AlertDialogs.dart';
import 'package:app/ui/elements/FlexibleAppBar.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:flutter/material.dart';

class UserGenderSelection extends StatefulWidget {
  @override
  State<UserGenderSelection> createState() {
    return _UserGenderSelection();
  }
}

class _UserGenderSelection extends State<UserGenderSelection> {
  List<Gender> _genders = [];
  bool _isLoading = true;
  int _selectedIndex = 0;
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
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              _beforeLeaving();
            }),
      ),
      body: _isLoading ? AlertDialogs().buildLoading() : _buildList(),
    );
  }

  Widget _buildList() {
    return ListView.builder(
        itemCount: _genders.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_genders[index].name!),
            trailing: Radio(
              groupValue: _selectedIndex,
              value: index,
              onChanged: (value) {
                setState(() {
                  _selectedIndex = value!;
                });
              },
            ),
          );
        });
  }

  Future<void> _fetchFromHost() async {
    Log.d("Starts _fetchFromHost");
    try {
      HostGetAllGendersRequest().run().then((value) {
        if (value.genders != null) {
          _genders = value.genders!;
        }
        if (_user.gender.id != null) {
          for (int i = 0; i < _genders.length; i++) {
            if (_user.gender.id! == _genders[i].id!) {
              _selectedIndex = i;
              break;
            }
          }
        }
        setState(() {
          _isLoading = false;
        });
      });
    } catch (error, stackTrace) {
      Log.d("$error stack: $stackTrace");
    }
  }

  void _beforeLeaving() {
    try {
      NavigatorApp.popWith(context, _genders[_selectedIndex]);
    } catch (error, stackTrace) {
      Log.d("$error ---- $stackTrace ");
    }
  }
}
