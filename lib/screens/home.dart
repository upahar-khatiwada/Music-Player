import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_player/screens/tabs/favorites.dart';
import 'package:music_player/screens/tabs/playlists.dart';
import 'package:music_player/screens/tabs/songs.dart';
import 'package:music_player/services/unfocusOnTap.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final TextEditingController _textController;
  late final FocusNode _focusNode;
  late final ScrollController _scrollController;

  @override
  void initState() {
    // Controller for the 3 different tabs
    _tabController = TabController(
      length: 3,
      vsync: this,
      animationDuration: Duration(milliseconds: 400),
    );

    // Controller for the text in Search Bar
    _textController = TextEditingController();

    // Focus Node for focusing in the search bar
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
    return UnfocusOnTap(
      child: Scaffold(
        backgroundColor: Color(0xFF6c6a6a),
        appBar: AppBar(
          leading: Icon(Icons.menu, color: Colors.white),
          title: Text(
            'Music Player',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Color(0xFF464343),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.black,
            statusBarBrightness: Brightness.dark,
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 1.1,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      color: Color(0xFF464343),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 2,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(12),
                        suffixIcon: Icon(Icons.search, color: Colors.white),
                        hintText: 'Search songs..',
                        hintStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.white38,
                            width: 1,
                          ),
                        ),
                        focusColor: Colors.white38,
                      ),
                      controller: _textController,
                      style: TextStyle(color: Colors.white),
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
                  splashBorderRadius: BorderRadius.all(Radius.circular(10)),
                  overlayColor: WidgetStatePropertyAll(Colors.white38),
                  controller: _tabController,
                  indicatorColor: Colors.white,
                  indicator: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.white, width: 2),
                    ),
                  ),
                  tabs: [
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
                    children: [Songs(), Favorites(), Playlists()],
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
