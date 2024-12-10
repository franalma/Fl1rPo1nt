import 'dart:async';

import 'package:app/comms/model/request/user/audios/HostGetUserAudiosRequest.dart';
import 'package:app/model/FileData.dart';
import 'package:app/ui/elements/FlexibleAppBar.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';

class ShowContactAudiosPage extends StatefulWidget {
  String userId;
  ShowContactAudiosPage(this.userId);

  @override
  State<ShowContactAudiosPage> createState() {
    return _ShowContactAudiosPage();
  }
}

class _ShowContactAudiosPage extends State<ShowContactAudiosPage> {
  int? _currentlyPlayingIndex;

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isLoading = false;

  // List of audio files or URLs
  List<FileData> _audioList = [];

  @override
  void initState() {
    Log.d("-->initState ${widget.userId}");
    super.initState();
    _fetchAudiosFromHost();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: FlexibleAppBar(),
        ),
        body: _isLoading ? _buildLoading() : _buildBody());
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildBody() {
    return ListView.builder(
        itemCount: _audioList.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                title: Text("Audio $index"),
                trailing: IconButton(
                  icon: Icon(
                    _currentlyPlayingIndex == index
                        ? Icons.stop
                        : Icons.play_arrow,
                  ),
                  onPressed: () {
                    if (_currentlyPlayingIndex == index) {
                      _stopAudio();
                    } else {
                      _playAudio(index);
                    }
                  },
                ),
              ),
              const Divider()
            ],
          );
        });
  }

  Future<void> _playAudio(int index) async {
    try {
      Log.d("-->url: ${_audioList[index].url}");
      setState(() {
        _currentlyPlayingIndex = index;
      });
      await _audioPlayer.setUrl(_audioList[index].url!);
      await _audioPlayer.play();
    } catch (error) {
      Log.d(error.toString());
    }
  }

  Future<void> _stopAudio() async {
    try {
      setState(() {
        _currentlyPlayingIndex = null;
      });
    } catch (error) {
      Log.d(error.toString());
    }
    await _audioPlayer.stop();
  }

  Future<void> _fetchAudiosFromHost() async {
    Log.d("Starts _fetchAudiosFromHost");
    setState(() {
      _isLoading = true;
    });
    HostGetUserAudiosRequest().run(widget.userId).then((response) {
      if (response.fileList != null) {
        _audioList = response.fileList!;
      }
      setState(() {
        _isLoading = false;
      });
    });
  }
}
