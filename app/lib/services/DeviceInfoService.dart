import 'package:app/services/NfcService.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:flutter/material.dart';

class Deviceinfoservice {
  static late dynamic screenSize; 
  static late bool nfcAvailable; 

  Future<void> init(BuildContext context) async{
    Log.d("Starts Deviceinfoservice::init");
    try{
        screenSize = MediaQuery.of(context).size;
        nfcAvailable = await NfcService().init(); 
    }
    catch(error, stackTrace){
      Log.d("$error, $stackTrace");
    }

  }

}