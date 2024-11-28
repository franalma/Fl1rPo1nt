import 'dart:io';
import 'dart:typed_data';
import 'package:app/model/Session.dart';
import 'package:app/model/User.dart';
import 'package:app/model/UserMatch.dart';
import 'package:app/ui/NavigatorApp.dart';
import 'package:app/ui/elements/AlertDialogs.dart';
import 'package:app/ui/elements/FlexibleAppBar.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import '../../comms/model/request/user/images/HostGetUserImagesRequest.dart';
import '../../comms/model/request/user/images/HostRemoveImageRequest.dart';
import '../../comms/model/request/user/images/HostUpdateUserImageProfileRequest.dart';
import '../../comms/model/request/user/images/HostUploadImageRequest.dart';

class LocalFile {
  String url;
  String? id;
  Uint8List buffer;

  LocalFile(this.url, this.id, this.buffer);
}

class ShowContactPictures extends StatefulWidget {
  UserMatch _match;

  ShowContactPictures(this._match);

  @override
  State<ShowContactPictures> createState() {
    return _ShowContactPictures();
  }
}

class _ShowContactPictures extends State<ShowContactPictures> {
  // List of image URLs or asset paths
  final List<LocalFile> _imageList = [];

  bool _isLoading = false;
  User user = Session.user;

  @override
  void initState() {
    super.initState();
    _fechImagesFromServer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: FlexibleAppBar(),
        ),
        body: _isLoading ? _buildOnLoading() : _buildBody());
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of images per row
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: _imageList.length,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              GestureDetector(
                child: Positioned.fill(
                    child: Image.network("${_imageList[index].url}&width=200&height=200&quality=40")),
                onTap: () {
                  
                  AlertDialogs().showPolishedImageDialog(context, "${_imageList[index].url}&width=500&height=500&quality=80");
                },
              )
            ],
          );
        },
      ),
    );
  }

  Widget _buildOnLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  String _customizeImage(String url) {
    return "$url&width=200&height=200&quality=40";
  }

  Future<void> _fechImagesFromServer() async {
    Log.d("Starts _fechImagesFromServer");
    setState(() {
      _isLoading = true;
    });
    var contactId = widget._match.contactInfo?.userId;
    HostGetUserImagesRequest().run(contactId!).then((response) {
      if (response.fileData != null) {
        response.fileData!.map((e) {
          setState(() {
            
            _imageList.add(LocalFile(e.url!, e.id, Uint8List(0)));
          });
        }).toList();
      }
      setState(() {
        _isLoading = false;
      });
    });
  }
}
