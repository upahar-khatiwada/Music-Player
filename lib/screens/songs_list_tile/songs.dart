// This file is responsible for getting the songs from the local storage

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/services/constants/constant_vars.dart';
import 'package:music_player/services/helper_functions/play_audio_from_local_storage.dart';
import 'package:music_player/services/folder_containing_songs_info/file_for_handling_song_playing_icons.dart';
import 'package:music_player/services/folder_containing_songs_info/music_list.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:music_player/screens/mini_player/mini_player.dart';
import 'package:logger/logger.dart';
import 'package:music_player/services/helper_functions/format_duration.dart';
import 'package:lottie/lottie.dart';

final Logger logger = Logger();

// Selects the next shuffled index
int shuffledIndexPointer = 0;

class Songs extends StatefulWidget {
  final List<SongModel> songs;
  const Songs({super.key, required this.songs});

  @override
  State<Songs> createState() => _SongsState();
}

class _SongsState extends State<Songs> {
  bool showMiniPlayer = false; // boolean to show the miniPlayer
  int? currentSongIndex; // grabs the current song's index from the list
  AudioPlayer audioPlayer = AudioPlayer();
  bool isShuffled = false;
  bool isLooping = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    audioPlayer.processingStateStream.listen((ProcessingState state) {
      if (state == ProcessingState.completed) {
        onSongComplete();
      }
    });

