import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:my_app/core/constants/textstyle.dart';
import 'package:my_app/core/utiles/app_screen_util.dart';
import 'package:my_app/presentation/screens/home_screen/view/tabs/offline_videos/controller/offline_video_controller.dart';
import 'package:my_app/presentation/screens/online_video_screen/controller/online_video_screen_controller.dart';
import 'package:my_app/routes/index.dart';

import '../../../core/constants/color.dart';

    final OfflineVideosController offlineVideoCtrl = Get.put(OfflineVideosController());
  final onlineVideoScreenCtrl = Get.put(OnlineVideoScreenController());

AppBar defaultAppBar() {
  return AppBar(
    elevation: 2,
    backgroundColor: Colors.blue,
    titleSpacing: 0,centerTitle: true,
    automaticallyImplyLeading: true,
    title:Center(
      child: Text('Video player',style: TextStyleClass.poppinsRegular(size: 15.00,color: ColorConst.white),)
    ),
    actions: [
            
      InkWell(
        child: Icon(Icons.person,color: ColorConst.white,size: 25,),onTap: (){
              onlineVideoScreenCtrl.stopVideo();
              Get.toNamed(routeName.profileScreen);
      },
      ),
      SizedBox(width: 20,)
    ],
  );
}