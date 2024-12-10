import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:ndef/ndef.dart' as ndef;

class SmartPointsListPage extends StatefulWidget {
  @override
  State<SmartPointsListPage> createState() {
    return _SmartPointsListPage();
  }
}

class _SmartPointsListPage extends State<SmartPointsListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(flexibleSpace: const FlexibleSpaceBar()),
        body: _buildBody());
  }

  @override
  void initState() {
    FlutterNfcKit.nfcAvailability.then((value) {
      if (value != NFCAvailability.available) {
        // oh-no
      }
    });

    super.initState();
  }

  Widget _buildBody() {
    return Center(
      child: Column(
        children: [
          ElevatedButton(
            child: Text("Grabar"),
            onPressed: () {
              _recordPoint();
            },
          ),
          ElevatedButton(
            child: Text("Leer"),
            onPressed: () {
              _readPoint();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _recordPoint() async {
    try {
      NFCTag tag = await FlutterNfcKit.poll(
          timeout: const Duration(seconds: 10),
          iosMultipleTagMessage: "Multiple tags found!",
          iosAlertMessage: "Scan your tag");
            print ("Detected tag");
      // write NDEF records if applicable
      print(tag.ndefAvailable!);
      if (tag.ndefWritable!) {
        // decoded NDEF records
        var record = ndef.TextRecord();
        print ("After recort");
        record.text = base64Encode(utf8.encode("http://www.floiint.com"));
        record.language = "es";
         print ("After language");
        record.id =  Uint8List.fromList(utf8.encode("9999"));
        await FlutterNfcKit.writeNDEFRecords([record]);
        print ("Recorded new value");

      }
    } catch (e) {
      print('Error writing NFC tag: $e');
    } finally {
      // End the NFC session
      await FlutterNfcKit.finish();
    }
  }

  Future<void> _readPoint() async {
    try {
      NFCTag tag = await FlutterNfcKit.poll(
          timeout: const Duration(seconds: 10),
          iosMultipleTagMessage: "Multiple tags found!",
          iosAlertMessage: "Scan your tag");
      // print(jsonEncode(tag));
      await FlutterNfcKit.setIosAlertMessage("hi there!");
      if (tag.ndefAvailable!) {
        for (var record in await FlutterNfcKit.readNDEFRecords(cached: false)) {
          print(record.toString());
        }

        // for (var record
        //     in await FlutterNfcKit.readNDEFRawRecords(cached: false)) {
        //   print(jsonEncode(record).toString());
        // }
      }
    } catch (e) {
      print('Error reading NFC tag: $e');
    } finally {
      // End the NFC session
      await FlutterNfcKit.finish();
    }
  }
}
