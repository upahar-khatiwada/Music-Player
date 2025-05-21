// file to handle the backend

import 'package:just_audio/just_audio.dart';
import 'package:logger/logger.dart';

final logger = Logger();

void playAudioFromLocalStorage(String? audioPath) async {
  final AudioPlayer player = AudioPlayer();
  try {
    player.setAudioSource(AudioSource.uri(Uri.parse(audioPath!)));
    player.play();
  } catch (e) {
    logger.e('Error playing song: $e');
  }
}
