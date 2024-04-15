import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pod_player/pod_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final Dio dio;
  double _progress = 0.0;
  String? _videoFilePath;

  @override
  void initState() {
    super.initState();
    
    dio = Dio();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _downloadAndSaveVideo() async {
    String url =
        'https://drive.google.com/file/d/1GeEokbNrs4Nafb8WNtGmkOZ16z3bu5y4/view?usp=drivesdk';

    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String savePath = appDocDir.path + '/video.mp4';

      await dio.download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            double progress = (received / total * 100);
            // Update UI with download progress
            setState(() {
              _progress = progress;
            });
          }
        },
      );
      print('File downloaded to: $savePath');

      setState(() {
        _videoFilePath = savePath;
      });


      // Save the file path to Hive
      final box = await Hive.openBox<String>('videos');
      box.put('video_path', savePath);



      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Video downloaded and saved successfully'),
        ),
      );
    } catch (e) {
      print('Error downloading file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error downloading and saving video'),
        ),
      );
    }
  }


  Future<void> _playVideoFromHive() async {
    // Retrieve the file path from Hive
    final box = await Hive.openBox<String>('videos');
    String? videoPath = box.get('video_path');

    if (videoPath != null) {
      setState(() {
        _videoFilePath = videoPath;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoPlayerScreen(
            videoFilePath: _videoFilePath!,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Video not found in Hive database'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Download and Play Video'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_progress > 0 && _progress < 100)
              LinearProgressIndicator(
                value: _progress / 100,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _downloadAndSaveVideo,
              child: Text("Download and Save Video"),
            ),
            ElevatedButton(
              onPressed: _playVideoFromHive,
              child: Text("Play Video from Hive"),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String videoFilePath;

  const VideoPlayerScreen({Key? key, required this.videoFilePath})
      : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late final PodPlayerController _controller;

  @override
  void initState()  {

    super.initState();
    _controller = PodPlayerController(
      playVideoFrom: PlayVideoFrom.file(File(widget.videoFilePath)),
    )..initialise();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
      ),
      body: PodVideoPlayer(controller: _controller),
    );
  }
}
