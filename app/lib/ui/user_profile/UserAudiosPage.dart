import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:app/comms/model/request/user/audios/HostUploadAudioRequest.dart';
import 'package:app/model/BufferAudioSource.dart';
import 'package:app/model/FileData.dart';
import 'package:app/model/Session.dart';
import 'package:app/model/User.dart';
import 'package:app/ui/elements/DefaultModalDialog.dart';
import 'package:app/ui/elements/FlexibleAppBar.dart';
import 'package:app/ui/elements/SlideRowLeft.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:app/ui/utils/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:just_audio/just_audio.dart';

import 'package:permission_handler/permission_handler.dart';

import '../../comms/model/request/user/audios/HostGetUserAudiosRequest.dart';
import '../../comms/model/request/user/audios/HostRemoveAudioRequest.dart';

class UserAudiosPage extends StatefulWidget {
  @override
  State<UserAudiosPage> createState() {
    return _UserAudiosPage();
  }
}

class _UserAudiosPage extends State<UserAudiosPage> {
  FlutterSoundRecorder? _audioRecorder;
  bool _isRecording = false;
  int? _currentlyPlayingIndex;
  User user = Session.user;
  // final AudioPlayer _audioPlayer = AudioPlayer();
  late AudioPlayer _audioPlayer;
  bool _isLoading = false;

  // List of audio files or URLs
  List<FileData> _audioList = [];
  Timer? _timer;
  int _maxDuration = 60; // Maximum recording duration in seconds
  int maxAudioNumber = 4; 
  int _currentDuration = 0;
  int counter = 0;
  @override
  void initState() {
    super.initState();
    _audioRecorder = FlutterSoundRecorder();
    _audioPlayer = AudioPlayer();
    _initializeRecorder();
    _fetchAudiosFromHost();
  }

  Future<void> _startRecording() async {
    if (_audioList.length < maxAudioNumber) {
      await _audioRecorder!.startRecorder(
        toFile: 'recorded_audio.aac',
        codec: Codec.aacADTS,
      );

      // _timer = Timer(Duration(seconds: _maxDuration), callbackMaxTime);
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (timer.tick >= _maxDuration) {
            callbackMaxTime();
          } else {
            counter++;
          }
        });
      });

      setState(() {
        _isRecording = true;
      });
    } else {
      DefaultModalDialog.showErrorDialog(
          context,
          "Has llegado al máximo de audios",
          "Cerrar",
          FontAwesomeIcons.exclamation);
    }
  }

  Future<void> _initializeRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw 'Microphone permission not granted';
    }

    await _audioRecorder!.openRecorder();
  }

  @override
  void dispose() {
    _audioRecorder!.closeRecorder();
    _audioRecorder = null;
    _audioPlayer.dispose();
    if (_timer != null) {
      _timer!.cancel();
    }
    super.dispose();
  }

  Future<void> _stopRecording() async {
    var filePath = await _audioRecorder!.stopRecorder();
    _timer!.cancel();
    counter = 0; 
    setState(() {
      _isRecording = false;
    });

    if (filePath != null) {
      _saveAudioOnHost(filePath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: FlexibleAppBar(),
          actions: [
            _isRecording
                ? _buildRecordingPanel()
                : IconButton(
                    onPressed: _startRecording,
                    icon: const Icon(Icons.record_voice_over_outlined))
          ],
        ),
        body: _isLoading ? _buildLoading() : _buildBody());
  }

  Widget _buildRecordingPanel() {
    return Row(
      children: [
        
        Text("00:${counter.toString().padLeft(2, '0')}"),
        IconButton(onPressed: _stopRecording, icon: const Icon(Icons.stop))
      ],
    );
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildBody() {
    Log.d("_buildBody: nAudios-> ${_audioList.length}");
    return ListView.builder(
      itemCount: _audioList.length,
      itemBuilder: (context, index) {
        return SlideRowLeft(
          onSlide: () => _onDelete(index),
          child: Column(
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
              Divider()
            ],
          ),
        );
      },
    );
  }

  Future<void> _playAudio(int index) async {
    if (_audioList[index].file != null) {
      Uint8List bytes = base64Decode(_audioList[index].file!);
      try {
        setState(() {
          _currentlyPlayingIndex = index;
        });
        final bufferAudioSource = BufferAudioSource(bytes);
        await _audioPlayer.setAudioSource(bufferAudioSource);
        await _audioPlayer.play();
      } catch (error) {
        Log.d(error.toString());
      }
    } else {
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
  }

  void _onDelete(int index) async {
    Log.d("_onDelete $index");
    setState(() {
      _isLoading = true;
    });
    HostRemoveAudioRequest()
        .run(user.userId, _audioList[index].id!)
        .then((response) {
      if (response) {
        _audioList.removeAt(index);
      }

      setState(() {
        _isLoading = false;
      });
    });
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
    HostGetUserAudiosRequest().run(user.userId).then((response) {
      if (response.fileList != null) {
        _audioList = response.fileList!;
      }
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> _saveAudioOnHost(String path) async {
    Log.d("Starts _saveAudioOnHost:$path");
    setState(() {
      _isLoading = true;
    });
    File file = File(path);
    var bytes = await file.readAsBytes();

    HostUploadAudioRequest().run(user.userId, path).then((fileId) {
      if (fileId.isEmpty) {
        FlutterToast().showToast("No ha sido posible guardar tu audio");
      } else {
        _audioList.add(FileData(fileId, -1, base64Encode(bytes), ""));
      }
      setState(() {
        _isLoading = false;
      });
    });
  }

//TODO
  void checkRecordingLenght() {
    // Timer to track recording duration
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _currentDuration++;
      });

      // Stop recording when max duration is reached
      if (_currentDuration >= _maxDuration) {
        _stopRecording();
      }
    });
  }

  void callbackMaxTime() {
    _stopRecording();
    setState(() {
      _isRecording = false;
    });

    DefaultModalDialog.showErrorDialog(
        context,
        "La duración de los audios no puede superar 1 minuto",
        "Cerrar",
        FontAwesomeIcons.exclamation);
  }
}
