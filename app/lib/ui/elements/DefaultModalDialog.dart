

import 'package:app/ui/elements/AlertDialogs.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:flutter/material.dart';

class DefaultModalDialog{
  
static TextStyle styleMessages = const TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

  static void showErrorDialog(BuildContext context, String message, String buttonText, 
  IconData icon, {Color iconColor = Colors.red, double height = 200, double iconSize = 40}){
    Log.d("Starts DefaultModalDialog::show");
    AlertDialogs().showModalDialogMessage(
                context,
                height,
                icon,
                iconSize,
                iconColor,
                message,
                styleMessages,
                buttonText);
    
  }
}