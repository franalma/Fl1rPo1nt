import 'dart:typed_data';

import 'package:just_audio/just_audio.dart';

class BufferAudioSource extends StreamAudioSource {
  final Uint8List buffer;

  BufferAudioSource(this.buffer);

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    start = start ?? 0;
    end = end ?? buffer.length;
    return StreamAudioResponse(
      sourceLength: buffer.length,
      contentLength: end - start,
      offset: start,
      stream: Stream.value(buffer.sublist(start, end)),
      contentType: 'audio/mpeg', // Adjust MIME type based on your audio format
    );
  }
}