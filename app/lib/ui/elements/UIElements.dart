import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Container getButton(String text, Function() action) {
  return Container(
      margin: EdgeInsets.all(10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(
              40), // fromHeight use double.infinity as width and 40 is the height
        ),
        onPressed: action,
        child: Text(text),
      ));
}

Widget getInput(bool pass, String label, TextEditingController controller) {
  return Padding(
    padding: EdgeInsets.all(8.0),
    child:
    TextField(
      controller: controller,
      obscureText: pass,
      decoration: InputDecoration(
          border: OutlineInputBorder(), labelText: label),
    ),
  );
}

void showToast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0
  );
}

Widget getRoundedButton(Icon icon, String title, Function() action) {
  return ElevatedButton(
      onPressed: action,
      child: Column(
        children: [
          icon,
          Text(title,
            style:TextStyle(
              fontSize: 20
          ),)
        ],
      ),
      style: ButtonStyle(
          shape: MaterialStateProperty.all(CircleBorder()),
          padding: MaterialStateProperty.all(EdgeInsets.all(70)),
  backgroundColor: MaterialStateProperty.all(Colors.blue), // <-- Button color
  overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
  if (states.contains(MaterialState.pressed)) return Colors.red; // <-- Splash color
  })
  ,
  )
  ,
  );
}

