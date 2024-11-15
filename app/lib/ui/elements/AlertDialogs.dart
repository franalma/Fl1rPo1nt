import 'package:flutter/material.dart';

class AlertDialogs {
  void showAlertNewContactAdded(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Nuevo contacto añadido'),
          content: Text('Se ha añadido a $message a tus contactos'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}
