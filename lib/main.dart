import 'package:flutter/material.dart';
import 'package:music_player/screens/home.dart';
import 'package:music_player/screens/playlist_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
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
      },
      theme: ThemeData(splashColor: Colors.white, primaryColor: Colors.white),
    );
  }
}
