// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:my_app/core/constants/color.dart';
import 'package:my_app/core/constants/textstyle.dart';
import 'package:my_app/presentation/screens/home_screen/controller/home_controller.dart';
import 'package:my_app/presentation/screens/home_screen/view/tabs/offline_videos/controller/offline_video_controller.dart';
import 'package:my_app/presentation/screens/online_video_screen/controller/online_video_screen_controller.dart';
import 'package:my_app/presentation/widgets/common/default_app_bar.dart';
import 'package:my_app/routes/index.dart';
import 'package:path/path.dart';
import 'package:video_player/video_player.dart';

import 'package:fluttertoast/fluttertoast.dart';

class OnlineVideoScreen extends StatefulWidget {
  final String videoUrl;
  const OnlineVideoScreen({Key? key,required this.videoUrl}) : super(key: key);

  @override
  State<OnlineVideoScreen> createState() => _OnlineVideoScreenState();
}

class _OnlineVideoScreenState extends State<OnlineVideoScreen> {
  final OfflineVideosController offlineVideoCtrl =
      Get.put(OfflineVideosController());
  final onlineVideoScreenCtrl = Get.put(OnlineVideoScreenController());
    final homeCtrl = Get.put(HomeController());

  bool isFullScreen = false;

  @override
  void initState() {
    // secureScreen();
    loadVideoPlayer();
    onlineVideoScreenCtrl.fToast = FToast();
    super.initState();
  }

//   Future<void> secureScreen() async {
//     // await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
//   }

  loadVideoPlayer() {
    onlineVideoScreenCtrl.controller = VideoPlayerController.network(
        widget.videoUrl);
    onlineVideoScreenCtrl.controller.addListener(() {
      setState(() {});
    });
    onlineVideoScreenCtrl.controller.initialize().then((value) {
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
    onlineVideoScreenCtrl.fToast?.init(context);
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        onlineVideoScreenCtrl.stopVideo();
        return true;
      },
      child: SafeArea(
          child: Obx(()=>
             Scaffold(
                    backgroundColor: (homeCtrl.isDarkTheme.value == false)?ColorConst.white:ColorConst.black,
                    appBar:
              defaultAppBar( ),
                    body: Obx(
            () => Column(children: [
              Stack(
                alignment: Alignment.bottomLeft,
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: onlineVideoScreenCtrl.controller.value.aspectRatio,
                    child: VideoPlayer(onlineVideoScreenCtrl.controller),
                  ),
                  const ClosedCaption(text: ''),
                  if (onlineVideoScreenCtrl.downloadingProgress > 0 &&
                      onlineVideoScreenCtrl.downloadingProgress < 100)
                    LinearProgressIndicator(
                      value: onlineVideoScreenCtrl.downloadingProgress / 100,
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
                                onlineVideoScreenCtrl.controller,
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
                                        onlineVideoScreenCtrl.controller.value.position
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
                              onlineVideoScreenCtrl.controller.value.duration
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
                                onlineVideoScreenCtrl.controller.value.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                color: ColorConst.white,
                                size: 46,
                              ),
                              onTap: () {
                                if (onlineVideoScreenCtrl
                                    .controller.value.isPlaying) {
                                  onlineVideoScreenCtrl.controller.pause();
                                } else {
                                  onlineVideoScreenCtrl.controller.play();
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
                              await onlineVideoScreenCtrl.controller.seekTo(
                                  Duration(
                                      seconds: onlineVideoScreenCtrl.controller
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
                              await onlineVideoScreenCtrl.controller.seekTo(
                                  Duration(
                                      seconds: onlineVideoScreenCtrl.controller
                                              .value.position.inSeconds +
                                          5));
                            },
                          ),
                          const SizedBox(width: 14),
                          GestureDetector(
                            child: Icon(
                              onlineVideoScreenCtrl.isMusicOn.value == true
                                  ? Icons.volume_up
                                  : Icons.volume_off,
                              size: 18,
                              color: ColorConst.white,
                            ),
                            onTap: () async {
                              setState(() {
                                onlineVideoScreenCtrl.isMusicOn.value == false
                                    ? onlineVideoScreenCtrl.controller
                                        .setVolume(1.0)
                                    : onlineVideoScreenCtrl.controller
                                        .setVolume(0.0);
                                onlineVideoScreenCtrl.isMusicOn.value =
                                    !onlineVideoScreenCtrl.isMusicOn.value;
                              });
                            },
                          ),
                        ],
                      ),
                      Transform.translate(
                        offset: Offset(-9, 0),
                        child: GestureDetector(
                          onTap: () {
                            onlineVideoScreenCtrl.showCustomToast(
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
                          onlineVideoScreenCtrl.downloadVideo();
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
                  ),
          )),
    );
  }
}
