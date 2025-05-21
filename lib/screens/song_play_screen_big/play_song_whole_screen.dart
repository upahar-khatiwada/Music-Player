// This file handles the big music playing screen
// TODO: REDUNDANT FILE

import 'package:auto_scroll_text/auto_scroll_text.dart';
import 'package:flutter/material.dart';
import 'package:music_player/services/constants/constant_vars.dart';

class BigPlayScreen extends StatefulWidget {
  const BigPlayScreen({super.key});

  @override
  State<BigPlayScreen> createState() => _BigPlayScreenState();
}

class _BigPlayScreenState extends State<BigPlayScreen> {
  late IconData icon;
  late VoidCallback onPlayPause;
  late final Map<String, dynamic> args;

  // @override
  // void didChangeDependencies() {
  //   // TODO: implement didChangeDependencies
  //   super.didChangeDependencies();
  //   args =
  //   ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
  //
  //   icon = args['icon'];
  //   onPlayPause = () {
  //     args['onPlayPause']();
  //
  //     setState(() {
  //       final bool isPlayPressed = args['isPlayPressed'];
  //       icon = isPlayPressed ? Icons.pause_circle : Icons.play_circle;
  //     });
  //   };
  // }

  @override
  Widget build(BuildContext context) {
    // getting the arguments from mini music player from home screen
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    onPlayPause =
        args['onPlayPause']; // calls the parent widget for updating the parameters globally

    final ValueNotifier<IconData> iconNotifier =
        args['iconNotifier'] as ValueNotifier<IconData>;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appbarColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'PLAYING FROM YOUR LIBRARY',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            const Text(
              'Now Playing',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                letterSpacing: 2.0,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(12),
              ),
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width * 0.9,
              margin: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.09,
                right: MediaQuery.of(context).size.width * 0.09,
              ),
              child: const Center(
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Icon(Icons.music_note, color: Colors.white, size: 300),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.08),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: AutoScrollText(
                args['songModel'].displayNameWOExt,
                style: const TextStyle(color: Colors.white, fontSize: 25),
                mode: AutoScrollTextMode.endless,
              ),
            ),
            Slider(
              value: 0,
              activeColor: Colors.white,
              inactiveColor: Colors.grey,
              min: 0.0,
              max: 100.0,
              onChanged: (double? value) {},
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.shuffle, color: inShuffle, size: 35),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.skip_previous,
                    color: Colors.white,
                    size: 35,
                  ),
                  onPressed: () {},
                ),
                ValueListenableBuilder<IconData>(
                  valueListenable: iconNotifier,
                  builder: (BuildContext context, IconData icon, _) {
                    return IconButton(
                      onPressed: onPlayPause,
                      icon: Icon(icon, color: Colors.white, size: 52),
                    );
                  },
                ),
                // IconButton(
                //   icon: Icon(
                //     args['isPlayPressed']
                //         ? Icons.pause_circle
                //         : Icons.play_circle,
                //     color: Colors.white,
                //     size: 52,
                //   ),
                //   onPressed: () {
                //     onPlayPause();
                //     setState(() {});
                //   },
                // ),
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
                  icon: Icon(Icons.loop, color: inLoop, size: 35),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
