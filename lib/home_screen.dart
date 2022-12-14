import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:f_audio/sound_player.dart';
import 'package:f_audio/sound_recorder.dart';
import 'package:f_audio/timer_widget.dart';
import 'package:f_audio/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

final pathToSaveAudio = 'audio_example.aac';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final recorder = SoundRecorder();
  final player = SoundPlayer();
  final timerController = TimerController();

  @override
  void initState() {
    super.initState();
    recorder.init(pathToSaveAudio);
    player.init();
  }

  @override
  void dispose() {
    super.dispose();
    recorder.dispose();
    player.dispose();
  }

  Widget buildPlayerButton() {
    final isPlaying = player.isPlaying;
    final icon = isPlaying ? Icons.stop : Icons.start;
    final text = isPlaying ? 'PLAYING' : "STOPPED";
    final primary = isPlaying ? Colors.green : Colors.red;
    final onPrimary = isPlaying ? Colors.white : Colors.black;

    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(175, 50),
        primary: primary,
        onPrimary: onPrimary,
      ),
      onPressed: () async {
        if (player.isPlaying) {
          await player.stop();
        } else {
          await player.play(pathToSaveAudio);
        }
        setState(() {});
      },
      icon: Icon(icon),
      label: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildRecordButton() {
    final isRecording = recorder.isRecording;
    final icon = isRecording ? Icons.stop : Icons.mic;
    final text = isRecording ? 'STOP' : 'START';
    final primary = isRecording ? Colors.red : Colors.white;
    final onPrimary = isRecording ? Colors.white : Colors.black;

    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(175, 50),
        primary: primary,
        onPrimary: onPrimary,
      ),
      onPressed: () async {
        String? path = await recorder.toggleRecording();
        print(path);
        final isRecording = recorder.isRecording;

        setState(() {});

        if (isRecording) {
          timerController.startTimer();
        } else {
          timerController.stopTimer();
          if (path != null) {
            // Utils.moveFile(File(path), des)
            // print(path);
            // Utils.saveToAppFolder(path, "tai");
            Utils.saveText("hello");
          }
        }
      },
      icon: Icon(icon),
      label: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildPlayer() {
    final text = recorder.isRecording ? 'Now Recording' : 'Press Start';
    final animate = recorder.isRecording;

    return AvatarGlow(
      endRadius: 140,
      animate: animate,
      repeatPauseDuration: Duration(microseconds: 10),
      child: CircleAvatar(
        radius: 100,
        backgroundColor: Colors.white,
        child: CircleAvatar(
          radius: 93,
          backgroundColor: Colors.indigo.shade900.withBlue(70),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.mic, size: 32),
              TimerWidget(controller: timerController),
              const SizedBox(height: 8),
              Text(text),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildPlayer(),
            const SizedBox(height: 16),
            buildRecordButton(),
            const SizedBox(height: 16),
            buildPlayerButton(),
          ],
        ),
      ),
    );
  }
}
