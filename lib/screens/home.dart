// This page is for the home page

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_player/screens/songs_list_tile/songs.dart';
import 'package:music_player/services/constants/constant_vars.dart';
import 'package:music_player/services/unfocused_on_tap.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:music_player/services/folder_containing_songs_info/music_list.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>
    with SingleTickerProviderStateMixin {
  IconData searchBarIconData = Icons.search;
  // late final TabController _tabController; // The tab controller
  late final TextEditingController
  _textController; // Text controller for handling search bar
  late final FocusNode _focusNode; // for focusing in the search bar
  final OnAudioQuery _audioQuery =
      OnAudioQuery(); // scans the device for finding songs

  List<SongModel> filteredSongModels = <SongModel>[];
  late Offset initialMiniPlayerOffset;

  @override
  void initState() {
    super.initState();
    loadSongs();
    // controller for the text in Search Bar
    _textController = TextEditingController();
    if (musicFromLocalStorage != null) {
      filteredSongModels = musicFromLocalStorage!;
    } else {
      filteredSongModels = <SongModel>[];
    }
    _textController.addListener(filterSongSearch);
    // focus node for focusing in the search bar
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    // _tabController.dispose();
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void loadSongs() async {
    musicFromLocalStorage = await _audioQuery.querySongs(
      sortType: null,
      ignoreCase: true,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
    );

    logger.i('Songs loaded: ${musicFromLocalStorage?.length}');

    setState(() {
      if (_textController.text.isEmpty) {
        filteredSongModels = musicFromLocalStorage!;
      } else {
        filteredSongModels =
            musicFromLocalStorage!
                .where(
                  (SongModel song) => song.displayNameWOExt
                      .toLowerCase()
                      .contains(_textController.text.toLowerCase()),
                )
                .toList();
      }
    });
  }

  void filterSongSearch() {
    final String searchQuery = _textController.text.toLowerCase();
    setState(() {
      if (searchQuery.isEmpty) {
        filteredSongModels = musicFromLocalStorage!;
      } else {
        filteredSongModels =
            musicFromLocalStorage!
                .where(
                  (SongModel song) =>
                      song.displayNameWOExt.toLowerCase().contains(searchQuery),
                )
                .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return UnfocusedOnTap(
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          // for the menu icon's color
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // SizedBox(width: 48.0),
              Icon(Icons.music_note, size: 27, color: Colors.white),
              SizedBox(width: 5),
              Text(
                'Music Player',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2.0,
                ),
              ),
            ],
          ),
          centerTitle: true,
          backgroundColor: appbarColor,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.black,
            statusBarBrightness: Brightness.dark,
          ),
          actions: <Widget>[
            GestureDetector(
              onLongPress: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Resets the mini player!')),
                );
              },
              child: IconButton(
                onPressed: () {
                  initialMiniPlayerOffset = Offset(
                    0,
                    MediaQuery.of(context).size.height * 0.515,
                  );
                  setState(() {
                    miniPlayerOffset = initialMiniPlayerOffset;
                  });
                },
                icon: const Icon(Icons.refresh, color: Colors.red),
              ),
            ),
          ],
        ),

        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                const Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 1.1,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      color: appbarColor,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black.withAlpha(26),
                          spreadRadius: 2,
                          blurRadius: 2,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(12),
                        suffixIcon: IconButton(
                          onPressed: () {
                            _textController.clear();
                            loadSongs();
                          },
                          icon: Icon(searchBarIconData),
                          color: Colors.white,
                        ),
                        hintText: 'Search songs..',
                        hintStyle: const TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.white38,
                            width: 1,
                          ),
                        ),
                        focusColor: Colors.white38,
                      ),
                      controller: _textController,
                      style: const TextStyle(color: Colors.white),
                      autocorrect: false,
                      // autofocus: true,
                      cursorColor: Colors.white,
                      cursorErrorColor: Colors.red,
                      focusNode: _focusNode,
                    ),
                  ),
                ),
                Expanded(child: Songs(songs: filteredSongModels)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
