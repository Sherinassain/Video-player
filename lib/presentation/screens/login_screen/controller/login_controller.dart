import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/core/utiles/app_utils.dart';
import 'package:my_app/core/utiles/shared_pref_helper.dart';

import '../../../../core/utiles/shared_pref_key.dart';
import '../../../../routes/index.dart';

class LoginController extends GetxController {
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  // final GlobalKey<FormState> emailFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> passwordFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> phoneFormKey = GlobalKey<FormState>();

  RxBool otpSend = false.obs;
  RxBool isLoading = false.obs;
  String? _verificationId;
  String? number;
  final databaseRef = FirebaseDatabase.instance.ref();

  Future<void> login() async {
    isLoading.value = true;
    try {
      await _verifyPhoneNumber();
    } catch (error) {
      log('Error signing in: $error');
      AppUtils.oneTimeSnackBar("An error occurred. Please try again later.",
          bgColor: Colors.red, time: 3);
                isLoading.value = false;

    } 
  }

  Future<void> _verifyPhoneNumber() async {
    String phoneNumber = '+91${phoneController.text.trim()}';

    if (phoneNumber.isEmpty || phoneNumber.length != 13) {
      AppUtils.oneTimeSnackBar("The provided phone number is not valid.",
          bgColor: Colors.red, time: 3);
      return;
    }

    // Check if the phone number is already in the database
    // final DatabaseReference dbRef = FirebaseDatabase.instance.ref('users');
    // final query = dbRef.orderByChild('phone_number').equalTo(phoneNumber);
    // final dataSnapshot = await query.once();

    // if (dataSnapshot.snapshot.value != null) {
    //   // If data exists, phone number is already used
    //   AppUtils.oneTimeSnackBar("Phone number is already registered.",
    //       bgColor: Colors.red, time: 3);
    //   return;
    // }

    // Proceed with Firebase phone number verification if phone number is not registered
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);

        otpSend.value = true;
              isLoading.value = false;

      },
      verificationFailed: (FirebaseAuthException e) {
        log(e.toString());
        String errorMessage = 'An unexpected error occurred. Please try again.';
        if (e.code == 'invalid-phone-number') {
          errorMessage = 'The provided phone number is not valid.';
        }
        AppUtils.oneTimeSnackBar(errorMessage, bgColor: Colors.red, time: 3);
              isLoading.value = false;

      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        otpSend.value = true;
              isLoading.value = false;

      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
        AppUtils.oneTimeSnackBar(
          "Session Expired ! , Please try again",
          bgColor: Colors.red,
          time: 3);
              isLoading.value = false;

      },
    );
  }

   Future<void> signInWithPhoneNumber() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otpController.text,
      );
      final User? user =
          (await FirebaseAuth.instance.signInWithCredential(credential)).user;
      await getPhoneNumber(user?.uid ?? "").then((value) {
        if (number == phoneController.text.trim()) {
          Get.offNamed(routeName.homeScreen);
        } else {
          otpSend.value = false;
          AppUtils.oneTimeSnackBar("User not found, please register",
              bgColor: Colors.red, time: 3);
        }
      });
    } catch (e) {
      print("Failed to sign in: $e");
      AppUtils.oneTimeSnackBar("Failed to sign in: ${e.toString()}",
          bgColor: Colors.red, time: 3);
    }
  }

  //
  Future<void> getPhoneNumber(String uid) async {
    // DatabaseReference starCountRef = FirebaseDatabase.instance.ref();
    DataSnapshot? snapshot;
    snapshot = await databaseRef.child('users/$uid').get();
    // } else {
    // snapshot = await starCountRef.child('data/${userModel.parentUuid}').get();
    // }
    // final snapshot = await starCountRef.child('data/${userModel.uuid}').get();
    if (snapshot.exists) {
      if ((snapshot.value! as Map)['phone_number'] != null) {
        // setState(() {
        //   if (userModel.isParentUser) {
        number = (snapshot.value! as Map)['phone_number'];
      await  SharedPreferenceHelper()
            .writeData(SharedPreferencesKeys.phoneNumber, number ?? "");
       await SharedPreferenceHelper().writeData(
            SharedPreferencesKeys.name, (snapshot.value! as Map)['name'] ?? "");
       await SharedPreferenceHelper().writeData(
            SharedPreferencesKeys.email, (snapshot.value! as Map)['email']);
       await SharedPreferenceHelper().writeData(
            SharedPreferencesKeys.dob, (snapshot.value! as Map)['dob'] ?? "");
        // [userModel.uuid]['balance'];
        // } else {
        //   creditsAvailable = (snapshot?.value! as Map)['balance'];
      }
      // // [userModel.parentUuid]['balance'];
      // }
      // );
    }
  }
}
