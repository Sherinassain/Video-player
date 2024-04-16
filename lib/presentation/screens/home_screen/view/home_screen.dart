// ignore_for_file: prefer_const_constructors


import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:my_app/core/constants/color.dart';
import 'package:my_app/core/constants/textstyle.dart';
import 'package:my_app/routes/index.dart';
import 'package:path/path.dart';
import 'package:video_player/video_player.dart';

import 'package:dio/dio.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../widgets/common/default_app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late VideoPlayerController controller;
  bool isMusicOn = true;
  FToast? fToast;

  showCustomToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: ColorConst.green3D,
      ),
      child:  Text(
        "Video Downloaded Successfully",
        style: TextStyleClass.poppinsRegular(size: 13.00,color: ColorConst.white),
      ),
    );

    fToast?.showToast(
      child: toast,
      toastDuration: const Duration(seconds: 3),
    );
  }

  Future<void> downloadVideo() async {
    final appDocDirectory = await getAppDocDirectory();

    final finalVideoPath = join(
      appDocDirectory.path,
      'Video-${DateTime
          .now()
          .millisecondsSinceEpoch}.mp4',
    );

    final dio = Dio();

    await dio.download(
      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      finalVideoPath,
      onReceiveProgress: (actualBytes, totalBytes) {
        final percentage = actualBytes / totalBytes * 100;
      },
    );

    await saveDownloadedVideoToGallery(videoPath: finalVideoPath);
    await removeDownloadedVideo(videoPath: finalVideoPath);
  }

  Future<Directory> getAppDocDirectory() async {
    if (Platform.isIOS) {
      return getApplicationDocumentsDirectory();
    }

    return (await getExternalStorageDirectory())!;
  }

  Future<void> saveDownloadedVideoToGallery({required String videoPath}) async {
    await ImageGallerySaver.saveFile(videoPath);
    showCustomToast();
  }

  Future<void> removeDownloadedVideo({required String videoPath}) async {
    try {
      Directory(videoPath).deleteSync(recursive: true);
    } catch (error) {
      debugPrint('$error');
    }
  }


  @override
  void initState() {
    secureScreen();
    loadVideoPlayer();
    fToast = FToast();
    super.initState();
  }

  Future<void> secureScreen() async {
    // await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  loadVideoPlayer() {
    controller = VideoPlayerController.network(
        'https://youtu.be/1-o32PS9bbg?si=U6c4oVGwS_hLfcX4');
    controller.addListener(() {
      setState(() {});
    });
    controller.initialize().then((value) {
      setState(() {});
    });
  }

  

  @override
  Widget build(BuildContext context) {
    fToast?.init(context);
    return SafeArea(child: Scaffold(
      backgroundColor: ColorConst.white,
      appBar: defaultAppBar(context, ()=> Get.toNamed(routeName.profileScreen)
      ),
      body: Column(children: [
        Stack(
          alignment: Alignment.bottomLeft,
          children: <Widget>[
            AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: VideoPlayer(controller),
            ),
            const ClosedCaption(text: ''),
            Padding(
                padding: const EdgeInsets.fromLTRB(8, 5, 11, 37),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: VideoProgressIndicator(controller,
                          allowScrubbing: true,
                          padding: const EdgeInsets.only(right: 8, left: 40),
                          colors:  VideoProgressColors(
                            backgroundColor:ColorConst.black,
                            playedColor: ColorConst.green3D,
                            bufferedColor: ColorConst.black,
                          )),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          controller.value.position.toString().substring(5, 10),
                          style: TextStyleClass.poppinsMedium(size: 13.00,color: ColorConst.black),
                        ),
                        Text(
                          '/',
                          style: TextStyleClass.poppinsMedium(size: 13.00,color: ColorConst.black),
                        ),
                        Text(
                          controller.value.duration.toString().substring(5, 10),
                          style: TextStyleClass.poppinsMedium(size: 13.00,color: ColorConst.black),
                        ),
                      ],
                    ),
                  ],
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Transform.translate(
                      offset: const Offset(0, -5),
                      child: InkWell(
                        child: Icon(
                          controller.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: ColorConst.white,
                          size: 46,
                        ),
                        onTap: () {
                          if (controller.value.isPlaying) {
                            controller.pause();
                          } else {
                            controller.play();
                          }

                          setState(() {});
                        },
                      ),
                    ),
                    GestureDetector(
                      child:  Icon(
                        Icons.fast_rewind,
                        size: 18,
                        color: ColorConst.white,
                      ),
                      onTap: () async {
                        await controller.seekTo(Duration(
                            seconds: controller.value.position.inSeconds - 5));
                      },
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      child:  Icon(
                        Icons.fast_forward,
                        size: 18,
                        color: ColorConst.white,
                      ),
                      onTap: () async {
                        await controller.seekTo(Duration(
                            seconds: controller.value.position.inSeconds + 5));
                      },
                    ),
                    const SizedBox(width: 14),
                    GestureDetector(
                      child: Icon(
                        isMusicOn == true ? Icons.volume_up : Icons.volume_off,
                        size: 18,
                        color: ColorConst.white,
                      ),
                      onTap: () async {
                        setState(() {
                          isMusicOn == false
                              ? controller.setVolume(1.0)
                              : controller.setVolume(0.0);
                          isMusicOn = !isMusicOn;
                        });
                      },
                    ),
                  ],
                ),
                Transform.translate(
                  offset: Offset(-9, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:  [
                      Icon(
                        Icons.settings,
                        size: 18,
                        color: ColorConst.white,
                      ),
                      SizedBox(width: 15),
                      Icon(
                        Icons.fullscreen,
                        size: 21,
                        color: ColorConst.white,
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
        Padding(
            padding: EdgeInsets.only(left: 10, right: 10, top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: ColorConst.white,
                        borderRadius: BorderRadius.circular(12)),
                    child: InkWell(
                      child: Icon(
                        Icons.keyboard_arrow_left_outlined,
                        size: 28,
                        color: ColorConst.black,
                      ),
                      onTap: () {
                        // controller.previousPage();
                      },
                    )),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    backgroundColor: ColorConst.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    downloadVideo();
                  },
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: ColorConst.green3D,
                    size: 28,
                  ),
                  label: Text('Download ', style: TextStyleClass.poppinsRegular(size: 13.00,color: ColorConst.black)),
                ),
                Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: ColorConst.white,
                        borderRadius: BorderRadius.circular(12)),
                    child: InkWell(
                      child: Icon(
                        Icons.keyboard_arrow_right,
                        size: 28,
                        color: ColorConst.black,
                      ),
                      onTap: () {
                        // controller.nextPage();
                      },
                    )),
              ],
            )),
      ]),
    ));
  }
}
