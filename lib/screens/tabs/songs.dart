import 'package:flutter/material.dart';
import '../../services/music_list.dart';

class Songs extends StatelessWidget {
  const Songs({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Scrollbar(
        child: ListView.builder(
          primary: true,
          itemCount: Music.length,
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
                          Music[index],
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
