import 'package:app/comms/model/response/smart_points/HostPutPointByUserIdResponse.dart';
import 'package:app/model/HostErrorCode.dart';
import 'package:app/model/Session.dart';
import 'package:app/model/SmartPoint.dart';
import 'package:app/model/SocialNetwork.dart';
import 'package:app/model/User.dart';
import 'package:app/services/DeviceInfoService.dart';
import 'package:app/services/NfcService.dart';
import 'package:app/ui/NavigatorApp.dart';
import 'package:app/ui/elements/AlertDialogs.dart';
import 'package:app/ui/elements/FlexibleAppBar.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:flutter/material.dart';

enum StatusMessage {
  ok,
  errorCreatingSmartPoint,
  nfcNotAvailable,
  waitToRecordSmartPoint
}

class SmartPointsAddPage extends StatefulWidget {
  @override
  State<SmartPointsAddPage> createState() {
    return _SmartPointsAddState();
  }
}

class _SmartPointsAddState extends State<SmartPointsAddPage> {
  final User _user = Session.user;

  bool _isPhoneSelected = false;
  bool _isNameSelected = false;
  final List<SocialNetwork> _selectedNetwors = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: FlexibleAppBar(),
          actions: [
            IconButton(
                onPressed: () => _createPoint(_statusMessages),
                icon: const Icon(Icons.nfc))
          ],
        ),
        body: _buildBody());
  }

  @override
  void initState() {
    super.initState();
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(children: [
        const Text(
          "Selecciona los valores a compartir",
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 10),
        const Divider(),
        SizedBox(
          height: 200,
          child: Expanded(
            child: ListView(
              children: [
                CheckboxListTile(
                    title: const Text("Nombre"),
                    subtitle: Text(_user.name),
                    onChanged: (value) {
                      setState(() {
                        _isNameSelected = value!;
                      });
                    },
                    value: _isNameSelected),
                const Divider(),
                CheckboxListTile(
                    title: const Text("Teléfono"),
                    subtitle: Text(_user.phone),
                    onChanged: (value) {
                      setState(() {
                        _isPhoneSelected = value!;
                      });
                    },
                    value: _isPhoneSelected),
                const Divider(),
              ],
            ),
          ),
        ),
        const Text(
          "Selecciona tus redes",
          style: TextStyle(fontSize: 18),
        ),
        const Divider(),
        Expanded(child: _buildSocialNetwors())
      ]),
    );
  }

  Widget _buildSocialNetwors() {
    return ListView.builder(
        itemCount: _user.networks.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              CheckboxListTile(
                  title: Text(_user.networks[index].name),
                  subtitle: Text(_user.networks[index].value),
                  onChanged: (value) {
                    setState(() {
                      if (value!) {
                        _selectedNetwors.add(_user.networks[index]);
                      } else {
                        _selectedNetwors.remove(_user.networks[index]);
                      }
                    });
                  },
                  value: _selectedNetwors.contains(_user.networks[index])),
              const Divider()
            ],
          );
        });
  }

  void setLoading(bool status) {
    if (status) {
      setState(() {
        AlertDialogs().buildLoadingModal(context);
      });
    } else {
      NavigatorApp.pop(context);
    }
  }

  void _statusMessages(StatusMessage value) {
    Log.d("Starts _statusMessages");
    switch (value) {
      case StatusMessage.ok:
        {
          NavigatorApp.pop(context);
          AlertDialogs().showModalDialogMessage(
              context,
              200,
              Icons.check,
              40,
              Colors.green,
              "Se ha grabado tu punto correctamente",
              const TextStyle(fontSize: 20),
              "Cerrar");
          break;
        }
      case StatusMessage.errorCreatingSmartPoint:
        {
          NavigatorApp.pop(context);
          AlertDialogs().showModalDialogMessage(
              context,
              200,
              Icons.error,
              40,
              Colors.red,
              "No ha sido posible grabar tu smartPoint",
              const TextStyle(fontSize: 20),
              "Cerrar");
          break;
        }
      case StatusMessage.nfcNotAvailable:
        {
          NavigatorApp.pop(context);
          AlertDialogs().showModalDialogMessage(
              context,
              200,
              Icons.error,
              40,
              Colors.red,
              "No ha sido posible acceder al NFC de tu dispositivo",
              const TextStyle(fontSize: 20),
              "Cerrar");
          break;
        }
      case StatusMessage.waitToRecordSmartPoint:
        {
          AlertDialogs().showModalDialogMessage(
              context,
              200,
              Icons.nfc,
              40,
              Colors.black,
              "Acerca tu SmartPoint y espera",
              const TextStyle(fontSize: 20),
              "Cerrar");
          break;
        }
    }
  }

  Future<bool> _recordPoint(SmartPoint point, Function(StatusMessage) onResult) async {
    Log.d("Starts _recordPoint: ${point.id}");
    try {
      NfcService service = NfcService();

      bool bInit = await service.init();
      Log.d("nfc init: $bInit");
      if (bInit) {
        bool res = await service.recordNfc(point.id!);
        if (res) {
          var response = await point.updatePointStatusByPointId(1);
          if (response.hostErrorCode!.code ==
              HostErrorCodesValue.NoError.code) {
            return true;
          }
        }
      }
      await point.deleteSmartPointByPointId(); 
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
    return false;
  }

  Future<void> _createPoint(Function(StatusMessage) onResult) async {
    Log.d("Starts _createPoint");
    try {
      setLoading(true);
      HostPutPointByUserIdResponse response = await SmartPoint.empty()
          .putSmartPointByByUserId(
              _user.userId,
              _isNameSelected ? _user.name : "",
              _isPhoneSelected ? _user.phone : "",
              _selectedNetwors);
      setLoading(false);
      if (response.hostErrorCode!.code == HostErrorCodesValue.NoError.code) {
        Log.d("SmartPoint id: ${response.point!.id}");
        onResult(StatusMessage.waitToRecordSmartPoint);
        var result = await _recordPoint(response.point!, _statusMessages);

        if (result) {
          onResult(StatusMessage.ok);
        } else {
          onResult(StatusMessage.errorCreatingSmartPoint);
        }
      } else {
        onResult(StatusMessage.errorCreatingSmartPoint);
      }
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
  }
}