    // Sync's the notification bar's play/pause with main app's play/pause
    audioPlayer.playerStateStream.listen((PlayerState playerState) {
      final bool isPlayingNow = playerState.playing;

      if (currentSongIndex != null) {
        setState(() {
          isPlaying[currentSongIndex!] = isPlayingNow;
          playButton[currentSongIndex!] =
              isPlayingNow ? Icons.pause_circle : Icons.play_circle;
        });
      }
    });
  }

  void setMiniPlayerOffset() {
    miniPlayerOffset = Offset(0, MediaQuery.of(context).size.height * 0.515);
  }

  void onPlaySong(int index, SongModel song) {
    setState(() {
      if (currentSongIndex != index) {
        currentSongIndex = index;
        showMiniPlayer = true;
        setMiniPlayerOffset();

        for (int i = 0; i < isPlaying.length; i++) {
          isPlaying[i] = false;
          playButton[i] = Icons.play_circle;
        }

        isPlaying[index] = true;
        playButton[index] = Icons.pause_circle;

        playAudioFromLocalStorage(
          audioPlayer,
          song.uri,
          song.id,
          song.album,
          song.displayNameWOExt,
        );
      } else {
        isPlaying[index] = !isPlaying[index];
        playButton[index] =
            isPlaying[index] ? Icons.pause_circle : Icons.play_circle;

        if (isPlaying[index]) {
          audioPlayer.play();
        } else {
          audioPlayer.pause();
        }
      }
    });
  }

  void onLoop() async {
    setState(() {
      isLooping = !isLooping;
    });
    if (isLooping) {
      await audioPlayer.setLoopMode(LoopMode.one);
    } else {
      await audioPlayer.setLoopMode(LoopMode.off);
    }
  }

  void onShuffle() {
    setState(() {
      isShuffled = !isShuffled;

      if (isShuffled) {
        shuffledIndices = List<int>.generate(
          musicFromLocalStorage!.length,
          (int index) => index,
        );
        shuffledIndices.shuffle();
        logger.i('Shuffled indexes: $shuffledIndices');
      } else {
        shuffledIndices.clear();
      }
    });
  }

  void onSongComplete() {
    try {
      if (currentSongIndex != null &&
          currentSongIndex! < musicFromLocalStorage!.length) {
        setState(() {
          if (currentSongIndex != null &&
              currentSongIndex! < musicFromLocalStorage!.length - 1) {
            logger.i(
              'Before isShuffled if condition, currentSongIndex: $currentSongIndex',
            );
            if (isShuffled) {
              if (shuffledIndexPointer < shuffledIndices.length - 1) {
                shuffledIndexPointer++;
                onPlaySong(
                  shuffledIndices[shuffledIndexPointer],
                  musicFromLocalStorage![shuffledIndices[shuffledIndexPointer]],
                );
              }
            } else {
              onPlaySong(
                currentSongIndex! + 1,
                musicFromLocalStorage![currentSongIndex! + 1],
              );
            }
          }
        });
        // logger.i('Current song index: ${currentSongIndex!}');
        // logger.i('Previous song index: ${currentSongIndex! - 1}');
      }
    } catch (e) {
      logger.e('Error while switching songs: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<SongModel> songs = widget.songs;

    if (songs.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    musicFromLocalStorage = songs;

    if (playButton.length != songs.length) {
      playButton = List<IconData>.filled(songs.length, Icons.play_circle);
    }
    if (isPlaying.length != songs.length) {
      isPlaying = List<bool>.filled(songs.length, false);
    }

    return Stack(
      children: <Widget>[
        musicFromLocalStorage == null
            ? const CircularProgressIndicator(color: Colors.white)
            : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Scrollbar(
                child: ListView.builder(
                  itemCount: songs.length,
                  itemBuilder: (BuildContext context, int index) {
                    final SongModel song = songs[index];

                    return Card(
                      clipBehavior: Clip.hardEdge,
                      color: appbarColor,
                      child: ListTile(
                        onTap: () {},
                        focusColor: Colors.grey,
                        splashColor: Colors.white10,
                        leading:
                            isPlaying[index]
                                ? Lottie.asset('assets/spotify_waves.json')
                                : Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    color:
                                        (currentSongIndex == index)
                                            ? Colors.greenAccent
                                            : Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                        0.045,
                                  ),
                                ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              child: Tooltip(
                                message: song.displayName,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      song.displayNameWOExt,
                                      style: TextStyle(
                                        color:
                                            (currentSongIndex == index)
                                                ? Colors.greenAccent
                                                : Colors.white,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                            0.039,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      formatDuration(
                                        song.duration?.toDouble() ?? 0,
                                      ),
                                      style: TextStyle(
                                        color: Colors.grey[300],
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                            0.035,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => onPlaySong(index, song),
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
            ),

        if (showMiniPlayer)
          Positioned(
            left: miniPlayerOffset.dx,
            top: miniPlayerOffset.dy,
            child: GestureDetector(
              onPanUpdate: (DragUpdateDetails details) {
                setState(() {
                  miniPlayerOffset += details.delta;
                });
              },
              child: MiniPlayerHome(
                isPlayPressed:
                    currentSongIndex != null
                        ? isPlaying[currentSongIndex!]
                        : false,
                songModel:
                    currentSongIndex != null
                        ? musicFromLocalStorage![currentSongIndex!]
                        : null,
                icon:
                    currentSongIndex != null
                        ? playButton[currentSongIndex!]
                        : Icons.play_circle,
                audioPlayer: audioPlayer,
                onPlayPause: () {
                  setState(() {
                    if (currentSongIndex != null) {
                      isPlaying[currentSongIndex!] =
                          !isPlaying[currentSongIndex!];
                      playButton[currentSongIndex!] =
                          isPlaying[currentSongIndex!]
                              ? Icons.pause_circle
                              : Icons.play_circle;

                      if (isPlaying[currentSongIndex!]) {
                        audioPlayer.play();
                      } else {
                        audioPlayer.pause();
                      }
                    }
                  });
                },
                onSkipPrevious: () {
                  if (currentSongIndex != null && currentSongIndex != 0) {
                    if (isShuffled) {
                      if (shuffledIndexPointer > 0) {
                        shuffledIndexPointer--;
                        int prevIndex = shuffledIndices[shuffledIndexPointer];
                        onPlaySong(
                          prevIndex,
                          musicFromLocalStorage![prevIndex],
                        );
                      }
                    } else {
                      if (currentSongIndex == 0) {
                        onPlaySong(
                          musicFromLocalStorage!.length - 1,
                          musicFromLocalStorage!.last,
                        );
                      } else {
                        onPlaySong(
                          currentSongIndex! - 1,
                          musicFromLocalStorage![currentSongIndex! - 1],
                        );
                      }
                    }
                  }
                },
                onSkipNext: () {
                  if (currentSongIndex != null) {
                    if (isShuffled) {
                      if (shuffledIndexPointer < shuffledIndices.length - 1) {
                        shuffledIndexPointer++;
                        onPlaySong(
                          shuffledIndices[shuffledIndexPointer],
                          musicFromLocalStorage![shuffledIndices[shuffledIndexPointer]],
                        );
                      }
                    }
                    if (currentSongIndex ==
                        (musicFromLocalStorage!.length) - 1) {
                      onPlaySong(0, musicFromLocalStorage![0]);
                      return;
                    }
                    onPlaySong(
                      currentSongIndex! + 1,
                      musicFromLocalStorage![currentSongIndex! + 1],
                    );
                  }
                },
                onShuffle: onShuffle,
                isShuffleClicked: isShuffled,
                isLoopClicked: isLooping,
                onLoop: onLoop,
              ),
            ),
          ),

        // Code block before adding drag feature
        // Visibility(
        //   visible: showMiniPlayer,
        //   child: MiniPlayerHome(
        //     isPlayPressed:
        //         currentSongIndex != null ? isPlaying[currentSongIndex!] : false,
        //     songModel:
        //         currentSongIndex != null
        //             ? musicFromLocalStorage![currentSongIndex!]
        //             : null,
        //     icon:
        //         currentSongIndex != null
        //             ? playButton[currentSongIndex!]
        //             : Icons.play_circle,
        //     audioPlayer: audioPlayer,
        //     onPlayPause: () {
        //       setState(() {
        //         if (currentSongIndex != null) {
        //           isPlaying[currentSongIndex!] = !isPlaying[currentSongIndex!];
        //           playButton[currentSongIndex!] =
        //               isPlaying[currentSongIndex!]
        //                   ? Icons.pause_circle
        //                   : Icons.play_circle;
        //
        //           if (isPlaying[currentSongIndex!]) {
        //             audioPlayer.play();
        //           } else {
        //             audioPlayer.pause();
        //           }
        //         }
        //       });
        //     },
        //     onSkipPrevious: () {
        //       if (currentSongIndex != null && currentSongIndex != 0) {
        //         if (isShuffled) {
        //           if (shuffledIndexPointer > 0) {
        //             shuffledIndexPointer--;
        //             int prevIndex = shuffledIndices[shuffledIndexPointer];
        //             onPlaySong(prevIndex, musicFromLocalStorage![prevIndex]);
        //           }
        //         } else {
        //           if (currentSongIndex == 0) {
        //             onPlaySong(
        //               musicFromLocalStorage!.length - 1,
        //               musicFromLocalStorage!.last,
        //             );
        //           } else {
        //             onPlaySong(
        //               currentSongIndex! - 1,
        //               musicFromLocalStorage![currentSongIndex! - 1],
        //             );
        //           }
        //         }
        //       }
        //     },
        //     onSkipNext: () {
        //       if (currentSongIndex != null) {
        //         if (isShuffled) {
        //           if (shuffledIndexPointer < shuffledIndices.length - 1) {
        //             shuffledIndexPointer++;
        //             onPlaySong(
        //               shuffledIndices[shuffledIndexPointer],
        //               musicFromLocalStorage![shuffledIndices[shuffledIndexPointer]],
        //             );
        //           }
        //         }
        //         if (currentSongIndex == (musicFromLocalStorage!.length) - 1) {
        //           onPlaySong(0, musicFromLocalStorage![0]);
        //           return;
        //         }
        //         onPlaySong(
        //           currentSongIndex! + 1,
        //           musicFromLocalStorage![currentSongIndex! + 1],
        //         );
        //       }
        //     },
        //     onShuffle: onShuffle,
        //     isShuffleClicked: isShuffled,
        //     isLoopClicked: isLooping,
        //     onLoop: onLoop,
        //   ),
        // ),
      ],
    );
  }
}

// CODE BEFORE ADDING SEARCH BAR FUNCTIONALITY
//   @override
//   Widget build(BuildContext context) {
//     // stack for handling the mini player
//     return Stack(
//       children: <Widget>[
//         // This future fetches the device's songs and might build the UI multiple times
//         FutureBuilder<List<SongModel>>(
//           future: _audioQuery.querySongs(
//             sortType: null,
//             ignoreCase: true,
//             orderType: OrderType.ASC_OR_SMALLER,
//             uriType: UriType.EXTERNAL,
//           ),
//           builder: (BuildContext context, AsyncSnapshot<List<SongModel>> item) {
//             // error handling
//             if (item.data == null) {
//               return const Center(
//                 child: CircularProgressIndicator(color: Colors.white),
//               );
//             }
//             // error handling
//             if (item.data!.isEmpty) {
//               return const Center(
//                 child: Text(
//                   'No songs found!',
//                   style: TextStyle(color: Colors.white),
//                 ),
//               );
//             }
//             // Assigning the available music
//             musicFromLocalStorage = item.data!;
//             // if condition to avoid rebuilding the list
//             if (favoriteSongsLiked.length != item.data!.length) {
//               favoriteSongsLiked = List<Color>.filled(
//                 item.data!.length,
//                 unLiked,
//               );
//             }
//             // if condition to avoid rebuilding the list for the playButton's icon
//             if (playButton.length != item.data!.length) {
//               playButton = List<IconData>.filled(
//                 item.data!.length,
//                 Icons.play_circle,
//               );
//             }
//             // if condition to avoid rebuilding the list for playButton's boolean
//             if (isPlaying.length != item.data!.length) {
//               isPlaying = List<bool>.filled(item.data!.length, false);
//             }
//
//             // debugging/checking
//             // logger.i(musicFromLocalStorage);
//             // logger.i(favoriteSongsLiked);
//             // for (SongModel song in musicFromLocalStorage!) {
//             //   logger.i('title: ${song.displayNameWOExt}');
//             // }
//
//             // Main UI building logic
//             return Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: Scrollbar(
//                 child: ListView.builder(
//                   primary: true,
//                   itemCount: item.data!.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     return Card(
//                       clipBehavior: Clip.hardEdge,
//                       color: appbarColor,
//                       child: ListTile(
//                         onTap: () {},
//                         focusColor: Colors.grey,
//                         splashColor: Colors.white10,
//                         leading: IconButton(
//                           onPressed: () {
//                             favoriteSongsLiked[index] =
//                                 favoriteSongsLiked[index] == liked
//                                     ? unLiked
//                                     : liked;
//                             favoriteSongsLiked[index] == liked
//                                 ? favoriteSongs.add(
//                                   item.data![index].displayNameWOExt,
//                                 )
//                                 : favoriteSongs.remove(
//                                   item.data![index].displayNameWOExt,
//                                 );
//                             // rebuilds the UI and changes the icon's color to red
//                             setState(() {});
//                           },
//                           icon: Icon(
//                             Icons.favorite,
//                             color: favoriteSongsLiked[index],
//                           ),
//                         ),
//                         title: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: <Widget>[
//                             Flexible(
//                               child: Tooltip(
//                                 message: item.data![index].displayName,
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Text(
//                                       item.data![index].displayNameWOExt,
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize:
//                                             MediaQuery.of(context).size.width *
//                                             0.039,
//                                       ),
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                     Text(
//                                       formatDuration(
//                                         item.data![index].duration
//                                                 ?.toDouble() ??
//                                             0,
//                                       ),
//                                       style: TextStyle(
//                                         color: Colors.grey[300],
//                                         fontSize:
//                                             MediaQuery.of(context).size.width *
//                                             0.035,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             IconButton(
//                               onPressed: () {
//                                 setState(() {
//                                   // bool isCurrentlyPlaying = isPlaying[index];
//
//                                   // Checking if a song song is clicked or not
//                                   if (currentSongIndex != index) {
//                                     // If new song is clicked, this updates the icons for current song and other songs
//                                     currentSongIndex = index;
//                                     showMiniPlayer = true;
//
//                                     for (int i = 0; i < isPlaying.length; i++) {
//                                       isPlaying[i] = false;
//                                       playButton[i] = Icons.play_circle;
//                                     }
//
//                                     isPlaying[index] = true;
//                                     playButton[index] = Icons.pause_circle;
//
//                                     // play the new song
//                                     playAudioFromLocalStorage(
//                                       audioPlayer,
//                                       item.data![index].uri,
//                                     );
//                                   } else {
//                                     // handling the same song clicked
//                                     isPlaying[index] = !isPlaying[index];
//                                     playButton[index] =
//                                         isPlaying[index]
//                                             ? Icons.pause_circle
//                                             : Icons.play_circle;
//
//                                     if (isPlaying[index]) {
//                                       audioPlayer.play();
//                                     } else {
//                                       audioPlayer.pause();
//                                     }
//                                   }
//                                 });
//                                 //// Old code - doesn't pause the song correctly
//                                 // setState(() {
//                                 //   // for changing icons
//                                 //   bool isCurrentlyPlaying = isPlaying[index];
//                                 //
//                                 //   showMiniPlayer = true;
//                                 //
//                                 //   // responsible for changing previous song's pause button back to play button when a new song is played
//                                 //   // changes every boolean to false
//                                 //   for (int i = 0; i < isPlaying.length; i++) {
//                                 //     isPlaying[i] = false;
//                                 //     playButton[i] = Icons.play_circle;
//                                 //   }
//                                 //   currentSongIndex = index;
//                                 //   if (!isCurrentlyPlaying) {
//                                 //     isPlaying[index] = true;
//                                 //     playButton[index] = Icons.pause_circle;
//                                 //     playAudioFromLocalStorage(
//                                 //       audioPlayer,
//                                 //       item.data![index].uri,
//                                 //     );
//                                 //   } else {
//                                 //     isPlaying[index] = false;
//                                 //     playButton[index] = Icons.play_circle;
//                                 //     pauseAudioFromLocalStorage(audioPlayer);
//                                 //   }
//                                 // });
//                               },
//                               icon: Icon(
//                                 playButton[index],
//                                 size: 28,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             );
//           },
//         ),
//         // Only gets shown when a song is played
//         // for displaying the miniPlayer
//         Visibility(
//           visible: showMiniPlayer,
//           child: Align(
//             alignment: Alignment.bottomCenter,
//             child: MiniPlayerHome(
//               isPlayPressed:
//                   currentSongIndex != null
//                       ? isPlaying[currentSongIndex!]
//                       : false,
//               songModel:
//                   currentSongIndex != null
//                       ? (musicFromLocalStorage?[currentSongIndex!])
//                       : null,
//               icon:
//                   currentSongIndex != null
//                       ? playButton[currentSongIndex!]
//                       : Icons.play_circle,
//               audioPlayer: audioPlayer,
//               onPlayPause: () {
//                 setState(() {
//                   if (currentSongIndex != null) {
//                     isPlaying[currentSongIndex!] =
//                         !isPlaying[currentSongIndex!];
//                     playButton[currentSongIndex!] =
//                         isPlaying[currentSongIndex!]
//                             ? Icons.pause_circle
//                             : Icons.play_circle;
//
//                     if (isPlaying[currentSongIndex!]) {
//                       audioPlayer.play();
//                     } else {
//                       audioPlayer.pause();
//                     }
//                   }
//                 });
//               },
//               // onPlayPause: onPlayPause,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
