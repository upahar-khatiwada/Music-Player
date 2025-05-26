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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              // SizedBox(width: 48.0),
              SizedBox(width: MediaQuery.of(context).size.width * 0.108),
              const Icon(Icons.music_note, size: 27, color: Colors.white),
              SizedBox(width: MediaQuery.of(context).size.width * 0.01),
              const Text(
                'Music Player',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2.0,
                ),
              ),
            ],
          ),
          // centerTitle: true,
          backgroundColor: appbarColor,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.black,
            statusBarBrightness: Brightness.dark,
          ),
        ),
        drawer: Drawer(
          backgroundColor: appbarColor,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  color: bgColor,
                  padding: const EdgeInsets.only(top: 60, bottom: 20),
                  child: const Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.music_note, color: Colors.white, size: 40),
                          SizedBox(width: 10),
                          Text(
                            'MENU',
                            style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 7.0,
                              fontSize: 30,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Material(
                  child: GestureDetector(
                    onLongPress: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: <Widget>[
                              const Icon(
                                Icons.info_outline,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.01,
                              ),
                              const Text(
                                'Resets the mini player back to its original position',
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: ListTile(
                      splashColor: Colors.white38,
                      tileColor: appbarColor,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      leading: const Icon(
                        Icons.refresh,
                        color: Colors.white,
                        size: 30,
                      ),
                      title: const Text(
                        'Reset mini player',
                        style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 1.0,
                          fontSize: 20,
                        ),
                      ),
                      onTap: () {
                        initialMiniPlayerOffset = Offset(
                          0,
                          MediaQuery.of(context).size.height * 0.515,
                        );
                        setState(() {
                          miniPlayerOffset = initialMiniPlayerOffset;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
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
