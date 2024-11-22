import 'package:app/app_localizations.dart';
import 'package:app/comms/model/request/HostGetAllHobbiesRequest.dart';
import 'package:app/comms/model/request/HostUpdateHobbiesRequest.dart';
import 'package:app/model/Hobby.dart';
import 'package:app/model/Session.dart';
import 'package:app/model/User.dart';
import 'package:app/ui/NavigatorApp.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:app/ui/utils/toast_message.dart';
import 'package:flutter/material.dart';

class UserHobbiesPage extends StatefulWidget {
  @override
  State<UserHobbiesPage> createState() {
    return _UserHobbiesPage();
  }
}

class _UserHobbiesPage extends State<UserHobbiesPage> {
  bool _isLoading = true;
  List<Hobby> _allHobbies = [];
  List<dynamic> _selectedHobbie = [];
  User user = Session.user;
  @override
  void initState() {
    super.initState();
    _fetchFromHost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // drawer: AppDrawerMenu().getDrawer(context),
        appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.translate('app_name')),
            actions: [
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: () {
                  _onSaveValues();
                },
              ),
            ]),
        body: _isLoading ? _buildLoading() : _buildList());
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildList() {
    return ListView.builder(
        itemCount: _allHobbies.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                  title: CheckboxListTile(
                      value: _selectedHobbie.contains(_allHobbies[index].id),
                      onChanged: (value) => {_onItemChange(index, value)},
                      title: Text(_allHobbies[index].name))),
                      Divider()
            ],
          );
        });
  }

  Future<void> _fetchFromHost() async {
    Log.d("Starts _fetchFromHost");
    HostGetAllHobbiesRequest().run().then((value) {
      _allHobbies = value;
      setState(() {
        _selectedHobbie = user.hobbies;
        _isLoading = false;
      });
    });
  }

  Future<void> _onSaveValues() async {
    Log.d("Starts _onSaveValues");
    setState(() {
      _isLoading = true;
    });
    HostUpdateHobbiesRequest().run(user.userId, _selectedHobbie).then((value) {
      if (value) {
        user.hobbies = _selectedHobbie;
        NavigatorApp.pop(context);
      } else {
        FlutterToast().showToast("No ha sido posible actualzar tus hobbies");
      }
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _onItemChange(int index, bool? value) {
    Log.d("Starts _onItemChange");
    setState(() {
      if (value!) {
        _selectedHobbie.add(_allHobbies[index].id);
      } else {
        _selectedHobbie.remove(_allHobbies[index].id);
      }
    });
  }
}
