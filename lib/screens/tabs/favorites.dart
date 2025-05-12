import 'package:flutter/material.dart';
import 'package:music_player/services/favorite_songs.dart';

class Favorites extends StatelessWidget {
  const Favorites({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6c6a6a),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Scrollbar(
          child: ListView.builder(
            itemCount: favoriteSongs.length,
            itemBuilder: (context, index) {
              return Card(
                clipBehavior: Clip.hardEdge,
                color: Color(0xFF464343),
                child: ListTile(
                  onTap: () {},
                  focusColor: Colors.grey,
                  splashColor: Colors.white10,
                  leading: GestureDetector(
                    onTap: () {},
                    child: Icon(Icons.favorite, color: Colors.red),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            favoriteSongs[index],
                            style: TextStyle(color: Colors.white),
                          ),
                          Text('4:30', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      GestureDetector(
                        child: Icon(
                          Icons.play_circle,
                          color: Colors.white,
                          size: 27,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
