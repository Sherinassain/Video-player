import 'package:get/get.dart';
import 'package:my_app/core/common/scale.dart';
import 'package:my_app/core/utiles/app_utils.dart';
import 'package:my_app/presentation/screens/network_error_screen/view/network_error_screen.dart';
import 'package:my_app/routes/index.dart';


import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController{
  var isLoading = true.obs;
    bool isTapped = false;

  void onInit() async {
    isTapped = false;
    // update();
    await Future.delayed(Durations.s3);
    isTapped = true;
    update();
    await Future.delayed(Durations.s1);

    ///redirect to no internet screen if internet is not available
    if (await AppUtils.isOnline()) {
      checkLogin();
    } else {
      Get.to(NetworkErrorScreen());
      // Get.to(NetworkErrorScreen());
    }
    super.onInit();
  }
  void checkLogin() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('myBooleanPreference') ?? false; // Default to false if the preference is not set

  if (isLoggedIn) {
    Get.offNamed(routeName.homeScreen); // Go to the home screen
  } else {
    Get.toNamed(routeName.loginScreen); // Go to the login screen
  }
}

}