// This tab holds the favorites songs of the user

import 'package:auto_scroll_text/auto_scroll_text.dart';
import 'package:flutter/material.dart';
import 'package:music_player/services/constants/constant_vars.dart';
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
        backgroundColor: bgColor,
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Scrollbar(
            child: ListView.builder(
              itemCount: favoriteSongs.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  clipBehavior: Clip.hardEdge,
                  color: appbarColor,
                  child: ListTile(
                    onTap: () {},
                    focusColor: Colors.grey,
                    splashColor: Colors.white10,
                    leading: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.favorite, color: Colors.red),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Tooltip(
                            message: favoriteSongs.elementAt(index),
                            child: Text(
                              favoriteSongs.elementAt(index),
                              style: const TextStyle(color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              softWrap: false,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              const Icon(Icons.close, color: Colors.red, size: 50),
              const SizedBox(width: 10),
              FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  'No favorites found!',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.03,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
