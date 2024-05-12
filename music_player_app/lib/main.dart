import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math';

void main() {
  runApp(MusicPlayerApp());
}

class MusicPlayerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Player',
      home: MusicPlayerScreen(),
    );
  }
}

class MusicPlayerScreen extends StatefulWidget {
  @override
  _MusicPlayerScreenState createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  late AudioPlayer _audioPlayer;
  List<String> playlist = ['Track 1', 'Track 2', 'Track 3'];
  int currentIndex = 0;
  bool isPlaying = false;
  bool isShuffle = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.onPlayerStateChanged.listen((event) {
      if (event == PlayerState.PLAYING) {
        setState(() {
          isPlaying = true;
        });
      } else if (event == PlayerState.PAUSED) {
        setState(() {
          isPlaying = false;
        });
      }
    });
    playTrack(playlist[currentIndex]);
  }

  void playTrack(String track) async {
    await _audioPlayer.stop();
    await _audioPlayer.play(track, isLocal: true);
  }

  void playNextTrack() {
    if (isShuffle) {
      setState(() {
        currentIndex = Random().nextInt(playlist.length);
      });
    } else {
      setState(() {
        currentIndex = (currentIndex + 1) % playlist.length;
      });
    }
    playTrack(playlist[currentIndex]);
  }

  void playPreviousTrack() {
    if (isShuffle) {
      setState(() {
        currentIndex = Random().nextInt(playlist.length);
      });
    } else {
      setState(() {
        currentIndex = (currentIndex - 1 + playlist.length) % playlist.length;
      });
    }
    playTrack(playlist[currentIndex]);
  }

  void toggleShuffle() {
    setState(() {
      isShuffle = !isShuffle;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Music Player'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Now Playing:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              playlist[currentIndex],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.skip_previous),
                  iconSize: 40,
                  onPressed: playPreviousTrack,
                ),
                IconButton(
                  icon: isPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow),
                  iconSize: 60,
                  onPressed: () {
                    if (isPlaying) {
                      _audioPlayer.pause();
                    } else {
                      _audioPlayer.resume();
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.skip_next),
                  iconSize: 40,
                  onPressed: playNextTrack,
                ),
                IconButton(
                  icon: Icon(Icons.shuffle),
                  onPressed: toggleShuffle,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
