// helper function to format the duration of the song

String formatDuration(double milliseconds) {
  final Duration duration = Duration(milliseconds: milliseconds.toInt());
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  return '${twoDigits(duration.inMinutes)}:${twoDigits(duration.inSeconds.remainder(60))}';
}
