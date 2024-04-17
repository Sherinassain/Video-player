import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/core/constants/image.dart';
import 'package:my_app/core/utiles/app_screen_util.dart';

import '../../../../core/utiles/shared_pref_helper.dart';
import '../../../../core/utiles/shared_pref_key.dart';
import '../../../../routes/index.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // final splashCtrl = Get.put(SplashController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(const Duration(seconds: 3), () => checkLogin());
    });
  }

  void checkLogin() async {
    final isLoggedIn = await SharedPreferenceHelper()
        .readBoolData(SharedPreferencesKeys.isLoggedIn);
    if (isLoggedIn) {
      Get.offNamed(routeName.homeScreen); // Go to the home screen
    } else {
      Get.toNamed(routeName.loginScreen); // Go to the login screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(40),
              child: Image.asset(
                ImageCons.splashPath,
                height: AppScreenUtil().screenWidth(130),
                width: AppScreenUtil().screenWidth(130),
              ),
            ),
          ],
        )));
  }
}
