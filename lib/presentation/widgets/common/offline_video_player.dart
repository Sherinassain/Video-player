// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:my_app/core/constants/color.dart';
import 'package:my_app/core/constants/textstyle.dart';
import 'package:my_app/presentation/screens/home_screen/view/tabs/offline_videos/controller/offline_video_controller.dart';
import 'package:my_app/presentation/widgets/common/default_app_bar.dart';
import 'package:my_app/routes/index.dart';
import 'package:video_player/video_player.dart';


import 'package:fluttertoast/fluttertoast.dart';

class OfflineVideoPlayer extends StatefulWidget {
  final File videoFile;
  const OfflineVideoPlayer({Key? key,required this.videoFile}) : super(key: key);

  @override
  State<OfflineVideoPlayer> createState() => _OfflineVideoPlayerState();
}

class _OfflineVideoPlayerState extends State<OfflineVideoPlayer> {
    final OfflineVideosController offlineVideoCtrl = Get.put(OfflineVideosController());

  bool isMusicOn = true;
  FToast? fToast;
  double downloadingProgress = 0.0;
  showCustomToast({required String msg,Color? color}) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color:color?? ColorConst.green3D,
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



  @override
  void initState() {
    // secureScreen();
    loadVideoPlayer();
    fToast = FToast();
    super.initState();
  }

//   Future<void> secureScreen() async {
//     // await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
//   }
loadVideoPlayer() {
offlineVideoCtrl.controller = VideoPlayerController.file(widget.videoFile); // Assuming the video file is located in the assets/videos folder
  offlineVideoCtrl.controller.addListener(() {
    setState(() {});
  });
  offlineVideoCtrl.controller.initialize().then((_) {
    setState(() {});
  });
}


  @override
  Widget build(BuildContext context) {
    fToast?.init(context);
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: ()async{

    if (offlineVideoCtrl.controller.value.isPlaying) {
      offlineVideoCtrl.controller.pause();
    
  }
  return true;
      },
      child: SafeArea(
          child: Scaffold(
        backgroundColor: ColorConst.white,
        appBar:
            defaultAppBar(context, () => Get.toNamed(routeName.profileScreen)),
        body: Column(children: [
          Stack(
            alignment: Alignment.bottomLeft,
            children: <Widget>[
              AspectRatio(
                aspectRatio: offlineVideoCtrl.controller.value.aspectRatio,
                child: VideoPlayer(offlineVideoCtrl.controller),
              ),
              const ClosedCaption(text: ''),
              if (downloadingProgress > 0 && downloadingProgress < 100)
                LinearProgressIndicator(
                  value: downloadingProgress / 100,
                  backgroundColor: Colors.grey,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(8, 5, 11, 37),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: VideoProgressIndicator(offlineVideoCtrl.controller,
                            allowScrubbing: true,
                            padding: const EdgeInsets.only(right: 8, left: 40),
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
                          offlineVideoCtrl.controller.value.position
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
                          offlineVideoCtrl.controller.value.duration
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
                            offlineVideoCtrl.controller.value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: ColorConst.white,
                            size: 46,
                          ),
                          onTap: () {
                            if (offlineVideoCtrl.controller.value.isPlaying) {
                              offlineVideoCtrl.controller.pause();
                            } else {
                              offlineVideoCtrl.controller.play();
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
                          await offlineVideoCtrl.controller.seekTo(Duration(
                              seconds: offlineVideoCtrl.controller.value.position.inSeconds - 5));
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
                          await offlineVideoCtrl.controller.seekTo(Duration(
                              seconds: offlineVideoCtrl.controller.value.position.inSeconds + 5));
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
                                ? offlineVideoCtrl.controller.setVolume(1.0)
                                : offlineVideoCtrl.controller.setVolume(0.0);
                            isMusicOn = !isMusicOn;
                          });
                        },
                      ),
                    ],
                  ),
                  Transform.translate(
                    offset: Offset(-9, 0),
                    child: GestureDetector(
                      onTap: (){
                        showCustomToast(msg: "Full Screen disabled at this time",color: ColorConst.red)    ;   
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
      
        ]),
      )),
    );
  }
}
