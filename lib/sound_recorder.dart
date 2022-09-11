import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

final pathToSaveAudio = 'audio_example.aac';

class SoundRecorder {
  FlutterSoundRecorder? _audioRecorder;
  bool isInited = false;

  bool get isRecording =>
      _audioRecorder != null ? _audioRecorder!.isRecording : false;

  Future init() async {
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

  Future _stop() async {
    if (!isInited) return;
    await _audioRecorder!.stopRecorder();
  }

  Future toggleRecording() async {
    if (_audioRecorder!.isStopped) {
      await _record();
    } else {
      await _stop();
    }
  }
}
