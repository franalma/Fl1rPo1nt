import 'dart:io';
import 'dart:typed_data';

import 'package:app/model/Session.dart';
import 'package:app/model/User.dart';
import 'package:app/ui/NavigatorApp.dart';
import 'package:app/ui/elements/DefaultModalDialog.dart';
import 'package:app/ui/elements/FlexibleAppBar.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../comms/model/request/user/images/HostGetUserImagesRequest.dart';
import '../../comms/model/request/user/images/HostRemoveImageRequest.dart';
import '../../comms/model/request/user/images/HostUpdateUserImageProfileRequest.dart';
import '../../comms/model/request/user/images/HostUploadImageRequest.dart';
import 'package:path/path.dart' as path;

class LocalFile {
  String url;
  String? id;
  Uint8List buffer;

  LocalFile(this.url, this.id, this.buffer);
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
  int selectedUserProfileImage = 0;
  int maxNumberPictures = 10;

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
          leading: IconButton(
              onPressed: () async {
                _onPop();
              },
              icon: const Icon(Icons.arrow_back)),
          actions: [
            IconButton(
                onPressed: () {
                  if (_imageList.length < maxNumberPictures) {
                    _onAddPicture(-1);
                  } else {
                    DefaultModalDialog.showErrorDialog(
                        context,
                        "Has llegado al máximo de imágenes",
                        "Cerrar",
                        FontAwesomeIcons.exclamation);
                  }
                },
                icon: const Icon(Icons.add))
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
              if (_imageList[index].url.isNotEmpty)
                Positioned.fill(child: Image.network(_imageList[index].url))
              else
                Positioned.fill(
                    child: Image.memory(_imageList[index].buffer,
                        fit: BoxFit.cover)),
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
              selectedUserProfileImage != index
                  ? Positioned(
                      top: 145,
                      left: 8,
                      child: GestureDetector(
                        onTap: () => _onSetProfilePicture(index),
                        child: CircleAvatar(
                          backgroundColor: Colors.black.withOpacity(0.6),
                          radius: 16,
                          child: const Icon(
                            Icons.person_3_outlined,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    )
                  : Positioned(
                      top: 145,
                      left: 8,
                      child: GestureDetector(
                        onTap: () => _onSetProfilePicture(index),
                        child: CircleAvatar(
                          backgroundColor: const Color.fromARGB(255, 5, 20, 242)
                              .withOpacity(0.6),
                          radius: 16,
                          child: const Icon(
                            Icons.person_2_rounded,
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

  Future<XFile?> compressImage(String filePath, String targetPath) async {
  final result = await FlutterImageCompress.compressAndGetFile(
    filePath,
    targetPath,
    quality: 85, // Adjust the quality (1-100). Lower is more compression.
  );

  return result;
}

  Future<void> _onAddPicture(int index) async {
    Log.d("Starts _onItemSelected");
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
        
    if (pickedImage != null) {
      setState(() {
        _isLoading = true;
      });
      var tempDir = await getTemporaryDirectory();
      final targetPath = path.join(tempDir.path, 'compressed_${path.basename(pickedImage.path)}');
      final compressedImage = await FlutterImageCompress.compressAndGetFile(
        pickedImage.path,
        targetPath,
        quality: 85, // Adjust quality
      );

      HostUploadImageRequest()
          .run(user.userId, compressedImage!.path)
          .then((fileId) {
        if (fileId.isNotEmpty) {
          _isLoading = false;
          File image = File(pickedImage.path);
          image.readAsBytes().then((buffer) {
            setState(() {
              _imageList.add(LocalFile("", fileId, buffer));
            });
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

  String _customizeImage(String url) {
    // return "$url&width=200&height=200&quality=40";
    Log.d("url: $url");
    return url; 
  }

  Future<void> _fechImagesFromServer() async {
    Log.d("Starts _fechImagesFromServer");
    setState(() {
      _isLoading = true;
    });
    HostGetUserImagesRequest().run(user.userId).then((response) {
      if (response.fileData != null) {        
        response.fileData!.map((e) {
          setState(() {
            String url = _customizeImage(e.url!);
            _imageList.add(LocalFile(url, e.id, Uint8List(0)));
          });
        }).toList();
        _getSelectedImageIndex();
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
      } else {
        Fluttertoast.showToast(msg: "No ha sido posible borrar la imagen");
      }
    });
  }

  Future<void> _onSetProfilePicture(int index) async {
    Log.d("Starts _onSetProfilePicture");
    setState(() {
      selectedUserProfileImage = index;
      Log.d("file_id: ${_imageList[selectedUserProfileImage].id}");
    });
  }

  Future<void> _onPop() async {
    Log.d("Starts _onPop");
    if (_imageList.isNotEmpty) {
      LocalFile profileImage = _imageList[selectedUserProfileImage];
      Log.d("Selected file id: ${profileImage.id}");
      HostUpdateUserImageProfileRequest()
          .run(user.userId, profileImage.id!)
          .then((value) {
        Log.d("setting user profile result $value");
        Session.user.userProfileImageId = profileImage.id!;

        NavigatorApp.pop(context);
      });
    } else {
      NavigatorApp.pop(context);
    }
  }

  void _getSelectedImageIndex() {
    if (user.userProfileImageId.isNotEmpty) {
      for (var i = 0; i < _imageList.length; i++) {
        if (_imageList[i].id == user.userProfileImageId) {
          selectedUserProfileImage = i;
          break;
        }
      }
    }

    Log.d("init image index: $selectedUserProfileImage");
  }
}
