// This file is responsible for getting the songs from the local storage

import 'package:flutter/material.dart';
import 'package:music_player/services/constants/constant_vars.dart';
import 'package:music_player/services/home_page_tab_services/favorite_songs.dart';
import 'package:music_player/services/home_page_tab_services/music_list.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:music_player/screens/mini_player/mini_player.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class Songs extends StatefulWidget {
  const Songs({super.key});

  @override
  State<Songs> createState() => _SongsState();
}

class _SongsState extends State<Songs> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  bool showMiniPlayer = false; // boolean to show the miniPlayer
  String currentSongTitle = ''; // grabs the current song's title
  int? currentSongDuration; // grabs the current song's duration in int
  int? currentSongIndex; // grabs the current song's index from the list
  late double
  currentDurationDouble; // Converting the duration to double for managing the slider

  @override
  void initState() {
    // converts the duration to double
    currentDurationDouble = (currentSongDuration ?? 0) / 1000.0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // stack for handling the mini player
    return Stack(
      children: [
        // This future fetches the device's songs and might build the UI multiple times
        FutureBuilder<List<SongModel>>(
          future: _audioQuery.querySongs(
            sortType: null,
            ignoreCase: true,
            orderType: OrderType.ASC_OR_SMALLER,
            uriType: UriType.EXTERNAL,
          ),
          builder: (context, item) {
            // error handling
            if (item.data == null) {
              return Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }
            // error handling
            if (item.data!.isEmpty) {
              return Center(
                child: Text(
                  'No songs found!',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
            // Assigning the available music
            musicFromLocalStorage = item.data!;

            // if condition to avoid rebuilding the list
            if (favoriteSongsLiked.length != item.data!.length) {
              favoriteSongsLiked = List<Color>.filled(
                item.data!.length,
                unLiked,
              );
            }
            // if condition to avoid rebuilding the list for the playButton's icon
            if (playButton.length != item.data!.length) {
              playButton = List<IconData>.filled(
                item.data!.length,
                Icons.play_circle,
              );
            }
            // if condition to avoid rebuilding the list for playButton's boolean
            if (isPlaying.length != item.data!.length) {
              isPlaying = List<bool>.filled(item.data!.length, false);
            }

            // debugging/checking
            logger.i(musicFromLocalStorage);
            logger.i(favoriteSongsLiked);
            for (var song in musicFromLocalStorage!) {
              logger.i('title: ${song.displayName}');
            }

            // Main UI building logic
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Scrollbar(
                child: ListView.builder(
                  primary: true,
                  itemCount: item.data!.length,
                  itemBuilder: (context, index) {
                    return Card(
                      clipBehavior: Clip.hardEdge,
                      color: appbarColor,
                      child: ListTile(
                        onTap: () {},
                        focusColor: Colors.grey,
                        splashColor: Colors.white10,
                        leading: IconButton(
                          onPressed: () {
                            favoriteSongsLiked[index] =
                                favoriteSongsLiked[index] == liked
                                    ? unLiked
                                    : liked;
                            favoriteSongsLiked[index] == liked
                                ? favoriteSongs.add(
                                  item.data![index].displayName,
                                )
                                : favoriteSongs.remove(
                                  item.data![index].displayName,
                                );
                            // rebuilds the UI and changes the icon's color to red
                            setState(() {});
                          },
                          icon: Icon(
                            Icons.favorite,
                            color: favoriteSongsLiked[index],
                          ),
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Tooltip(
                                message: item.data![index].displayName,
                                child: Text(
                                  item.data![index].displayNameWOExt,
                                  style: TextStyle(color: Colors.white),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  showMiniPlayer = true;
                                  currentSongTitle =
                                      item.data![index].displayName;
                                  currentSongDuration =
                                      item.data![index].duration;
                                  // responsible for changing previous song's pause button back to play button when a new song is played
                                  // changes every boolean to false
                                  for (int i = 0; i < isPlaying.length; i++) {
                                    isPlaying[i] = false;
                                    playButton[i] = Icons.play_circle;
                                  }
                                  // finally assigns the selected song's boolean to true to change to pause icon
                                  isPlaying[index] = true;
                                  playButton[index] = Icons.pause_circle;
                                  currentSongIndex = index;
                                });
                              },
                              icon: Icon(
                                playButton[index],
                                size: 28,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
        // Only gets shown when a song is played
        // for displaying the miniPlayer
        Visibility(
          visible: showMiniPlayer,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: MiniPlayerHome(
              songTitle: currentSongTitle,
              songDurationDouble: currentDurationDouble,
              isPlayPressed:
                  currentSongIndex != null
                      ? isPlaying[currentSongIndex!]
                      : false,
            ),
          ),
        ),
      ],
    );
  }
}
