import 'dart:ffi';

import 'package:app/model/HostErrorCode.dart';
import 'package:app/model/Session.dart';
import 'package:app/model/SmartPoint.dart';
import 'package:app/model/User.dart';
import 'package:app/ui/NavigatorApp.dart';
import 'package:app/ui/elements/AlertDialogs.dart';
import 'package:app/ui/elements/DefaultModalDialog.dart';
import 'package:app/ui/elements/FlexibleAppBar.dart';
import 'package:app/ui/elements/FlirtPoint.dart';
import 'package:app/ui/elements/SlideRowLeft.dart';
import 'package:app/ui/smart_points/SmartPointShowDetailPage.dart';
import 'package:app/ui/smart_points/SmartPointsAddPage.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
                onPressed: () async {
                  if (_points!.length < 3) {
                    await NavigatorApp.pushAndWait(
                        SmartPointsAddPage(), context);
                    _fechFromHost();
                  }else{
                    DefaultModalDialog.showErrorDialog(context, "Has llegado al máxinmo de SmartPoints", "Cerrar", FontAwesomeIcons.exclamation);
                  }
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
              return SlideRowLeft(
                  onSlide: () async {
                    _onDeleteSmartPoint(index);
                  },
                  child: Column(
                    children: [
                      ListTile(
                          onTap: () {
                            NavigatorApp.push(
                                SmartPointShowDetailPage(_points![index]),
                                context);
                          },
                          leading: FlirtPoint().build(
                              50,
                              50,
                              100,
                              _user.getSexAlternativeColor(),
                              _user.getRelationshipColor()),
                          title: Text("Floiint Point ${index + 1} "),
                          subtitle: Row(
                            children: [
                              _points![index].name!.isNotEmpty
                                  ? const Icon(Icons.person)
                                  : Container(),
                              const SizedBox(width: 10),
                              _points![index].phone!.isNotEmpty
                                  ? const Icon(Icons.phone)
                                  : Container(),
                              const SizedBox(width: 10),
                              _points![index].networks!.isNotEmpty
                                  ? const Icon(Icons.link)
                                  : Container()
                            ],
                          )),
                      const Divider()
                    ],
                  ));
            }));
  }

  Future<void> _fechFromHost() async {
    Log.d("Starts _fechFromHost");
    try {
      SmartPoint.empty().getSmartPointByUserId(_user.userId).then((response) {
        if (response.hostErrorCode != null &&
            response.hostErrorCode!.code == HostErrorCodesValue.NoError.code) {
          _points = response.points!;
        }
        setState(() {
          _isLoading = false;
        });
      });
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
  }

  Future<void> _onDeleteSmartPoint(int index) async {
    Log.d("Starts _onDeleteSmartPoint");
    try {
      setState(() {
        _isLoading = false;
      });
      bool result = await _points![index].deleteSmartPointByPointId();

      if (result) {
        _points!.removeAt(index);
      }
      setState(() {
        _isLoading = false;
      });
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
  }
}
