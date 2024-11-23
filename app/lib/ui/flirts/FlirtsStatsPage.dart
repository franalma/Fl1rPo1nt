import 'package:app/app_localizations.dart';
import 'package:app/comms/model/request/flirt/HostGetUserFlirtsRequest.dart';
import 'package:app/model/Flirt.dart';
import 'package:app/model/Session.dart';
import 'package:app/model/User.dart';
import "package:app/ui/utils/Log.dart";
import 'package:flutter/material.dart';

class FlirtsStatsPage extends StatefulWidget {
  @override
  State<FlirtsStatsPage> createState() {
    return _FlirtsStatsPage();
  }
}

class _FlirtsStatsPage extends State<FlirtsStatsPage> {
  List<Flirt> _flirtList = [];
  bool _isLoading = true;
  User user = Session.user;
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
        ),
        body: _isLoading ? _buildLoading() : _buildList());
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildList() {
    Log.d("FlirtsStatsPage _buildList");
    return ListView.builder(
        itemCount: _flirtList.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                  title: Text(_flirtList[index].id.substring(0, 10)),
                  subtitle: Column(
                    children: [
                      Text("Fecha: ${_timeFromEpoch(_flirtList[index].createdAt)}"),
                      Text(
                          "Dónde:  [${_flirtList[index].location?.lat},${_flirtList[index].location?.lon}]"),
                      Text("Estado: ${_getFlirtStatus(index)}")
                    ],
                  ),
                  trailing: (_flirtList[index].status == 0)
                      ? ElevatedButton(onPressed: () {}, child: Text(AppLocalizations.of(context)!.translate("delete")))
                      : Container()),
              Divider()
            ],
          );
        });
  }

  String _timeFromEpoch(int epochTimestamp) {
    DateTime utcDateTime =
        DateTime.fromMillisecondsSinceEpoch(epochTimestamp, isUtc: true);
    return utcDateTime.toString();
  }

  String _getFlirtStatus(int index) {
    return (_flirtList[index].status == 0) ? "Finalizado" : "Activo";
  }

  Future<void> _fetchFromHost() async {
    Log.d("Starts _fetchFromHost");

    setState(() {
      _isLoading = true;
    });

    HostGetUserFlirtsRequest().all(user.userId).then((value) {
      Log.d(value.flirts!.length.toString());
      if (value.flirts != null && value.flirts!.isNotEmpty) {
        setState(() {
          _isLoading = false;
          _flirtList = value.flirts!;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }
}
