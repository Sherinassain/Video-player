import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/core/utiles/app_utils.dart';

import '../../../../routes/index.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  // final GlobalKey<FormState> emailFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> passwordFormKey = GlobalKey<FormState>();

  RxBool otpSend = false.obs;
  RxBool isLoading = false.obs;
  String? _verificationId;

  Future<void> login() async {
    isLoading.value = true;
    try {
      await _verifyPhoneNumber();
    } catch (error) {
      log('Error signing in: $error');
      AppUtils.oneTimeSnackBar("An error occurred. Please try again later.",
          bgColor: Colors.red, time: 3);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _verifyPhoneNumber() async {
    String phoneNumber = '+91${emailController.text.trim()}';
    if (phoneNumber.isEmpty || phoneNumber.length != 13) {
      // Validate phone number length assuming '+91' is included
      AppUtils.oneTimeSnackBar("The provided phone number is not valid.",
          bgColor: Colors.red, time: 3);
      return;
    }
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
        otpSend.value =
            true; // Move inside completion to ensure it's only set on success
      },
      verificationFailed: (FirebaseAuthException e) {
        log(e.toString());
        String errorMessage = 'An unexpected error occurred. Please try again.';
        if (e.code == 'invalid-phone-number') {
          errorMessage = 'The provided phone number is not valid.';
        }
        AppUtils.oneTimeSnackBar(errorMessage, bgColor: Colors.red, time: 3);
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        otpSend.value = true;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  void signInWithPhoneNumber() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otpController.text,
      );
      final User? user =
          (await FirebaseAuth.instance.signInWithCredential(credential)).user;
      if (user != null) {
        print("Successfully signed in UID: ${user.uid}");
        Get.offNamed(routeName.homeScreen);
      } else {
        throw Exception('No user found');
      }
    } catch (e) {
      print("Failed to sign in: $e");
      AppUtils.oneTimeSnackBar("Failed to sign in: ${e.toString()}",
          bgColor: Colors.red, time: 3);
    }
  }
}
