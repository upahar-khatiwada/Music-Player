import 'package:flutter/material.dart';
import 'package:music_player/screens/home.dart';
import 'package:music_player/screens/playlist_page.dart';
import 'package:music_player/screens/song_play_screen_big/play_song_whole_screen.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestPermissions();
  runApp(const MyApp());
}

Future<void> requestPermissions() async {
  if (await Permission.storage.isDenied ||
      await Permission.audio.isDenied ||
      await Permission.mediaLibrary.isDenied) {
    await [
      Permission.storage,
      Permission.audio,
      Permission.mediaLibrary,
    ].request();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => Homepage(),
        '/playlist_page': (context) => playlistPage(),
        '/bigPlayScreen': (context) => BigPlayScreen(),
      },
      theme: ThemeData(splashColor: Colors.white, primaryColor: Colors.white),
    );
  }
}
