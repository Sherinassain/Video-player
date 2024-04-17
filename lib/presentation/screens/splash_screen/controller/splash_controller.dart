// import 'package:get/get.dart';
// import 'package:my_app/core/common/scale.dart';
// import 'package:my_app/core/utiles/app_utils.dart';
// import 'package:my_app/core/utiles/shared_pref_helper.dart';
// import 'package:my_app/core/utiles/shared_pref_key.dart';
// import 'package:my_app/presentation/screens/network_error_screen/view/network_error_screen.dart';
// import 'package:my_app/routes/index.dart';

// class SplashController extends GetxController {
//   var isLoading = true.obs;
//   bool isTapped = false;

//   @override
//   void onInit() async {
//     isTapped = false;
//     // update();
//     await Future.delayed(Durations.s3);
//     isTapped = true;
//     update();
//     await Future.delayed(Durations.s1);

//     ///redirect to no internet screen if internet is not available
//     if (await AppUtils.isOnline()) {
//       checkLogin();
//     } else {
//       Get.to(const NetworkErrorScreen());
//       // Get.to(NetworkErrorScreen());
//     }
//     super.onInit();
//   }


// }
