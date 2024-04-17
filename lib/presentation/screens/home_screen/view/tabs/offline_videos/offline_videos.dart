import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/presentation/widgets/common/offline_video_player.dart';
import 'package:my_app/routes/index.dart';
import 'package:video_player/video_player.dart';
import 'package:my_app/presentation/screens/home_screen/view/tabs/offline_videos/controller/offline_video_controller.dart';

class OfflineVideos extends StatefulWidget {
  @override
  State<OfflineVideos> createState() => _OfflineVideosState();
}

class _OfflineVideosState extends State<OfflineVideos> {
  final OfflineVideosController _controller =
      Get.put(OfflineVideosController());

  @override
  void initState() {
    _controller.getDownloadedVideos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Offline Videos'),
      ),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (_controller.downloadedVideos.isEmpty) {
          return Center(child: Text('No downloaded videos'));
        } else {
          return ListView.builder(
            itemCount: _controller.downloadedVideos.length,
            itemBuilder: (context, index) {
              return _buildVideoItem(_controller.downloadedVideos[index]);
            },
          );
        }
      }),
    );
  }

  Widget _buildVideoItem(File file) {
    return ListTile(
      leading: _getFileTypeIcon(),
      title: Text(_getFileName(file)),
      onTap: () {
Navigator.of(context).push(MaterialPageRoute(builder: (context)=>OfflineVideoPlayer(videoFile: file)));      },
    );
  }

  String _getFileName(File file) {
    return file.path.split('/').last;
  }

  Icon _getFileTypeIcon() {
    return Icon(Icons.insert_drive_file); // Default icon for now
  }
}
