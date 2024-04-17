import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:my_app/core/constants/textstyle.dart';
import 'package:my_app/presentation/screens/home_screen/view/tabs/offline_videos/controller/offline_video_controller.dart';

import '../../../core/constants/color.dart';

    final OfflineVideosController offlineVideoCtrl = Get.put(OfflineVideosController());

AppBar defaultAppBar(BuildContext context,Function callbackAction) {
  return AppBar(
    elevation: 2,
    backgroundColor: Colors.blue,
    titleSpacing: 0,centerTitle: true,
    automaticallyImplyLeading: true,
    title:Center(
      child: Text('Video player',style: TextStyleClass.poppinsRegular(size: 15.00),)
    ),
    actions: [
      InkWell(
        child: Icon(Icons.person,color: ColorConst.white,size: 25,),onTap: (){
              if (offlineVideoCtrl.controller.value.isPlaying) {
                          offlineVideoCtrl.controller.pause();

              }
        callbackAction();
      },
      ),
      SizedBox(width: 20,)
    ],
  );
}