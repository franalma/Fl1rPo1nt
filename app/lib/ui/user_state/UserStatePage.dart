import 'package:app/comms/model/request/user/profile/HostUpdateUserGenderRequest.dart';
import 'package:app/comms/model/request/user/profile/HostUpdateUserInterestRequest.dart';
import 'package:app/model/Flirt.dart';
import 'package:app/model/Gender.dart';
import 'package:app/model/Session.dart';
import 'package:app/model/User.dart';
import 'package:app/model/UserInterest.dart';
import 'package:app/services/LocationService.dart';
import 'package:app/ui/NavigatorApp.dart';
import 'package:app/ui/elements/FlexibleAppBar.dart';
import 'package:app/ui/elements/FlirtPoint.dart';
import 'package:app/ui/elements/Styles.dart';
import 'package:app/ui/user_profile/UserAudiosPage.dart';
import 'package:app/ui/user_profile/UserBiographyPage.dart';
import 'package:app/ui/user_profile/UserGenderSelection.dart';
import 'package:app/ui/user_profile/UserHobbiesPage.dart';
import 'package:app/ui/user_profile/UserPhotosPage.dart';
import 'package:app/ui/user_state/SelectRelationshipOptionPage.dart';
import 'package:app/ui/user_state/SelectSexOptionPage.dart';
import 'package:app/ui/utils/CommonUtils.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:app/ui/utils/location.dart';
import 'package:app/ui/utils/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../comms/model/request/fix_values/HostGetAllSexRelationshipRequest.dart';

class UserStatePage extends StatefulWidget {
  @override
  State<UserStatePage> createState() {
    return _UserStatePage();
  }
}

class _UserStatePage extends State<UserStatePage> {
  List<SexAlternative> sexAlternatives = [];
  List<RelationShip> relationship = [];

  bool _isLoading = true;

  late RelationShip _relationshipSelected;
  late SexAlternative _sexAlternativeSelected;
  late Gender _searchingGenderSelected;

  User user = Session.user;
  LocationService? _locationService;
  late double _currentRadioVisibility;

