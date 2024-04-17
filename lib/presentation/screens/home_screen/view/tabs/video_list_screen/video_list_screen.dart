// Example Flutter code to fetch and display video list from Google Drive

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/core/constants/color.dart';
import 'package:my_app/core/utiles/app_screen_util.dart';

import 'package:my_app/presentation/screens/home_screen/view/tabs/video_list_screen/controller/video_list_screen_controller.dart';
import 'package:my_app/presentation/screens/online_video_screen/controller/online_video_screen_controller.dart';
import 'package:my_app/presentation/screens/online_video_screen/online_video_screen.dart';
import 'package:my_app/presentation/widgets/common/default_app_bar.dart';
import 'package:my_app/presentation/widgets/common/theme_sheet.dart';
import 'package:my_app/presentation/widgets/common/video_list_layout.dart';
import 'package:my_app/routes/index.dart';

class VideoListScreen extends StatefulWidget {
  @override
  _VideoListScreenState createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {


final videoListCtrl = Get.put(VideoListScreenController());
final onlineVideoCtrl = Get.put(OnlineVideoScreenController());
  @override
  void initState() {
    videoListCtrl.dataConversion();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Video List'),
            actions: [
              InkWell(
        child:const  Icon(Icons.settings,color: Colors.blue,size: 25,),onTap: (){
        showThemeBottomSheet(context);
      },),
      SizedBox(width: AppScreenUtil().screenWidth(25),),
      InkWell(
        child: Icon(Icons.person,color: Colors.blue,size: 25,),onTap: (){
              Get.toNamed(routeName.profileScreen);
      },
      ),
      SizedBox(width: 20,)
    ],
        ),
        body: Obx(() => (videoListCtrl.isLoading.value == true)?Center(child: CircularProgressIndicator(strokeWidth: 2,color: ColorConst.green3D,),): Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                  Column(children: List.generate(videoListCtrl.videoDataResList.length, (index) => GestureDetector(
                    onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context){
              onlineVideoCtrl.videoUrl.value = videoListCtrl.videoDataResList[index].videoUrl;
            return  OnlineVideoScreen(videoUrl: videoListCtrl.videoDataResList[index].videoUrl,);
            }));
                    },
                    child: VideoListLayout(imagePath: videoListCtrl.videoDataResList[index].thumbnailUrl, videoTitle: videoListCtrl.videoDataResList[index].title))),)
              ],
            ),
          ),
        )));
  }
}
