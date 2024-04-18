// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:my_app/core/constants/color.dart';
import 'package:my_app/core/constants/textstyle.dart';
import 'package:my_app/presentation/screens/home_screen/view/tabs/offline_videos/controller/offline_video_controller.dart';
import 'package:my_app/presentation/screens/home_screen/view/tabs/video_list_screen/controller/video_list_screen_controller.dart';
import 'package:my_app/presentation/widgets/common/default_app_bar.dart';
import 'package:my_app/routes/index.dart';
import 'package:video_player/video_player.dart';

class VideoListScreen extends StatefulWidget {
  const VideoListScreen({super.key});

  @override
  State<VideoListScreen> createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  final OfflineVideosController offlineVideoCtrl =
      Get.put(OfflineVideosController());
  final videoListScreenCtrl = Get.put(VideoListScreenController());

  bool isFullScreen = false;

  @override
  void initState() {
    // secureScreen();
    loadVideoPlayer();
    videoListScreenCtrl.fToast = FToast();
    super.initState();
  }

//   Future<void> secureScreen() async {
//     // await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
//   }

  loadVideoPlayer() {
    videoListScreenCtrl.controller = VideoPlayerController.network(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4');
    videoListScreenCtrl.controller.addListener(() {
      setState(() {});
    });
    videoListScreenCtrl.controller.initialize().then((value) {
      setState(() {});
    });
  }

  void toggleFullScreen() {
    setState(() {
      isFullScreen = !isFullScreen;
    });
    if (isFullScreen) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
    } else {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
  }

  @override
  Widget build(BuildContext context) {
    videoListScreenCtrl.fToast?.init(context);
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        videoListScreenCtrl.stopVideo();
        return true;
      },
      child: SafeArea(
          child: Scaffold(
        backgroundColor: ColorConst.white,
        appBar:
            defaultAppBar(context, () => Get.toNamed(routeName.profileScreen)),
        body: Obx(
          () => Column(children: [
            Stack(
              alignment: Alignment.bottomLeft,
              children: <Widget>[
                AspectRatio(
                  aspectRatio: videoListScreenCtrl.controller.value.aspectRatio,
                  child: VideoPlayer(videoListScreenCtrl.controller),
                ),
                const ClosedCaption(text: ''),
                if (videoListScreenCtrl.downloadingProgress > 0 &&
                    videoListScreenCtrl.downloadingProgress < 100)
                  LinearProgressIndicator(
                    value: videoListScreenCtrl.downloadingProgress / 100,
                    backgroundColor: Colors.grey,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(8, 5, 11, 37),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: VideoProgressIndicator(
                              videoListScreenCtrl.controller,
                              allowScrubbing: true,
                              padding:
                                  const EdgeInsets.only(right: 8, left: 40),
                              colors: VideoProgressColors(
                                backgroundColor: ColorConst.black,
                                playedColor: ColorConst.green3D,
                                bufferedColor: ColorConst.black,
                              )),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              videoListScreenCtrl.controller.value.position
                                  .toString()
                                  .split('.')[0],
                              style: TextStyleClass.poppinsMedium(
                                  size: 13.00, color: ColorConst.white),
                            ),
                            Text(
                              '/',
                              style: TextStyleClass.poppinsMedium(
                                  size: 13.00, color: ColorConst.black),
                            ),
                            Text(
                              videoListScreenCtrl.controller.value.duration
                                  .toString()
                                  .split('.')[0],
                              style: TextStyleClass.poppinsMedium(
                                  size: 13.00, color: ColorConst.white),
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
                              videoListScreenCtrl.controller.value.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: ColorConst.white,
                              size: 46,
                            ),
                            onTap: () {
                              if (videoListScreenCtrl
                                  .controller.value.isPlaying) {
                                videoListScreenCtrl.controller.pause();
                              } else {
                                videoListScreenCtrl.controller.play();
                              }

                              setState(() {});
                            },
                          ),
                        ),
                        GestureDetector(
                          child: Icon(
                            Icons.fast_rewind,
                            size: 18,
                            color: ColorConst.white,
                          ),
                          onTap: () async {
                            await videoListScreenCtrl.controller.seekTo(
                                Duration(
                                    seconds: videoListScreenCtrl.controller
                                            .value.position.inSeconds -
                                        5));
                          },
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          child: Icon(
                            Icons.fast_forward,
                            size: 18,
                            color: ColorConst.white,
                          ),
                          onTap: () async {
                            await videoListScreenCtrl.controller.seekTo(
                                Duration(
                                    seconds: videoListScreenCtrl.controller
                                            .value.position.inSeconds +
                                        5));
                          },
                        ),
                        const SizedBox(width: 14),
                        GestureDetector(
                          child: Icon(
                            videoListScreenCtrl.isMusicOn.value == true
                                ? Icons.volume_up
                                : Icons.volume_off,
                            size: 18,
                            color: ColorConst.white,
                          ),
                          onTap: () async {
                            setState(() {
                              videoListScreenCtrl.isMusicOn.value == false
                                  ? videoListScreenCtrl.controller
                                      .setVolume(1.0)
                                  : videoListScreenCtrl.controller
                                      .setVolume(0.0);
                              videoListScreenCtrl.isMusicOn.value =
                                  !videoListScreenCtrl.isMusicOn.value;
                            });
                          },
                        ),
                      ],
                    ),
                    Transform.translate(
                      offset: Offset(-9, 0),
                      child: GestureDetector(
                        onTap: () {
                          videoListScreenCtrl.showCustomToast(
                              msg: "Full Screen disabled at this time",
                              color: ColorConst.red);
                        },
                        child: Icon(
                          Icons.fullscreen,
                          size: 21,
                          color: ColorConst.white,
                        ),
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
                        videoListScreenCtrl.downloadVideo();
                      },
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: ColorConst.green3D,
                        size: 28,
                      ),
                      label: Text('Download ',
                          style: TextStyleClass.poppinsRegular(
                              size: 13.00, color: ColorConst.black)),
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
        ),
      )),
    );
  }
}
