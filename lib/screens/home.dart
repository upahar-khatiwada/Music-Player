// This page is for the home page

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_player/screens/tabs/favorites.dart';
import 'package:music_player/screens/tabs/playlists.dart';
import 'package:music_player/screens/tabs/songs.dart';
import 'package:music_player/services/constants/constant_vars.dart';
import 'package:music_player/services/unfocused_on_tap.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController; // The tab controller
  late final TextEditingController
  _textController; // Text controller for handling search bar
  late final FocusNode _focusNode; // for focusing in the search bar

  @override
  void initState() {
    // Controller for the 3 different tabs
    _tabController = TabController(
      length: 3,
      vsync: this,
      animationDuration: const Duration(milliseconds: 400),
    );

    // controller for the text in Search Bar
    _textController = TextEditingController();

    // focus node for focusing in the search bar
    _focusNode = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
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
            children: [
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
        ),

        // removed drawer as it was getting complicated to choose custom directory
        // drawer: Drawer(
        //   backgroundColor: Color(0xFF6c6a6a),
        //   child: SingleChildScrollView(
        //     child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.stretch,
        //       children: [
        //         Container(
        //           color: Color(0xFF464343),
        //           padding: EdgeInsets.only(top: 60, bottom: 20),
        //           child: Column(
        //             children: [
        //               Row(
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 children: [
        //                   Icon(Icons.music_note, color: Colors.white, size: 40),
        //                   SizedBox(width: 10),
        //                   Text(
        //                     'MENU',
        //                     style: TextStyle(
        //                       color: Colors.white,
        //                       letterSpacing: 7.0,
        //                       fontSize: 30,
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //               SizedBox(height: 10),
        //             ],
        //           ),
        //         ),
        //         SizedBox(height: 10),
        //         Material(
        //           child: ListTile(
        //             splashColor: Colors.white38,
        //             tileColor: Color(0xFF6c6a6a),
        //             contentPadding: EdgeInsets.symmetric(horizontal: 20),
        //             leading: Icon(Icons.folder, color: Colors.white, size: 30),
        //             title: Text(
        //               'Choose directory',
        //               style: TextStyle(
        //                 color: Colors.white,
        //                 letterSpacing: 1.0,
        //                 fontSize: 20,
        //               ),
        //             ),
        //             onTap: () {
        //               chooseDirectory();
        //               setState(() {});
        //             },
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
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
                      boxShadow: [
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
                        suffixIcon: const Icon(
                          Icons.search,
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
                TabBar(
                  splashFactory: InkRipple.splashFactory,
                  splashBorderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                  overlayColor: const WidgetStatePropertyAll(Colors.white38),
                  controller: _tabController,
                  indicatorColor: Colors.white,
                  indicator: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.white, width: 2),
                    ),
                  ),
                  tabs: const <Widget>[
                    Tab(
                      child: Row(
                        children: [
                          Icon(Icons.music_note, color: Colors.white),
                          SizedBox(width: 3.5),
                          Text('Songs', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      // iconMargin: EdgeInsets.all(10),
                    ),
                    Tab(
                      child: Row(
                        children: [
                          Icon(Icons.favorite, color: Colors.white),
                          SizedBox(width: 3.5),
                          Text(
                            'Favorites',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        children: [
                          Icon(Icons.playlist_play, color: Colors.white),
                          SizedBox(width: 3.5),
                          Text(
                            'Playlist',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Flexible(
                  child: TabBarView(
                    controller: _tabController,
                    children: const <Widget>[Songs(), Favorites(), Playlists()],
                  ),
                  // ListTile(
                  //   leading: Icon(Icons.music_note, color: Colors.white),
                  //   title: Text('Songs', style: TextStyle(color: Colors.white)),
                  // ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
