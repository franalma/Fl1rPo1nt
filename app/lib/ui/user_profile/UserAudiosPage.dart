import 'package:app/ui/utils/Log.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';

import 'package:permission_handler/permission_handler.dart';

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
  final AudioPlayer _audioPlayer = AudioPlayer();

  // List of audio files or URLs
  final List<Map<String, String>> _audioList = [
    {
      "title": "Un poco sobre mí",
      "url": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3"
    },
    {
      "title": "Otra cosita",
      "url": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3"
    },
    {
      "title": "A ver qué tal",
      "url": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3"
    },
  ];

  void initState() {
    super.initState();
    _audioRecorder = FlutterSoundRecorder();
    _initializeRecorder();
  }

  Future<void> _startRecording() async {
    await _audioRecorder!.startRecorder(toFile: 'audio_record.aac');
    setState(() {
      _isRecording = true;
    });
  }

  Future<void> _initializeRecorder() async {
    // Request microphone permission
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
    super.dispose();
  }

  Future<void> _stopRecording() async {
    var filePath = await _audioRecorder!.stopRecorder();
    setState(() {
      _isRecording = false;
    });

    if (filePath != null) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mensajes de voz'),
        actions: [
          _isRecording
              ? IconButton(
                  onPressed: _stopRecording, icon: const Icon(Icons.stop))
              : IconButton(
                  onPressed: _startRecording,
                  icon: const Icon(Icons.record_voice_over_outlined))
        ],
      ),
      body: ListView.builder(
        itemCount: _audioList.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                title: Text(_audioList[index]["title"]!),
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
          );
        },
      ),
    );
  }

  Future<void> _playAudio(int index) async {
    String url = _audioList[index]["url"]!;
    try {
      await _audioPlayer.play(UrlSource(url));
      setState(() {
        _currentlyPlayingIndex = index;
      });
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
}
