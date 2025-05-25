// file to handle the backend

import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:logger/logger.dart';

final Logger logger = Logger();
void playAudioFromLocalStorage(
  AudioPlayer player,
  String? audioPath,
  int songID,
  String? albumName,
  String? songTitle,
) async {
  try {
    await player.setAudioSource(
      AudioSource.uri(
        Uri.parse(audioPath!),
        tag: MediaItem(
          // Specify a unique ID for each media item:
          id: songID.toString(),
          // Metadata to display in the notification:
          album: albumName ?? '',
          title: songTitle ?? '',
          // artUri: Uri.parse('https://example.com/albumart.jpg'),
        ),
      ),
    );
    await player.seek(Duration.zero);
    await player.play();
  } catch (e) {
    logger.e('Error playing song: $e');
  }
}

void pauseAudioFromLocalStorage(AudioPlayer player) async {
  try {
    await player.pause();
  } catch (e) {
    logger.e('Error pausing song: $e');
  }
}
