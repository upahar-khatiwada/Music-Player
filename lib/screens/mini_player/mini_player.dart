// This file handles the mini player in the bottom of the screen

import 'package:flutter/material.dart';
import 'package:auto_scroll_text/auto_scroll_text.dart';

class MiniPlayerHome extends StatefulWidget {
  final String songTitle;
  final songDurationDouble; // data type is double
  final bool isPlayPressed;
  const MiniPlayerHome({
    super.key,
    required this.songTitle,
    required this.songDurationDouble,
    required this.isPlayPressed,
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
          arguments: {
            'songTitle': widget.songTitle,
            'songDuration_double': widget.songDurationDouble,
            'isPlayPressed': widget.isPlayPressed,
          },
        );
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.103,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[500],
        ),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        // padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.music_note, color: Colors.white, size: 25),
                SizedBox(width: 10),
                Flexible(
                  // child: Tooltip(
                  //   message: widget.songTitle,
                  child: AutoScrollText(
                    widget.songTitle,
                    style: TextStyle(fontSize: 19, color: Colors.white),
                    mode: AutoScrollTextMode.endless,
                    // ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.shuffle, color: Colors.white, size: 25),
                ),
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Colors.white,
                    size: 25,
                  ),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.play_arrow, color: Colors.white, size: 32),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                    size: 25,
                  ),
                  onPressed: () {},
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.loop, color: Colors.white, size: 25),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
