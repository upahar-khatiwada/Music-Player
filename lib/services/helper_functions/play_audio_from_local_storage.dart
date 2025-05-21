// file to handle the backend

import 'package:just_audio/just_audio.dart';
import 'package:logger/logger.dart';

final Logger logger = Logger();
void playAudioFromLocalStorage(AudioPlayer player, String? audioPath) async {
  try {
    await player.setAudioSource(AudioSource.uri(Uri.parse(audioPath!)));
    await player.play();
  } catch (e) {
    logger.e('Error playing song: $e');
  }
}

void pauseAudioFromLocalStorage(AudioPlayer player, String? audioPath) async {
  try {
    await player.pause();
  } catch (e) {
    logger.e('Error pausing song: $e');
  }
}
