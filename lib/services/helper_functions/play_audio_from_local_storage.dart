// file to handle the backend

import 'package:just_audio/just_audio.dart';
import 'package:music_player/services/helper_functions/flushbar_message.dart';

void playAudioFromLocalStorage(String? audioPath) async {
  final AudioPlayer player = AudioPlayer();
  try {
    player.setAudioSource(AudioSource.uri(Uri.parse(audioPath!)));
    player.play();
  } catch (e) {
    print("Error playing song: $e");
  }
}
