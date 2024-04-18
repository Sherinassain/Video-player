import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:my_app/core/constants/color.dart';
import 'package:my_app/core/constants/textstyle.dart';
import 'package:my_app/core/utiles/app_screen_util.dart';
import 'package:my_app/presentation/screens/home_screen/controller/home_controller.dart';
import 'package:my_app/presentation/widgets/common/common_image_view.dart';

class VideoListLayout extends StatelessWidget {
  final String imagePath;
  final String videoTitle;
  
   VideoListLayout({super.key,required this.imagePath,required this.videoTitle});
    final homeCtrl = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return            Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: AppScreenUtil().screenWidth(120),
                        height: AppScreenUtil().screenHeight(90),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.transparent,
                          
                        ),
                        child:ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CommonImageView(url: imagePath,fit: BoxFit.cover,)) ,
                      ),
                      SizedBox(width: AppScreenUtil().screenWidth(30),)
                      ,
                      Container(
                        height: AppScreenUtil().screenHeight(15),
                        width: AppScreenUtil().screenWidth(160),color: Colors.transparent,
                        child: Obx(() =>  Text(videoTitle,style: TextStyleClass.poppinsMedium(size: 13.00,color:(homeCtrl.isDarkTheme.value == false)?ColorConst.black:ColorConst.white),overflow: TextOverflow.ellipsis,)),
                        )
                    ],
                  ),
      ),
    );
  }
}