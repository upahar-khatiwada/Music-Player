import 'package:flutter/material.dart';

import '../../services/playlist_list.dart';

class Playlists extends StatelessWidget {
  const Playlists({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6c6a6a),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Scrollbar(
          child: ListView.builder(
            itemCount: playlist_list.length,
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
                    playlist_list[index],
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
