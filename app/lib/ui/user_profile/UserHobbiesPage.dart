import 'package:app/comms/model/request/user/profile/HostUpdateHobbiesRequest.dart';
import 'package:app/comms/model/request/fix_values/HostGetAllHobbiesRequest.dart';
import 'package:app/model/Hobby.dart';
import 'package:app/model/Session.dart';
import 'package:app/model/User.dart';
import 'package:app/ui/NavigatorApp.dart';
import 'package:app/ui/elements/FlexibleAppBar.dart';
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
  List<String> _selectedHobbies = [];
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
          flexibleSpace: FlexibleAppBar(),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              _onSaveValues();
            },
          ),
        ),
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
                      value: _selectedHobbies.contains(_allHobbies[index].name),
                      onChanged: (value) => {_onItemChange(index, value)},
                      title: Text(_allHobbies[index].name))),
              const Divider()
            ],
          );
        });
  }

  Future<void> _fetchFromHost() async {
    Log.d("Starts _fetchFromHost");
    HostGetAllHobbiesRequest().run().then((value) {
      _allHobbies = value;
      setState(() {
        _selectedHobbies = user.hobbies.map((e) => e.name).toList();
        _isLoading = false;
      });
    });
  }

  Future<void> _onSaveValues() async {
    Log.d("Starts _onSaveValues");

    List<Hobby> values = [];
    _selectedHobbies.map((e) => print(e)).toList();
    for (var item in _allHobbies) {
      if (_selectedHobbies.contains(item.name)) {
        values.add(item);
      }
    }

    setState(() {
      _isLoading = true;
    });
    HostUpdateHobbiesRequest().run(user.userId, values).then((value) {
      if (value) {
        user.hobbies = values;
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
        _selectedHobbies.add(_allHobbies[index].name);
      } else {
        _selectedHobbies.remove(_allHobbies[index].name);
      }
    });
  }
}
