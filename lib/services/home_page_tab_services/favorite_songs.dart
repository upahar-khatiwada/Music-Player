// file to store the list and set of the home page's songs

import 'package:flutter/material.dart';

// set to store the liked songs
// didn't use list as same song could be added multiple times to a list
Set<String> favoriteSongs = {};

// list to store the colors of the favorite icons
List<Color> favoriteSongsLiked = [];

// list to store the icons for the song's play button depending on whether the song is being played or not
List<IconData> playButton = [];

// list to store the boolean for whether the song is being played or not
List<bool> isPlaying = [];

// colors to be put in the list for favorite songs whether its liked or not
Color unLiked = Colors.white;
Color liked = Colors.red;
