// This file handles the playlists created by the user

import 'package:flutter/material.dart';
import 'package:music_player/services/home_page_tab_services/playlist_list.dart';

class Playlists extends StatefulWidget {
  const Playlists({super.key});

  @override
  State<Playlists> createState() => _PlaylistsState();
}

class _PlaylistsState extends State<Playlists> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6c6a6a),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Scrollbar(
          child: ListView.builder(
            itemCount: playlistList.length,
            itemBuilder: (context, index) {
              return Card(
                clipBehavior: Clip.hardEdge,
                color: Color(0xFF464343),
                child: ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, '/playlist_page');
                  },
                  focusColor: Colors.grey,
                  splashColor: Colors.white10,
                  title: Text(
                    playlistList[index],
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        splashColor: Colors.white10,
        backgroundColor: Color(0xFF464343),
        focusColor: Colors.white10,
        tooltip: 'Add Playlist',
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
