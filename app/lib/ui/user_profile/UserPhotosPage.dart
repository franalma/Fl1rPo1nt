import 'dart:convert';
import 'dart:io';

import 'package:app/comms/model/request/HostGetUserImagesRequest.dart';
import 'package:app/comms/model/request/HostRemoveImageRequest.dart';
import 'package:app/comms/model/request/HostUploadImageRequest.dart';
import 'package:app/model/FileData.dart';
import 'package:app/model/Session.dart';
import 'package:app/model/User.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class LocalFile {
  Image? image;
  String? id;

  LocalFile(this.image, this.id);
}

class UserPhotosPage extends StatefulWidget {
  @override
  State<UserPhotosPage> createState() {
    return _UserPhotosPage();
  }
}

class _UserPhotosPage extends State<UserPhotosPage> {
  // List of image URLs or asset paths
  final List<LocalFile> _imageList = [];
  final ImagePicker _picker = ImagePicker();
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
          title: Text('Tus fotos'),
          actions: [
            IconButton(
                onPressed: () => _onAddPicture(-1), icon: const Icon(Icons.add))
          ],
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
              // Image
              Positioned.fill(child: _imageList[index].image!),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () => _onDeletePictureRequest(index),
                  child: CircleAvatar(
                    backgroundColor: Colors.black.withOpacity(0.6),
                    radius: 16,
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _onAddPicture(int index) async {
    Log.d("Starts _onItemSelected");
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _isLoading = true;
      });

      HostUploadImageRequest().run(user.userId, pickedImage.path).then((fileId) {
        if (fileId.isNotEmpty) {
          _isLoading = false;
          setState(() {
            File image = File(pickedImage.path);
            _imageList.add(LocalFile(Image.file(image, fit: BoxFit.cover),fileId));
          });
        } else {
          Fluttertoast.showToast(msg: "No es posible actualizar tu imagen");
        }
      });
    }
  }

  Widget _buildOnLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  Future<void> _fechImagesFromServer() async {
    Log.d("Starts _fechImagesFromServer");
    setState(() {
      _isLoading = true;
    });
    HostGetUserImagesRequest().run(user.userId).then((response) {
      if (response.fileList != null) {
        response.fileList!.map((e) {
          var content = base64Decode(e.file!);
          setState(() {
            _imageList
                .add(LocalFile(Image.memory(content, fit: BoxFit.cover), e.id));
          });
        }).toList();
      }
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> _onDeletePictureRequest(int index) async {
    Log.d("Starts _onDeletePictureRequest");
    HostRemoveImageRequest()
        .run(user.userId, _imageList[index].id!)
        .then((value) {
      if (value) {
        setState(() {
          _imageList.removeAt(index);
        });
      }else{
        Fluttertoast.showToast(msg: "No ha sido posible borrar la imagen");
      }
    });
  }
}
