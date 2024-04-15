import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/core/utiles/app_utils.dart';
import 'package:my_app/routes/index.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> emailFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> passwordFormKey = GlobalKey<FormState>();

  var isLoading = false.obs;
  Future<void> login() async {
    isLoading.value = true;
    try {
      FirebaseAuth auth = FirebaseAuth.instance;

      final UserCredential userCredential =
          await auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      if (userCredential.user != null) {
        Get.offNamed(routeName.homeScreen);
      } else {
              AppUtils.oneTimeSnackBar(
          "Login failed. Please check your credentials.",
          bgColor: Colors.red,
          time: 3);
  
      }
    } catch (error) {
      print('Error signing in: $error');
              AppUtils.oneTimeSnackBar(
          "An error occurred. Please try again later.",
          bgColor: Colors.red,
          time: 3);

    } finally {
    isLoading.value = false;
    }
  }
}
