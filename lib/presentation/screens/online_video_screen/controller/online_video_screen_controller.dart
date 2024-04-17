import 'dart:io';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:my_app/core/constants/color.dart';
import 'package:my_app/core/constants/textstyle.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class OnlineVideoScreenController extends GetxController {
  var videoUrl = ''.obs;
    late VideoPlayerController controller;
  var isMusicOn = true.obs;
  FToast? fToast;
  var downloadingProgress = 0.0.obs;
   void stopVideo() {
    if (controller.value.isPlaying) {
      controller.pause();
    }
  }
  
    showCustomToast({required String msg,Color? color}) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: color?? ColorConst.green3D,
      ),
      child: Text(
        msg,
        style:
            TextStyleClass.poppinsRegular(size: 13.00, color: ColorConst.white),
      ),
    );

    fToast?.showToast(
      child: toast,
      toastDuration: const Duration(seconds: 3),
    );
  }


  Future<void> downloadVideo() async {
    showCustomToast(msg: "Downloading...");
    final appDocDirectory = await getAppDocDirectory();

    final finalVideoPath = join(
      appDocDirectory.path,
      'Video-${DateTime
          .now()
          .millisecondsSinceEpoch}.mp4',
    );

    final dio = Dio();

    await dio.download(
      videoUrl.value,
      finalVideoPath,
      onReceiveProgress: (actualBytes, totalBytes) {
        
                   downloadingProgress.value = actualBytes / totalBytes * 100;

      },
    );

    await saveDownloadedVideo(videoPath: finalVideoPath);
    // await removeDownloadedVideo(videoPath: finalVideoPath);
  }

  Future<Directory> getAppDocDirectory() async {
    if (Platform.isIOS) {
      return getApplicationDocumentsDirectory();
    }

    return (await getExternalStorageDirectory())!;
  }

  Future<void> saveDownloadedVideo({required String videoPath}) async {
    // await ImageGallerySaver.saveFile(videoPath);
    await saveFileToFolder(videoPath);
  }

  Future<void> removeDownloadedVideo({required String videoPath}) async {
    try {
      Directory(videoPath).deleteSync(recursive: true);
    } catch (error) {
      debugPrint('$error');
    }
  }

Future<void> saveFileToFolder(String videoPath) async {
  Directory? storageDirectory = await getExternalStorageDirectory();
  if (storageDirectory != null) {
    String folderName = "MyVideoPlayer";

    String folderPath = '${storageDirectory.path}/$folderName';
    await Directory(folderPath).create(recursive: true);

    File originalFile = File(videoPath);
    String fileName = videoPath.split('/').last;
    String newPath = '$folderPath/$fileName';
    await originalFile.copy(newPath);
    showCustomToast(msg: "Download complete");

    print('File saved to folder: $newPath');
  } else {
        showCustomToast(msg: "Download Failed");

    print('External storage directory not found.');
  }
}
}