import 'dart:convert';
import 'dart:typed_data';

import 'package:app/ui/utils/Log.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:ndef/ndef.dart' as ndef;

class NfcService {
  Future<bool> init() async {
    try {
      var value = await FlutterNfcKit.nfcAvailability;
      if (value != NFCAvailability.available) {
        return false;
      }
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
      return false;
    }

    return true;
  }

  Future<bool> recordNfc(String data) async {
    bool res = false;
    try {
      Log.d("Starts recordNfc");
      NFCTag tag = await FlutterNfcKit.poll(
          timeout: const Duration(seconds: 10),
          iosMultipleTagMessage: "Multiple tags found!",
          iosAlertMessage: "Scan your tag");

      if (tag.ndefWritable!) {
        // decoded NDEF records
        var record = ndef.TextRecord();

        record.text = base64Encode(utf8.encode(data));
        record.language = "es";
        record.id = Uint8List.fromList(utf8.encode("9999"));
        await FlutterNfcKit.writeNDEFRecords([record]);
        res = true;
      }
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    } finally {
      await FlutterNfcKit.finish();
    }
    return res;
  }

  Future<String> readNfc(int timeout) async {
    String res = "";
    try {
      NFCTag tag = await FlutterNfcKit.poll(
          timeout: Duration(seconds: timeout),
          iosMultipleTagMessage: "Multiple tags found!",
          iosAlertMessage: "Scan your tag");

      await FlutterNfcKit.setIosAlertMessage("hi there!");
      if (tag.ndefAvailable!) {
        for (var record in await FlutterNfcKit.readNDEFRecords(cached: false)) {
          if (record.payload != null) {
          
            res = String.fromCharCodes(record.payload!).substring(3);
            res = utf8.decode(base64Decode(res));        
            break;
          }
        }
      }
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    } finally {
      await FlutterNfcKit.finish();
    }
    // callback(res);
    return res; 
  }
}
