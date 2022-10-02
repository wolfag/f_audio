import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

class SoundRecorder {
  FlutterSoundRecorder? _audioRecorder;
  bool isInited = false;
  String pathToSaveAudio = '';

  bool get isRecording =>
      _audioRecorder != null ? _audioRecorder!.isRecording : false;

  Future init(String path) async {
    pathToSaveAudio = path;
    _audioRecorder = FlutterSoundRecorder();

    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Mic permission deny');
    }

    await _audioRecorder!.openRecorder();
    isInited = true;
  }

  void dispose() {
    _audioRecorder!.closeRecorder();
    _audioRecorder = null;
    isInited = false;
  }

  Future _record() async {
    if (!isInited) return;
    await _audioRecorder!.startRecorder(toFile: pathToSaveAudio);
  }

  Future<String?> _stop() async {
    if (!isInited) return null;
    return await _audioRecorder!.stopRecorder();
  }

  Future<String?> toggleRecording() async {
    if (_audioRecorder!.isStopped) {
      await _record();
    } else {
      return await _stop();
    }
  }
}
