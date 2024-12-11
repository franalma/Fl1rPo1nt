import 'package:app/model/HostErrorCode.dart';
import 'package:app/model/Session.dart';
import 'package:app/model/SmartPoint.dart';
import 'package:app/model/User.dart';
import 'package:app/ui/NavigatorApp.dart';
import 'package:app/ui/elements/AlertDialogs.dart';
import 'package:app/ui/elements/FlexibleAppBar.dart';
import 'package:app/ui/smart_points/SmartPointsAddPage.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:flutter/material.dart';

class SmartPointsListPage extends StatefulWidget {
  @override
  State<SmartPointsListPage> createState() {
    return _SmartPointsListPage();
  }
}

class _SmartPointsListPage extends State<SmartPointsListPage> {
  final User _user = Session.user;
  List<SmartPoint>? _points;
  bool _isLoading = true;

  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: FlexibleAppBar(),
          actions: [
            IconButton(
                onPressed: () {
                  NavigatorApp.push(SmartPointsAddPage(), context);
                },
                icon: const Icon(Icons.add))
          ],
        ),
        body: _isLoading ? AlertDialogs().buildLoading() : _buildBody());
  }

  @override
  void initState() {
    _fechFromHost();
    super.initState();
  }

  Widget _buildBody() {
    return Center(
        child: ListView.builder(
            itemCount: _points != null ? _points!.length : 0,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text("Point $index"),
                subtitle: Text(_points![index].id!),
              );
            }));
  }

  Future<void> _fechFromHost() async {
    Log.d("Starts _fechFromHost");
    try {
      SmartPoint.empty().getSmartPointByUserId(_user.userId).then((response) {
        if (response.hostErrorCode != null &&
            response.hostErrorCode!.status ==
                HostErrorCodesValue.NoError.code) {                  
          _points = response.points ?? List.empty();
        }

        setState(() {
          _isLoading = false;
        });
      });
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
  }
}
