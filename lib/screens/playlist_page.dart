// Handles the playlist page

import 'package:flutter/material.dart';

class playlistPage extends StatefulWidget {
  const playlistPage({super.key});

  @override
  State<playlistPage> createState() => _playlistPageState();
}

class _playlistPageState extends State<playlistPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Playlist Page')));
  }
}
