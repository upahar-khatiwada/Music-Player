import 'package:flutter/material.dart';
import 'package:music_player/services/home_page_tab_services/music_list.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:auto_scroll_text/auto_scroll_text.dart';

final OnAudioQuery _audioQuery = OnAudioQuery();

// Contains the path of the directory
// String? result;
//
// void chooseDirectory() async {
//   // getting the path of the music folder
//   result = await FilePicker.platform.getDirectoryPath();
//   File file = File(result!);
//   try {
//     final dir = Directory(result!);
//     List<FileSystemEntity> files = dir.listSync();
//     print(files);
//
//     await _audioQuery.scanMedia(result!);
//   } catch (e) {
//     Flushbar(
//       message: "Error occured while scanning: $e",
//       margin: EdgeInsets.all(8),
//       borderRadius: BorderRadius.circular(8),
//       backgroundColor: Colors.red,
//       duration: Duration(seconds: 3),
//       flushbarPosition: FlushbarPosition.BOTTOM,
//       flushbarStyle: FlushbarStyle.FLOATING,
//       forwardAnimationCurve: Curves.easeOut,
//       reverseAnimationCurve: Curves.easeInOut,
//       icon: Icon(Icons.error, color: Colors.white),
//     );
//   }
//
//   if (result == null) {
//     Flushbar(
//       message: "Please select a directory!",
//       margin: EdgeInsets.all(8),
//       borderRadius: BorderRadius.circular(8),
//       backgroundColor: Colors.red,
//       duration: Duration(seconds: 3),
//       flushbarPosition: FlushbarPosition.BOTTOM,
//       flushbarStyle: FlushbarStyle.FLOATING,
//       forwardAnimationCurve: Curves.easeOut,
//       reverseAnimationCurve: Curves.easeInOut,
//       icon: Icon(Icons.error, color: Colors.white),
//     );
//   }
// }

class Songs extends StatefulWidget {
  const Songs({super.key});

  @override
  State<Songs> createState() => _SongsState();
}

class _SongsState extends State<Songs> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SongModel>>(
      future: _audioQuery.querySongs(
        sortType: null,
        ignoreCase: true,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
      ),
      builder: (context, item) {
        if (item.data == null) {
          return Center(child: CircularProgressIndicator(color: Colors.white));
        }
        if (item.data!.isEmpty) {
          return Center(
            child: Text(
              'No songs found!',
              style: TextStyle(color: Colors.white),
            ),
          );
        }
        if (!item.hasData) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        Music_from_local_storage = item.data!;
        // print(Music_from_local_storage);
        for (var song in Music_from_local_storage!) {
          print("title: ${song.displayName}");
        }
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Scrollbar(
            child: ListView.builder(
              primary: true,
              itemCount: item.data!.length,
              itemBuilder: (context, index) {
                return Card(
                  clipBehavior: Clip.hardEdge,
                  color: Color(0xFF464343),
                  child: ListTile(
                    onTap: () {},
                    focusColor: Colors.grey,
                    splashColor: Colors.white10,
                    leading: GestureDetector(
                      onTap: () {},
                      child: Icon(Icons.favorite, color: Colors.white),
                    ),
                    title: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Tooltip(
                              message: item.data![index].displayName,
                              child: Text(
                                item.data![index].displayNameWOExt,
                                style: TextStyle(color: Colors.white),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          GestureDetector(
                            child: Icon(
                              Icons.play_circle,
                              color: Colors.white,
                              size: 27,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
