// This file handles the mini player in the bottom of the screen

import 'package:flutter/material.dart';
import 'package:auto_scroll_text/auto_scroll_text.dart';
import 'package:just_audio/just_audio.dart';
import 'package:logger/logger.dart';
import 'package:music_player/services/constants/constant_vars.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:music_player/services/helper_functions/format_duration.dart';

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
  late final double? songDuration;
  double currentSliderValue = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    songDuration = widget.songModel!.duration?.toDouble();
    // logger.i('Formatted: ${formatDuration(songDuration!)}');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.16,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[500],
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
            children: <Widget>[
              Text(
                formatDuration(currentSliderValue),
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
              Expanded(
                child: Slider(
                  value: currentSliderValue,
                  onChanged: (double? val) {
                    setState(() {
                      currentSliderValue = val!;
                    });
                  },
                  activeColor: Colors.white,
                  inactiveColor: Colors.blueGrey,
                  allowedInteraction: SliderInteraction.tapAndSlide,
                  thumbColor: Colors.white,
                  min: 0,
                  max: songDuration!,
                ),
              ),
              Text(
                formatDuration(songDuration!),
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.shuffle, color: inShuffle, size: 30),
              ),
              IconButton(
                icon: const Icon(
                  Icons.skip_previous,
                  color: Colors.white,
                  size: 35,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(widget.icon, color: Colors.white, size: 35),
                onPressed: widget.onPlayPause,
              ),
              IconButton(
                icon: const Icon(
                  Icons.skip_next,
                  color: Colors.white,
                  size: 35,
                ),
                onPressed: () {},
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.loop, color: inLoop, size: 30),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
