// This file handles the mini player in the bottom of the screen

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:auto_scroll_text/auto_scroll_text.dart';
import 'package:just_audio/just_audio.dart';
import 'package:logger/logger.dart';
import 'package:music_player/services/constants/constant_vars.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:music_player/services/helper_functions/format_duration.dart';

final Logger logger = Logger();

class MiniPlayerHome extends StatefulWidget {
  final IconData? icon; // play/pause icon from parent widget
  final SongModel? songModel; // current song's object
  final bool isPlayPressed; // boolean to check if play button is pressed or not
  final AudioPlayer audioPlayer; // audio player's object
  final VoidCallback onPlayPause; // function to handle play/pause
  final VoidCallback onSkipPrevious; // function to handle skip previous
  final VoidCallback onSkipNext; // function to handle skip next
  final VoidCallback onShuffle; // function to handle shuffle
  final bool isShuffleClicked; // boolean to check if shuffle is pressed
  final bool isLoopClicked; // boolean to check if loop is pressed
  final VoidCallback onLoop; // function to handle looping

  const MiniPlayerHome({
    super.key,
    required this.isPlayPressed,
    required this.songModel,
    required this.icon,
    required this.audioPlayer,
    required this.onPlayPause,
    required this.onSkipPrevious,
    required this.onSkipNext,
    required this.onShuffle,
    required this.isShuffleClicked,
    required this.isLoopClicked,
    required this.onLoop,
  });

  @override
  State<MiniPlayerHome> createState() => _MiniPlayerHomeState();
}

class _MiniPlayerHomeState extends State<MiniPlayerHome> {
  late StreamSubscription<Duration> positionSubscription;
  // late StreamSubscription<Duration> durationSubscription;
  late double? songDuration; // gets the current song's duration
  double currentSliderValue = 0; // current slider's value

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // initializing song's duration
    songDuration = widget.songModel!.duration?.toDouble();
    // logger.i('Formatted: ${formatDuration(songDuration!)}');

    // emits current playback position of the audio as duration
    positionSubscription = widget.audioPlayer.positionStream.listen((
      Duration p,
    ) {
      // setting slider value
      setState(() {
        currentSliderValue = p.inMilliseconds.toDouble();
      });
    });
  }

  // needed when playing a new song as a widget rebuild happens
  @override
  void didUpdateWidget(covariant MiniPlayerHome oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.songModel?.id != oldWidget.songModel?.id) {
      // changes the song's duration's text if a new song is played
      songDuration = widget.songModel?.duration?.toDouble() ?? 0;
      // currentSliderValue = 0;

      logger.i('Updated song: ${widget.songModel?.displayNameWOExt}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: miniPlayerAlignment,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.93,
        height: MediaQuery.of(context).size.height * 0.17,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[500],
          // color: Colors.black,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                const Icon(Icons.music_note, color: Colors.white, size: 25),
                const SizedBox(width: 10),
                Flexible(
                  child: AutoScrollText(
                    widget.songModel!.displayNameWOExt,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.02,
                      color: Colors.white,
                    ),
                    mode: AutoScrollTextMode.endless,
                    // ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Text(
                  formatDuration(currentSliderValue),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.height * 0.02,
                  ),
                ),
                Expanded(
                  child: Slider(
                    value: currentSliderValue.clamp(0, songDuration!),
                    onChanged: (double? val) {
                      setState(() {
                        currentSliderValue = val!;
                      });
                    },
                    onChangeEnd: (double value) {
                      widget.audioPlayer.seek(
                        Duration(milliseconds: value.toInt()),
                      );
                    },
                    activeColor: Colors.greenAccent,
                    inactiveColor: Colors.blueGrey,
                    allowedInteraction: SliderInteraction.tapAndSlide,
                    thumbColor: Colors.white,
                    min: 0,
                    max: songDuration!,
                  ),
                ),
                Text(
                  formatDuration(songDuration!),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.height * 0.02,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  onPressed: widget.onShuffle,
                  icon: Icon(
                    Icons.shuffle,
                    color: widget.isShuffleClicked ? inShuffle : notInShuffle,
                    size: MediaQuery.of(context).size.height * 0.03,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.skip_previous,
                    color: Colors.white,
                    size: MediaQuery.of(context).size.height * 0.03,
                  ),
                  onPressed: widget.onSkipPrevious,
                ),
                IconButton(
                  icon: Icon(
                    widget.icon,
                    color: Colors.white,
                    size: MediaQuery.of(context).size.height * 0.03,
                  ),
                  onPressed: widget.onPlayPause,
                ),
                IconButton(
                  icon: Icon(
                    Icons.skip_next,
                    color: Colors.white,
                    size: MediaQuery.of(context).size.height * 0.03,
                  ),
                  onPressed: widget.onSkipNext,
                ),
                IconButton(
                  onPressed: widget.onLoop,
                  icon: Icon(
                    Icons.loop,
                    color: widget.isLoopClicked ? inLoop : notInLoop,
                    size: MediaQuery.of(context).size.height * 0.03,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
