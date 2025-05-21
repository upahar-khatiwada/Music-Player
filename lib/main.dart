import 'package:flutter/material.dart';
import 'package:music_player/screens/home.dart';
import 'package:music_player/screens/playlist_page.dart';
import 'package:music_player/screens/song_play_screen_big/play_song_whole_screen.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  // required for on_audio_query plugin
  // this line makes sure flutter's core engine is fully initialized before anything else
  // it basically sets up internal services
  // it makes sure flutter is ready before anything that depends on flutter engine is called
  WidgetsFlutterBinding.ensureInitialized();
  await requestPermissions();
  runApp(const MyApp());
}

// requests permission for the app at startup
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
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => const Homepage(),
        '/playlist_page': (BuildContext context) => const PlaylistPage(),
        '/bigPlayScreen': (BuildContext context) => const BigPlayScreen(),
      },
      theme: ThemeData(splashColor: Colors.white, primaryColor: Colors.white),
    );
  }
}
