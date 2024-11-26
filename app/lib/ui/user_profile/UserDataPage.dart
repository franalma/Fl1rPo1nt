import 'package:app/comms/model/request/user/profile/HostUpdateUserGenderRequest.dart';
import 'package:app/comms/model/request/user/profile/HostUpdateUserNameRequest.dart';
import 'package:app/comms/model/request/user/profile/HostUpdateUserRadioVisibilityRequest.dart';
import 'package:app/model/Gender.dart';
import 'package:app/model/Session.dart';
import 'package:app/model/User.dart';
import 'package:app/ui/NavigatorApp.dart';
import 'package:app/ui/elements/AlertDialogs.dart';
import 'package:app/ui/elements/FlexibleAppBar.dart';
import 'package:app/ui/elements/Styles.dart';

import 'package:app/ui/user_profile/UserBiographyPage.dart';
import 'package:app/ui/user_profile/UserGenderSelection.dart';
import 'package:app/ui/user_profile/UserHobbiesPage.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:app/ui/utils/toast_message.dart';
import 'package:flutter/material.dart';

class UserDataPage extends StatefulWidget {
  @override
  State<UserDataPage> createState() {
    return _UserDataPage();
  }
}

class _UserDataPage extends State<UserDataPage> {
  User user = Session.user;
  late double _currentRadioVisibility;
  late Gender _gender;

  @override
  void initState() {
    _currentRadioVisibility = user.radioVisibility;
    _gender = user.gender;
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
            },
          ),
        ),
        body: ListView(children: [
          Column(
            children: [
              ListTile(
                onTap: () async {
                  await _onChangeName();
                },
                title: Text("Nombre", style: Styles.rowCellTitleTextStyle),
                subtitle:
                    Text(user.name, style: Styles.rowCellSubTitleTextStyle),
              ),
              const Divider(),
            ],
          ),
          Column(
            children: [
              ListTile(
                onTap: () async {},
                title: Text("Contraseña", style: Styles.rowCellTitleTextStyle),
                subtitle:
                    Text("********", style: Styles.rowCellSubTitleTextStyle),
              ),
              const Divider(),
            ],
          ),
          Column(
            children: [
              ListTile(
                onTap: () async {
                  var result = await NavigatorApp.pushAndWait(
                      UserGenderSelection(), context) as Gender;
                  Log.d(" gender selected ${result.name}");
                  await _onGenderChanged(result);
                },
                title: Text("Género", style: Styles.rowCellTitleTextStyle),
                subtitle: Text(
                    user.gender.name != null ? user.gender.name! : "",
                    style: Styles.rowCellSubTitleTextStyle),
              ),
              const Divider(),
            ],
          ),
          Column(
            children: [
              ListTile(
                  onTap: () async {
                    NavigatorApp.push(UserBiographyPage(), context);
                  },
                  title: Text("Biografía", style: Styles.rowCellTitleTextStyle),
                  trailing: const Icon(Icons.arrow_forward_ios)),
              const Divider(),
            ],
          ),
          Column(
            children: [
              ListTile(
                  onTap: () async {
                    NavigatorApp.push(UserHobbiesPage(), context);
                  },
                  title: Text("Aficiones", style: Styles.rowCellTitleTextStyle),
                  trailing: const Icon(Icons.arrow_forward_ios)),
              const Divider(),
            ],
          ),
          Column(
            children: [
              ListTile(
                onTap: () async {
                  // await _onItemSelected(index);
                },
                title: Text("Visible en", style: Styles.rowCellTitleTextStyle),
                subtitle: Text("$_currentRadioVisibility Kms",
                    style: Styles.rowCellSubTitleTextStyle),
              ),
              Slider(
                  value: _currentRadioVisibility,
                  min: 0,
                  max: 200,
                  divisions: 5,
                  // label: sliderValues[index].toStringAsFixed(1),
                  onChanged: (value) {
                    setState(() {
                      _currentRadioVisibility = value;
                    });
                  }),
              const Divider(),
            ],
          )
        ]));
  }

  Future<void> _onChangeName() async {
    Log.d("Starts _onChangeName");
    AlertDialogs().showDialogEdit(
        context, user.name, "Cambia tu nombre", "Introduce tu nombre",
        (result) {
      if (result.isNotEmpty) {
        HostUpdateUserNameRequest().run(user.userId, result).then((value) {
          if (value) {
            setState(() {
              user.name = result;
            });
          } else {
            FlutterToast().showToast("No ha sido posible cambiar tu nombre");
          }
        });
      }
    });
  }

  Future<void> _onGenderChanged(Gender gender) async {
    Log.d("Start _onGenderChanged");
    HostUpdateUserGenderRequest().run(user.userId, gender).then((value) {
      setState(() {
        if (value) {
          user.gender = gender;
        }
      });
    });
  }

  Future<void> _beforeLeaving() async {
    Log.d("Start _beforeLeaving");
    if (user.radioVisibility != _currentRadioVisibility) {
      HostUpdateUserRadioVisibilityRequest()
          .run(user.userId, _currentRadioVisibility)
          .then((value) {
        Log.d("updated radion $value");
        NavigatorApp.pop(context);
        if (value) {
          user.radioVisibility = _currentRadioVisibility;
        }
      });
    } else {
      NavigatorApp.pop(context);
    }
  }
}
