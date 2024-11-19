import 'package:app/comms/model/request/HostUpdateUserBiography.dart';
import 'package:app/model/Session.dart';
import 'package:app/model/User.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:app/ui/utils/toast_message.dart';
import 'package:flutter/material.dart';

class UserBiographyPage extends StatefulWidget {
  @override
  State<UserBiographyPage> createState() {
    return _UserBiographyPage();
  }
}

class _UserBiographyPage extends State<UserBiographyPage> {
  final TextEditingController _controller = TextEditingController();
  User user = Session.user;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _controller.text = user.biography;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Sobre ti'),
          actions: [
            IconButton(
                onPressed: () => _onSaveData(), icon: const Icon(Icons.save))
          ],
        ),
        body: _isLoading ? _buildLoading() : _buildBody());
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: 300,
        child: TextField(
          controller: _controller,
          scrollPadding: EdgeInsets.all(20.0),
          maxLength: 1000,
          textAlignVertical: TextAlignVertical.top,
          keyboardType: TextInputType.multiline,
          maxLines: null, // Allows the text field to expand vertically
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Cuénta algo sobre ti... ',
            labelText: 'Sobre ti',
          ),
        ),
      ),
    );
  }

  Future<void> _onSaveData() async {
    Log.d("Starts _onSaveData ");
    var biography = _controller.text;
    setState(() {
      _isLoading = true; 
    });
    HostUpdateUserBiography().run(user.userId, biography).then((value) {
      setState(() {
      _isLoading = false; 
    });
      if (value) {
        user.biography = biography;
        FlutterToast().showToast("Se ha actualizado tu biografía");
      } else {
        FlutterToast().showToast("No ha sido posible actualizar tu biografía");
      }
    });
  }
}
