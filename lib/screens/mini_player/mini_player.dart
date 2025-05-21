// This file handles the mini player in the bottom of the screen

import 'package:flutter/material.dart';
import 'package:auto_scroll_text/auto_scroll_text.dart';
import 'package:just_audio/just_audio.dart';
import 'package:logger/logger.dart';
import 'package:music_player/services/constants/constant_vars.dart';
import 'package:on_audio_query/on_audio_query.dart';

final Logger logger = Logger();

class MiniPlayerHome extends StatefulWidget {
  final IconData? icon;
  final SongModel? songModel;
  final bool isPlayPressed;
  final AudioPlayer audioPlayer;
  final VoidCallback onPlayPause;

  const MiniPlayerHome({
    super.key,
    required this.isPlayPressed,
    required this.songModel,
    required this.icon,
    required this.audioPlayer,
    required this.onPlayPause,
  });

  @override
  State<MiniPlayerHome> createState() => _MiniPlayerHomeState();
}

class _MiniPlayerHomeState extends State<MiniPlayerHome> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // pushes a new screen for a better and bigger music playing UI
        Navigator.pushNamed(
          context,
          '/bigPlayScreen',
          arguments: <String, dynamic>{
            'songModel': widget.songModel,
            'isPlayPressed': widget.isPlayPressed,
            'onPlayPause': widget.onPlayPause,
            // 'iconNotifier': widget.iconNotifier,
          },
        );
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.103,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[500],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        // padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                const Icon(Icons.music_note, color: Colors.white, size: 25),
                const SizedBox(width: 10),
                Flexible(
                  // child: Tooltip(
                  //   message: widget.songTitle,
                  child: AutoScrollText(
                    widget.songModel!.displayNameWOExt,
                    style: const TextStyle(fontSize: 19, color: Colors.white),
                    mode: AutoScrollTextMode.endless,
                    // ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.shuffle, color: inShuffle, size: 25),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.skip_previous,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {},
                ),
                // ValueListenableBuilder<IconData>(
                //   valueListenable: widget.iconNotifier,
                //   builder: (BuildContext context, IconData icon, _) {
                //     return IconButton(
                //       icon: Icon(icon, color: Colors.white, size: 30),
                //       onPressed: widget.onPlayPause,
                //     );
                //   },
                // ),
                IconButton(
                  icon: Icon(widget.icon, color: Colors.white, size: 30),
                  onPressed: widget.onPlayPause,
                ),
                IconButton(
                  icon: const Icon(
                    Icons.skip_next,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {},
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.loop, color: inLoop, size: 25),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
