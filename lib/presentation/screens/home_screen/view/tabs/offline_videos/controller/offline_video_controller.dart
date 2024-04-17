import 'dart:io';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class OfflineVideosController extends GetxController {
  RxList<File> downloadedVideos = <File>[].obs;
  RxBool isLoading = true.obs;
var videoPath=''.obs;
  late VideoPlayerController controller;

Future<void> getDownloadedVideos() async {
  isLoading.value= true;
  try {
    final directory = Directory('/storage/emulated/0/Android/data/com.example.my_app/files/MyVideoPlayer');

    if (directory.existsSync()) {
      // List files in the directory
      final List<File> videos = directory.listSync().map((entity) => File(entity.path)).toList();
      
      // Update the downloadedVideos list
      downloadedVideos.value = videos;
      
      print('Downloaded videos: $downloadedVideos');
    } else {
      print('Directory not found');
    }
  } catch (e) {
    print('Error fetching videos: $e');
  } finally {
    isLoading.value = false;
  }
}
}
