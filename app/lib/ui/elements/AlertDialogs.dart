import 'package:app/app_localizations.dart';
import 'package:flutter/material.dart';

class AlertDialogs {
  void showAlertNewContactAdded(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.translate("new_contact")),
          content: Text('Se ha añadido a $message a tus contactos'),
          actions: [
            TextButton(
              child: Text(AppLocalizations.of(context)!.translate("ok")),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void showDialogEdit(BuildContext context, String initValue, String title,
      String inputHint, Function(String) callback) {
    TextEditingController _controller = TextEditingController();
    _controller.text = initValue;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: _controller,
            decoration:  InputDecoration(
              hintText: inputHint,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                callback("");
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.translate("cancel")),
            ),
            TextButton(
              onPressed: () {
                callback(_controller.text);
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.translate("ok")),
            ),
          ],
        );
      },
    );
  }

    Widget buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }
}
