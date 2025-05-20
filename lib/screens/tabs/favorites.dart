import 'package:flutter/material.dart';
import 'package:music_player/services/home_page_tab_services/favorite_songs.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  Widget build(BuildContext context) {
    if (favoriteSongs.isNotEmpty) {
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
                    leading: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.favorite, color: Colors.red),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Tooltip(
                            message: favoriteSongs.elementAt(index),
                            child: Text(
                              favoriteSongs.elementAt(index),
                              style: TextStyle(color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              softWrap: false,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.play_circle,
                            color: Colors.white,
                            size: 27,
                          ),
                          onPressed: () {},
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
    } else {
      return Center(
        child: Text(
          'No favorites found!',
          style: TextStyle(color: Colors.white, fontSize: 40),
        ),
      );
    }
  }
}
