import 'dart:ffi';

import 'package:app/model/Session.dart';
import 'package:app/model/User.dart';
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
    "Fotos"
  ];

  @override
  void initState() {
    super.initState();
    _initInternal();
  }

  void _initInternal() {
    itemsValue.add(user.name);
    itemsValue.add("");
    itemsValue.add("");
    itemsValue.add("");
    itemsValue.add("");
    itemsValue.add("");

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
                onTap: () => _editItem(index),
                title: Text(itemsTitles[index],
                    style: const TextStyle(fontSize: 20)),
                subtitle: Text(itemsValue[index]),
              ),
              Divider(),
            ],
          );
        },
      ),
    );
  }
}
