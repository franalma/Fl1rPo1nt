import 'dart:ffi';

import 'package:app/model/Session.dart';
import 'package:app/model/User.dart';
import 'package:app/ui/NavigatorApp.dart';
import 'package:app/ui/user_profile/UserAudiosPage.dart';
import 'package:app/ui/user_profile/UserBiographyPage.dart';
import 'package:app/ui/user_profile/UserHobbiesPage.dart';
import 'package:app/ui/user_profile/UserPhotosPage.dart';
import 'package:app/ui/utils/Log.dart';
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
  void _editItem(int index) {
    TextEditingController _controller = TextEditingController();
    _controller.text = itemsValue[index];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(itemsTitles[index]),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Introduce un nuevo valor',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  itemsValue[index] = _controller.text;
                });
                Navigator.of(context).pop();
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tus datos'),
      ),
      body: ListView.builder(
        itemCount: itemsTitles.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                onTap: () => _onItemSelected(index),
                title: Text(itemsTitles[index]),
                subtitle: Text(itemsValue[index]),
                trailing: _buildTrailing(index),
              ),
              Divider(),
            ],
          );
        },
      ),
    );
  }

  Widget? _buildTrailing(int index){
    switch(index){
      case 0:
      case 1: 
      case 6: 
      
      return null;
    
    }
    return Icon(Icons.arrow_forward_ios);
    
  }
  void _onItemSelected(int index){
    Log.d("Start on _onItemSelected");

    switch(index){
      case 0: 
      case 1: 
      case 6:
      {
        _editItem(index);
        break; 
      }
      case 2: {
        //Biography
        NavigatorApp.push(UserBiographyPage(), context);
        break; 
      }
      case 3:{
        //Hobbies
        NavigatorApp.push(UserHobbiesPage(), context);
        break;
      }
      case 4:{
        //Photos
        NavigatorApp.push(UserPhotosPage(), context);
        break;
      }
      case 5:{
        //Photos
        NavigatorApp.push(UserAudiosPage(), context);
        break;
      }
    }

  }

}
