import 'package:flutter/material.dart';
import 'package:music_player/services/constants/constant_vars.dart';
import 'package:music_player/services/home_page_tab_services/favorite_songs.dart';
import 'package:music_player/services/home_page_tab_services/music_list.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:music_player/services/helper_functions/play_audio_from_local_storage.dart';
import 'package:music_player/screens/mini_player/miniPlayer.dart';

class Songs extends StatefulWidget {
  const Songs({super.key});

  @override
  State<Songs> createState() => _SongsState();
}

class _SongsState extends State<Songs> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  bool showMiniPlayer = false;
  String currentSongTitle = '';
  int? currentSongDuration;
  int? currentSongIndex;
  late double currentDuration_double;

  @override
  void initState() {
    // TODO: implement initState
    currentDuration_double = (currentSongDuration ?? 0) / 1000.0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FutureBuilder<List<SongModel>>(
          future: _audioQuery.querySongs(
            sortType: null,
            ignoreCase: true,
            orderType: OrderType.ASC_OR_SMALLER,
            uriType: UriType.EXTERNAL,
          ),
          builder: (context, item) {
            if (item.data == null) {
              return Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }
            if (item.data!.isEmpty) {
              return Center(
                child: Text(
                  'No songs found!',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
            // Assigning the available music
            Music_from_local_storage = item.data!;

            // Added if condition to avoid rebuilding the list
            if (favoriteSongsLiked.length != item.data!.length) {
              favoriteSongsLiked = List<Color>.filled(
                item.data!.length,
                unLiked,
              );
            }
            if (playButton.length != item.data!.length) {
              playButton = List<IconData>.filled(
                item.data!.length,
                Icons.play_circle,
              );
            }
            if (isPlaying.length != item.data!.length) {
              isPlaying = List<bool>.filled(item.data!.length, false);
            }
            print(Music_from_local_storage);
            print(favoriteSongsLiked);
            for (var song in Music_from_local_storage!) {
              print("title: ${song.displayName}");
            }
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
                                favoriteSongsLiked[index] == Liked
                                    ? unLiked
                                    : Liked;
                            favoriteSongsLiked[index] == Liked
                                ? favoriteSongs.add(
                                  item.data![index].displayName,
                                )
                                : favoriteSongs.remove(
                                  item.data![index].displayName,
                                );
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

                                  for (int i = 0; i < isPlaying.length; i++) {
                                    isPlaying[i] = false;
                                    playButton[i] = Icons.play_circle;
                                  }

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
        Visibility(
          visible: showMiniPlayer,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: miniPlayerHome(
              songTitle: currentSongTitle,
              songDuration_double: currentDuration_double,
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