  @override
  void initState() {
    _currentRadioVisibility = user.radioVisibility;
    _sexAlternativeSelected = user.sexAlternatives;
    _relationshipSelected = user.relationShip;
    _searchingGenderSelected = user.genderInterest;
    _fetchFromHost();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: FlexibleAppBar(),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_outlined),
            onPressed: () {
              _onSaveData();
            },
          ),
        ),
        body: _isLoading ? _buildLoading() : _buildBody());
  }

  Color _getSexAlternativeColor() {
    Color color = Colors.white;
    if (_sexAlternativeSelected.color.isNotEmpty) {
      color = Color(CommonUtils.colorToInt(_sexAlternativeSelected.color));
    }
    return color;
  }

  Color _getRelationshipAlternativeColor() {
    Color color = Colors.white;
    if (_relationshipSelected.color.isNotEmpty) {
      color = Color(CommonUtils.colorToInt(_relationshipSelected.color));
    }
    return color;
  }

  Color _getGenderColor(Gender gender) {
    Color color = Colors.white;
    if (gender.color != null) {
      color = Color(CommonUtils.colorToInt(gender!.color!));
    }
    return color;
  }

  Widget _buildSexOrientation() {
    return ListTile(
      enabled: !user.isFlirting,
      leading: SizedBox(
        height: 50,
        width: 50,
        child: Container(color: _getSexAlternativeColor()),
      ),
      trailing: const Icon(Icons.arrow_forward_ios_sharp),
      title: const Text("Orientación sexual"),
      subtitle: Text(_sexAlternativeSelected.name),
      onTap: () async {
        var selected = await NavigatorApp.pushAndWait(
            SelectSexOptionPage(sexAlternatives), context) as SexAlternative;
        setState(() {
          _sexAlternativeSelected = selected;
        });
        Log.d("value selected: $selected");
      },
    );
  }

  Widget _buidRelationShip() {
    return ListTile(
      enabled: !user.isFlirting,
      leading: SizedBox(
        height: 50,
        width: 50,
        child: Container(color: _getRelationshipAlternativeColor()),
      ),
      trailing: const Icon(Icons.arrow_forward_ios_sharp),
      title: const Text("Relación que buscas"),
      subtitle: Text(_relationshipSelected.value),
      onTap: () async {
        var selected = await NavigatorApp.pushAndWait(
                SelectRelationshipOptionPage(relationship), context)
            as RelationShip;
        setState(() {
          _relationshipSelected = selected;
        });
        Log.d("value selected: $selected");
      },
    );
  }

  Widget _buildLookingForGender() {
    return ListTile(
        enabled: !user.isFlirting,
        leading: SizedBox(
          height: 50,
          width: 50,
          child: Container(color: _getGenderColor(_searchingGenderSelected)),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_sharp),
        title: const Text("Género que buscas"),
        subtitle: Text(_searchingGenderSelected.name ?? ""),
        onTap: () async {
          var selected =
              await NavigatorApp.pushAndWait(UserGenderSelection(), context)
                  as Gender;
          setState(() {
            _searchingGenderSelected = selected;
          });
        });
  }

  Widget _buildStatus() {
    Color? sexColor;
    Color? relColor;
    if (user.isFlirting) {
      sexColor = Color(CommonUtils.colorToInt(user.sexAlternatives.color));
      relColor = Color(CommonUtils.colorToInt(user.relationShip.color));
    }
    return ListTile(
      leading: SizedBox(
          height: 50,
          width: 50,
          child: user.isFlirting
              ? FlirtPoint().build(50, 50, 50, sexColor!, relColor!)
              : Container()),
      trailing: Switch(
        value: user.isFlirting,
        onChanged: (bool value) async {
          _toggleState(value);
        },
      ),
      title: const Text("Estado"),
    );
  }

  Widget _buildRadioVisibility() {
    return Column(
      children: [
        ListTile(
          enabled: !user.isFlirting,
          onTap: () async {},
          title: Text("Visible en", style: Styles.rowCellTitleTextStyle),
          subtitle: Text("${user.radioVisibility} Kms",
              style: Styles.rowCellSubTitleTextStyle),
        ),
        Slider(
            value: _currentRadioVisibility,
            min: 0,
            max: 200,
            divisions: 5,
            onChanged: (value) async {
              if (!user.isFlirting) {
                bool status = await user.updateUserVisibility(value);
                if (status) {
                  setState(() {
                    _currentRadioVisibility = value;
                    user.radioVisibility = value;
                  });
                }
              }
            }),
      ],
    );
  }

  Widget _buildMyGender() {
    return ListTile(
      enabled: !user.isFlirting,
      onTap: () async {
        var result =
            await NavigatorApp.pushAndWait(UserGenderSelection(), context)
                as Gender;
        Log.d(" gender selected ${result.name}");
        await _onGenderChanged(result);
      },
      title: Text("Me percibo como"),
      subtitle: Text(user.gender.name != null ? user.gender.name! : "",
          style: Styles.rowCellSubTitleTextStyle),
      leading: SizedBox(
        height: 50,
        width: 50,
        child: Container(color: _getGenderColor(user.gender)),
      ),
      trailing: const Icon(Icons.arrow_forward_ios_sharp),
    );
  }

  Future<void> _toggleState(bool value) async {
    Log.d("Starts _toggleState");
    try {
      if (value) {
        await _onStartFlirt();
      } else {
        await _onStopFlirt();
      }
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
  }

  Widget _buildBody() {
    return ListView(children: [
      _buildStatus(),
      const Divider(),
      _buildMyGender(),
      const Divider(),
      _buildSexOrientation(),
      const Divider(),
      _buidRelationShip(),
      const Divider(),
      _buildLookingForGender(),
      const Divider(),
      _buildMyMultimedia(),
      const Divider(),
      _buildBiography(),
      const Divider(),
      _buildHobbies(),
      const Divider(),
      _buildRadioVisibility(),
      const Divider(),
    ]);
  }

  Widget _buildBiography() {
    return ListTile(
        onTap: () async {
          NavigatorApp.push(UserBiographyPage(), context);
        },
        leading: const Icon(FontAwesomeIcons.pen),
        title: Text("Un poco sobre mí...", style: Styles.rowCellTitleTextStyle),
        trailing: const Icon(Icons.arrow_forward_ios));
  }

  Widget _buildHobbies() {
    return ListTile(
        onTap: () async {
          NavigatorApp.push(UserHobbiesPage(), context);
        },
        leading: const Icon(Icons.houseboat_outlined),
        title: Text("Aficiones", style: Styles.rowCellTitleTextStyle),
        trailing: const Icon(Icons.arrow_forward_ios));
  }

  Widget _buildMyMultimedia() {
    return Column(
      children: [
        ListTile(
            title: Text("Mis fotos", style: Styles.rowCellTitleTextStyle),
            leading: const Icon(FontAwesomeIcons.image),
            trailing:
                const Icon(Icons.arrow_forward_ios), // Add a left arrow icon
            onTap: () => NavigatorApp.push(UserPhotosPage(), context)),
        const Divider(),
        ListTile(
            title: Text("Mis audios", style: Styles.rowCellTitleTextStyle),
            leading: const Icon(Icons.audio_file),
            trailing:
                const Icon(Icons.arrow_forward_ios), // Add a left arrow icon
            onTap: () => NavigatorApp.push(UserAudiosPage(), context)),
      ],
    );
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  Future<void> _fetchFromHost() async {
    Log.d("Starts _fetchFromHost");
    HostGetAllSexRelationshipRequest().run().then((value) async {
      relationship = value.relationships;
      sexAlternatives = value.sexAlternatives;

      await _fetchFlirtStateFromHost();
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> _onGenderChanged(Gender gender) async {
    Log.d("Start _onGenderChanged");
    HostUpdateUserGenderRequest().run(user.userId, gender).then((value) {
      setState(() {
        if (value) {
          user.gender = gender;
        }
      });
    });
  }

  Future<void> _onSaveData() async {
    HostUpdateUserInterestRequest()
        .run(user.userId, _relationshipSelected, _sexAlternativeSelected,
            _searchingGenderSelected)
        .then((value) {
      if (!value) {
        FlutterToast()
            .showToast("No ha sido posible actualizar tus preferencias");
      } else {
        user.relationShip = _relationshipSelected;
        user.sexAlternatives = _sexAlternativeSelected;
        user.genderInterest = _searchingGenderSelected;
      }
      NavigatorApp.pop(context);
    });
  }

  Future<void> _onStartFlirt() async {
    Log.d("Starts _onStartFlirt");
    if (user.sexAlternatives.color.isEmpty ||
        user.sexAlternatives.color.isEmpty) {
      FlutterToast()
          .showToast("Debes indicar tus preferencias antes de comenzar");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    LocationHandler handler =
        LocationHandler((message) => FlutterToast().showToast(message));
    Location location = await handler.getCurrentLocation();

    if (location.lat == 0 && location.lon == 0) {
      FlutterToast().showToast("No ha sido posible obtener la localización");
      setState(() {
        _isLoading = false;
      });
    } else {
      Session.location = location;
      Flirt flirt = Flirt.empty();
      flirt.startFlirt(user, location, (status, flirt) {
        if (status) {
          user.isFlirting = true;
          Session.currentFlirt = flirt!;
          _locationService = LocationService(Session.currentFlirt!);
          _locationService?.startSendingLocation();
        } else {
          user.isFlirting = false;
          FlutterToast().showToast("No ha sido posible comenzar el Flirt");
        }
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  Future<void> _onStopFlirt() async {
    Log.d("Starts _onStopFlirt");
    try {
      if (Session.currentFlirt != null) {
        setState(() {
          _isLoading = true;
        });
        bool result = await Session.currentFlirt!.stopFlirt(user);
        if (result) {
          _locationService?.stopSendingLocation();
          user.isFlirting = false;
          _isLoading = false;
          Session.currentFlirt = null;
        } else {
          FlutterToast().showToast("No ha sido posible desactivar el Flirt");
        }
        setState(() {
          _isLoading = false;
        });
      }
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
  }

  Future<void> _fetchFlirtStateFromHost() async {
    Log.d("Starts _fetchFlirtStateFromHost");
    try {
      setState(() {
        _isLoading = true;
      });
      LocationHandler handler =
          LocationHandler((message) => FlutterToast().showToast(message));
      Location location = await handler.getCurrentLocation();
      if (location.lat == 0 && location.lon == 0) {
        FlutterToast().showToast("No ha sido posible obtener la localización");
        setState(() {
          _isLoading = false;
        });
      } else {
        Flirt? flirt = await user.getUserActiveFlirt();

        if (flirt != null) {
          Session.user.isFlirting = true;
          Session.location = location;
          Session.currentFlirt = flirt;
          _locationService = LocationService(Session.currentFlirt!);
          _locationService?.startSendingLocation();
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
  }
}
