
import 'package:app/comms/model/request/HostUpdateUserNameRequest.dart';
import 'package:app/model/Session.dart';
import 'package:app/model/User.dart';
import 'package:app/ui/NavigatorApp.dart';
import 'package:app/ui/elements/AlertDialogs.dart';
import 'package:app/ui/elements/FlexibleAppBar.dart';
import 'package:app/ui/elements/Styles.dart';
import 'package:app/ui/user_profile/UserAudiosPage.dart';
import 'package:app/ui/user_profile/UserBiographyPage.dart';
import 'package:app/ui/user_profile/UserHobbiesPage.dart';
import 'package:app/ui/user_profile/UserPhotosPage.dart';
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
  List<String> itemsValue = [];
  List<String> itemsTitles = [
    'Nombre',
    'Contraseña',
    'Biografía',
    'Aficiones',
    "Fotos",
    "Audios",
    "Radio de búsqueda"
  ];

  @override
  void initState() {
    super.initState();
    _initInternal();
  }

  void _initInternal() {
    itemsValue.add(user.name);
    itemsValue.add("*********");
    itemsValue.add("");
    itemsValue.add("");
    itemsValue.add("");
    itemsValue.add("");
    itemsValue.add("100 kms");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: FlexibleAppBar(),
      ),
      body: ListView.builder(
        itemCount: itemsTitles.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                onTap: () async {
                  await _onItemSelected(index);
                },
                title: Text(itemsTitles[index], style: Styles.rowCellTitleTextStyle),
                subtitle: Text(itemsValue[index],style: Styles.rowCellSubTitleTextStyle),
                trailing: _buildTrailing(index),
              ),
              const Divider(),
            ],
          );
        },
      ),
    );
  }

  Widget? _buildTrailing(int index) {
    switch (index) {
      case 0:
      case 1:
      case 6:
        return null;
    }
    return const Icon(Icons.arrow_forward_ios);
  }

  Future _onItemSelected(int index) async {
    Log.d("Start on _onItemSelected");

    switch (index) {
      case 0:
        {
          AlertDialogs().showDialogEdit(
              context, user.name, "Cambia tu nombre", "Introduce tu nombre",
              (result) {
            HostUpdateUserNameRequest().run(user.userId, result).then((value) {
              if (value) {
                user.name = result;
                setState(() {
                  itemsValue[0] = result;
                });
              }else{
                FlutterToast().showToast("No ha sido posible cambiar tu nombre");
              }
            });
          });
        }
      case 1:
      case 6:
        {
          // _editItem(index);
          break;
        }
      case 2:
        {
          //Biography
          NavigatorApp.push(UserBiographyPage(), context);
          break;
        }
      case 3:
        {
          //Hobbies
          NavigatorApp.push(UserHobbiesPage(), context);
          break;
        }
      case 4:
        {
          //Photos
          NavigatorApp.push(UserPhotosPage(), context);
          break;
        }
      case 5:
        {
          //Photos
          NavigatorApp.push(UserAudiosPage(), context);
          break;
        }
    }
  }
}
