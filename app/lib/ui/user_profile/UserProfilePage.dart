import 'package:app/comms/model/request/user/images/HostGetUserImgeUrlByIdRequest.dart';
import 'package:app/main.dart';
import 'package:app/model/SecureStorage.dart';
import 'package:app/model/Session.dart';
import 'package:app/model/User.dart';

import 'package:app/ui/NavigatorApp.dart';
import 'package:app/ui/elements/FlexibleAppBar.dart';
import 'package:app/ui/elements/Styles.dart';
import 'package:app/ui/my_social_networks/MySocialNetworksPage.dart';
import 'package:app/ui/qr_manager/ListQrPage.dart';
import 'package:app/ui/smart_points/SmartPointsListPage.dart';
import 'package:app/ui/user_profile/UserAudiosPage.dart';
import 'package:app/ui/user_profile/UserDataPage.dart';
import 'package:app/ui/user_profile/UserPhotosPage.dart';
import 'package:app/ui/user_state/UserStatePage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserProfilePage extends StatefulWidget {
  @override
  State<UserProfilePage> createState() {
    return _UserProfilePage();
  }
}

class _UserProfilePage extends State<UserProfilePage> {
  User user = Session.user;
  String? _profileImageUrl;

  @override
  void initState() {
    _loadImageProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(flexibleSpace: FlexibleAppBar()),
      body: _buildList(),
    );
  }

  Future<void> _loadImageProfile() async {
    var values = 
      {"user_id": user.userId, "file_id": user.userProfileImageId};
    
    HostGetUserImgeUrlByIdRequest().run(values).then((response) {
      if (response.fileData != null && response.fileData!.isNotEmpty) {
        setState(() {
          _profileImageUrl =
              "${response.fileData![0].url!}&quality=40&width=200&height=200";
        });
      }
    });
  }

  Widget _loadProfileImage() {
    if (_profileImageUrl == null) {
      return const CircleAvatar(
          radius: 60, // Size of the circle
          backgroundColor: Colors.red);
    }

    return CircleAvatar(
        radius: 60, // Size of the circle
        backgroundImage: CachedNetworkImageProvider(_profileImageUrl!));
  }

  Widget _buildProfileInfo() {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Colors.blue, Colors.purple])),
      child: Column(children: [
        _loadProfileImage(),
        Center(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.camera_alt,
                      size: 40,
                    ),
                    Text(user.nScansPerformed.toString(),
                        style:
                            const TextStyle(fontSize: 30, color: Colors.white))
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.qr_code,
                      size: 40,
                    ),
                    Text(user.nScanned.toString(),
                        style:
                            const TextStyle(fontSize: 30, color: Colors.white))
                  ],
                ),
              ),
            ],
          ),
        )
      ]),
    );
  }

  Widget _buildList() {
    return Column(
      children: [
        _buildProfileInfo(),
        SizedBox(
          height: MediaQuery.of(context).size.height-280,
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ListView(
              children: [
                ListTile(
                    title:
                        Text("Mis datos", style: Styles.rowCellTitleTextStyle),
                    trailing: const Icon(
                        Icons.arrow_forward_ios), // Add a left arrow icon
                    onTap: () => NavigatorApp.push(UserDataPage(), context)),
                const Divider(),
                //ListTile(
                //     title:
                //         Text("Mis gustos", style: Styles.rowCellTitleTextStyle),
                //     trailing: const Icon(
                //         Icons.arrow_forward_ios), // Add a left arrow icon
                //     onTap: () => NavigatorApp.push(UserStatePage(), context)),
                // const Divider(),
                // ListTile(
                //     title: Text("Mis QR", style: Styles.rowCellTitleTextStyle),
                //     trailing: const Icon(
                //         Icons.arrow_forward_ios), // Add a left arrow icon
                //     onTap: () => NavigatorApp.push(ListQrPage(), context)),
                // const Divider(),
                // ListTile(
                //     title:
                //         Text("Mis redes", style: Styles.rowCellTitleTextStyle),
                //     trailing: const Icon(
                //         Icons.arrow_forward_ios), // Add a left arrow icon
                //     onTap: () => NavigatorApp.push(
                //         const MySocialNetworksPage(), context)),
                // const Divider(),
                // ListTile(
                //     title:
                //         Text("Mis puntos", style: Styles.rowCellTitleTextStyle),
                //     trailing: const Icon(
                //         Icons.arrow_forward_ios), // Add a left arrow icon
                //     onTap: () => NavigatorApp.push(SmartPointsListPage(), context)),
                // const Divider(),
                ListTile(
                    title:
                        Text("Mis fotos", style: Styles.rowCellTitleTextStyle),
                    trailing: const Icon(
                        Icons.arrow_forward_ios), // Add a left arrow icon
                    onTap: () => NavigatorApp.push(UserPhotosPage(), context)),
                const Divider(),
                ListTile(
                    title:
                        Text("Mis audios", style: Styles.rowCellTitleTextStyle),
                    trailing: const Icon(
                        Icons.arrow_forward_ios), // Add a left arrow icon
                    onTap: () => NavigatorApp.push(UserAudiosPage(), context)),
                const Divider(),
                ListTile(
                    title: const Text(
                      "Cerrar sesión",
                      style: TextStyle(color: Colors.red, fontSize: 20),
                    ),
                    onTap: () => _closeSession()),
                const Divider(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _closeSession() async {
    await SecureStorage().deleteSecureData("user_id");
    await SecureStorage().deleteSecureData("token");
    await SecureStorage().deleteSecureData("refresh_token");
    await NavigatorApp.pushAndRemoveUntil(context, const MyApp());
  }
}
