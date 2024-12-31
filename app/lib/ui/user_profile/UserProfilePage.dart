import 'package:app/comms/model/request/user/images/HostGetUserImgeUrlByIdRequest.dart';
import 'package:app/comms/model/request/user/profile/HostUpdateUserNameRequest.dart';
import 'package:app/main.dart';
import 'package:app/model/SecureStorage.dart';
import 'package:app/model/Session.dart';
import 'package:app/model/Subscription.dart';
import 'package:app/model/User.dart';
import 'package:app/services/IapService.dart';
import 'package:app/ui/NavigatorApp.dart';
import 'package:app/ui/elements/AlertDialogs.dart';
import 'package:app/ui/elements/FlexibleAppBar.dart';
import 'package:app/ui/elements/Styles.dart';
import 'package:app/ui/suscriptions/SubscriptionListPage.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:app/ui/utils/toast_message.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    var values = {"user_id": user.userId, "file_id": user.userProfileImageId};

    HostGetUserImgeUrlByIdRequest().run(values).then((response) {
      if (response.fileData != null && response.fileData!.isNotEmpty) {
        setState(() {
          // _profileImageUrl =
          //     "${response.fileData![0].url!}&quality=40&width=200&height=200";
          _profileImageUrl = response.fileData![0].url!;
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
              _buildSubscriptionBlock(),
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

  Widget _buildSubscriptionBlock() {
    if (user.subscription.id != null) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(
              FontAwesomeIcons.medal, color: IapService.getSubscriptionColor(user.subscription.id!),
              size: 40,
              // color: user.subscription.color,
            ),
          ],
        ),
      );
    }
    return Container();
  }

  Future<void> _onChangeName() async {
    Log.d("Starts _onChangeName");
    AlertDialogs().showDialogEdit(
        context, user.name, "Cambia tu nombre", "Introduce tu nombre",
        (result) {
      if (result.isNotEmpty) {
        HostUpdateUserNameRequest().run(user.userId, result).then((value) {
          if (value) {
            setState(() {
              user.name = result;
            });
          } else {
            FlutterToast().showToast("No ha sido posible cambiar tu nombre");
          }
        });
      }
    });
  }

  Widget _buildList() {
    return Column(
      children: [
        _buildProfileInfo(),
        SizedBox(
          height: MediaQuery.of(context).size.height - 280,
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ListView(
              children: [
                Column(
                  children: [
                    ListTile(
                      onTap: () async {
                        await _onChangeName();
                      },
                      leading: const Icon(Icons.person),
                      title:
                          Text("Nombre", style: Styles.rowCellTitleTextStyle),
                      subtitle: Text(user.name,
                          style: Styles.rowCellSubTitleTextStyle),
                    ),
                    const Divider(),
                  ],
                ),
                Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.password),
                      onTap: () async {},
                      title: Text("Contraseña",
                          style: Styles.rowCellTitleTextStyle),
                      subtitle: Text("********",
                          style: Styles.rowCellSubTitleTextStyle),
                    ),
                    const Divider(),
                  ],
                ),
                Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.subscriptions_outlined),
                      trailing: const Icon(Icons.arrow_forward_ios_sharp),
                      onTap: () async {
                        NavigatorApp.push(SubscriptionListPage(), context);
                      },
                      title: Text("Suscripciones",
                          style: Styles.rowCellTitleTextStyle),
                    ),
                    const Divider(),
                  ],
                ),
                ListTile(
                    leading: const Icon(Icons.exit_to_app),
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
