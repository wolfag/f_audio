import 'package:flutter_sound/flutter_sound.dart';

class SoundPlayer {
  FlutterSoundPlayer? _audioPlayer;
  bool isInited = false;

  bool get isPlaying => _audioPlayer != null ? _audioPlayer!.isPlaying : false;

  Future init() async {
    _audioPlayer = FlutterSoundPlayer();

    await _audioPlayer!.openPlayer();
    isInited = true;
  }

  void dispose() {
    _audioPlayer!.closePlayer();
    _audioPlayer = null;
    isInited = false;
  }

  Future play(String path) async {
    if (!isInited) return;
    await _audioPlayer!.startPlayer(fromURI: path);
  }

  Future stop() async {
    if (!isInited) return;
    await _audioPlayer!.stopPlayer();
  }
}
