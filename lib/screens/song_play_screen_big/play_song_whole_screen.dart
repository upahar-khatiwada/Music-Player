import 'package:auto_scroll_text/auto_scroll_text.dart';
import 'package:flutter/material.dart';
import 'package:music_player/services/constants/constant_vars.dart';

class BigPlayScreen extends StatefulWidget {
  const BigPlayScreen({super.key});

  @override
  State<BigPlayScreen> createState() => _BigPlayScreenState();
}

class _BigPlayScreenState extends State<BigPlayScreen> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appbarColor,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'PLAYING FROM YOUR LIBRARY',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            Text(
              'Now Playing',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                letterSpacing: 2.0,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            Container(
              decoration: BoxDecoration(color: Colors.grey),
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width * 0.9,
              margin: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.09,
                right: MediaQuery.of(context).size.width * 0.09,
              ),
              child: Center(
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
                args['songTitle'],
                style: TextStyle(color: Colors.white, fontSize: 25),
                mode: AutoScrollTextMode.endless,
              ),
            ),
            Slider(
              value: args['songDuration_double'],
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
                  icon: Icon(Icons.shuffle, color: Colors.white, size: 35),
                ),
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Colors.white,
                    size: 35,
                  ),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.play_circle, color: Colors.white, size: 52),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                    size: 35,
                  ),
                  onPressed: () {},
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.loop, color: Colors.white, size: 35),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
