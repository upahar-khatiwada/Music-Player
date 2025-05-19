import 'package:flutter/material.dart';
import 'package:music_player/services/home_page_tab_services/music_list.dart';

class Songs extends StatefulWidget {
  const Songs({super.key});

  @override
  State<Songs> createState() => _SongsState();
}

class _SongsState extends State<Songs> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Scrollbar(
        child: ListView.builder(
          primary: true,
          itemCount: Music_from_local_storage.length,
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
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Music_from_local_storage[index],
                          style: TextStyle(color: Colors.white),
                        ),
                        Text('4:30', style: TextStyle(color: Colors.white)),
                      ],
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
            );
          },
        ),
      ),
    );
  }
}
