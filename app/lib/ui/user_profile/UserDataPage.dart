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



  Future<void> _beforeLeaving() async {
    Log.d("Start _beforeLeaving");
    NavigatorApp.pop(context);
    // if (user.radioVisibility != _currentRadioVisibility) {
    //   HostUpdateUserRadioVisibilityRequest()
    //       .run(user.userId, _currentRadioVisibility)
    //       .then((value) {
    //     Log.d("updated radion $value");
    //     NavigatorApp.pop(context);
    //     if (value) {
    //       user.radioVisibility = _currentRadioVisibility;
    //     }
    //   });
    // } else {
    //   NavigatorApp.pop(context);
    // }
  }
}
