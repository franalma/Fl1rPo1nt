import 'dart:ffi';

import 'package:app/model/HostErrorCode.dart';
import 'package:app/model/Session.dart';
import 'package:app/model/SmartPoint.dart';
import 'package:app/model/User.dart';
import 'package:app/ui/NavigatorApp.dart';
import 'package:app/ui/elements/AlertDialogs.dart';
import 'package:app/ui/elements/FlexibleAppBar.dart';
import 'package:app/ui/elements/FlirtPoint.dart';
import 'package:app/ui/elements/SlideRowLeft.dart';
import 'package:app/ui/elements/SocialNetworkIcon.dart';
import 'package:app/ui/smart_points/SmartPointsAddPage.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:flutter/material.dart';

class SmartPointShowDetailPage extends StatefulWidget {
  SmartPoint smartPoint;
  SmartPointShowDetailPage(this.smartPoint);

  @override
  State<SmartPointShowDetailPage> createState() {
    return _SmartPointShowDetailState();
  }
}

class _SmartPointShowDetailState extends State<SmartPointShowDetailPage> {
  final User _user = Session.user;
  var _pointInfo = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: FlexibleAppBar(),
        ),
        body: _buildBody());
  }

  @override
  void initState() {
    _preloadInfo();
    super.initState();
  }

  Widget _buildBody() {
    var point = widget.smartPoint; 
    
    return Column(children: [
      point.name!.isNotEmpty ?  Column(
        children: [
          ListTile(
            title: Text("Tu nombre"),
            leading: Icon(Icons.person),
            subtitle: Text(point.name!),
          ),
          Divider(),
        ],
      ):Container(),
      


      point.phone!.isNotEmpty ?  Column(
        children: [
          ListTile(
            title: Text("Tu teléfono"),
            leading: Icon(Icons.phone_iphone_outlined),
            subtitle: Text(point.phone!),
          ),
           Divider(),
        ],
      ):Container(),
      

      point.phone!.isNotEmpty ?  Column(
        children: [
          ListTile(
            title: Text("Veces utilizado"),
            leading: Icon(Icons.insert_chart_outlined_rounded),
            subtitle: Text(point.nUsed.toString()),
          ),
           Divider(),
        ],
      ):Container(),
     

      Expanded(
        child: ListView.builder(itemCount: point.networks!.length,  itemBuilder: (context, index){
          return Column(
            children: [
              ListTile(
                title: Text(point.networks![index].networkId),
                subtitle: Text(point.networks![index].value),
                leading:  SocialNetworkIcon().resolveIconForNetWorkId(point.networks![index].networkId),
              ),
              Divider()
            ],
          );
        
        }),
      ) 





    ],);
    
    
    // return ListView.builder(itemBuilder: itemBuilder)
  }

  Future<void> _preloadInfo() async {
    Log.d("Starts _preloadInfo");
    try {
      _pointInfo.add({"used": widget.smartPoint.nUsed});
      if (widget.smartPoint.name!.isNotEmpty) {
        _pointInfo.add({"name": widget.smartPoint.name});
      }

      if (widget.smartPoint.phone!.isNotEmpty) {
        _pointInfo.add({"phone": widget.smartPoint.phone});
      }

      if (widget.smartPoint.networks!.isNotEmpty) {
        _pointInfo.add({"networks": widget.smartPoint.networks});
      }
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
  }
}
