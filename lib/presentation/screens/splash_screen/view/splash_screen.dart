import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/core/common/scale.dart';
import 'package:my_app/core/constants/image.dart';
import 'package:my_app/core/constants/textstyle.dart';
import 'package:my_app/core/utiles/app_screen_util.dart';
import 'package:my_app/presentation/screens/splash_screen/controller/splash_controller.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
    final splashCtrl = Get.put(SplashController());

   @override
  void initState() {
    splashCtrl.onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child:Column(
mainAxisAlignment: MainAxisAlignment.center,
crossAxisAlignment: CrossAxisAlignment.center,
children: [
  Padding(
    padding: const EdgeInsets.all(40),
    child: Image.asset(ImageCons.splashPath,height: AppScreenUtil().screenWidth(130),width:AppScreenUtil().screenWidth(130),),
  ),
  // SizedBox(height: 15,),
  // Text(
  //           "",
  //           style: TextStyleClass.poppinsMedium(
  //             size: FontSizes.f20,
  //             color: Colors.blueAccent,
  //           ),)
],
      ))
    );
  }
}
