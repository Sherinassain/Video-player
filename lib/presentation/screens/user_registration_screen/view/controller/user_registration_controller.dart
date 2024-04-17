import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/core/utiles/app_utils.dart';
import 'package:my_app/presentation/screens/otp_verify_screen/view/otp_verify_screen.dart';

import '../../../../../routes/index.dart';

class UserRegistrationController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  // final GlobalKey<FormState> emailFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> firstNameFormkey = GlobalKey<FormState>();
  // final GlobalKey<FormState> dobFormKey = GlobalKey<FormState>();
  // final GlobalKey<FormState> phoneFormKey = GlobalKey<FormState>();

  RxBool isLoading = false.obs;
  RxBool otpSend = false.obs;
  String? _verificationId;
  String? uid;
  Future<void> sendOtp(BuildContext context) async {
    isLoading.value = true;
    // if (!firstNameFormkey.currentState!.validate()) {
    //   isLoading.value = false;
    //   return;
    // }
    try {
      await _verifyPhoneNumber(context);
    } catch (error) {
      AppUtils.oneTimeSnackBar("An error occurred. Please try again later.",
          bgColor: Colors.red, time: 3);
      print('Error signing in: $error');
    } finally {
      isLoading.value = false;
    }
  }

  Future<String?> getPhoneNumber(String uid) async {
    try {
      // Reference to the Firestore document
      DocumentReference docRef =
          FirebaseFirestore.instance.collection('users').doc(uid);

      // Get the document
      DocumentSnapshot docSnapshot = await docRef.get();

      // Check if the document exists
      if (docSnapshot.exists) {
        // Extract the phone number from the document data
        final phoneNumber = docSnapshot.data() as Map<String, dynamic>?;
        String number = phoneNumber?['phone'];
        return number;
      } else {
        // Handle the case where there is no user data available
        print("No user found for UID: $uid");
        return null;
      }
    } catch (e) {
      // Print error message if something goes wrong
      print("Error fetching user data: $e");
      return null;
    }
  }

  Future<void> _verifyPhoneNumber(BuildContext context) async {
    final phoneNumber = '+91${phoneController.text.trim()}';

    // Check if the phone number is already registered

    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
        _verificationId = credential.verificationId!; //
        final AuthCredential credentials = PhoneAuthProvider.credential(
          verificationId: credential.verificationId!,
          smsCode: otpController.text.trim(),
        );

        final User? user =
            (await FirebaseAuth.instance.signInWithCredential(credential)).user;
        uid = user?.uid;
        final phoneQuery = getPhoneNumber(uid ?? "");

        if (phoneQuery == phoneNumber) {
          AppUtils.oneTimeSnackBar("Phone number is already registered",
              bgColor: Colors.red, time: 3);
          return;
        }
        otpSend.value = true;
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
        print(e.code);
        AppUtils.oneTimeSnackBar(e.message ?? "Unknown error occurred",
            bgColor: Colors.red, time: 3);
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        otpSend.value = true;
        // Get.offNamed(routeName.otpVerifyScreen);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => OtpVerifyScreen(
                      verificationId: _verificationId!,
                      dob: dobController.text.trim(),
                      email: emailController.text.trim(),
                      name: firstNameController.text.trim(),
                      phone: phoneController.text.trim(),
                    )),
            (route) => false);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  Future<void> confirmCodeAndRegister(String? verificationId, String? phone,
      String? email, String? name, String? dob) async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: otpController.text.trim(),
      );

      final User? user =
          (await FirebaseAuth.instance.signInWithCredential(credential)).user;

      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': name,
          'email': email,
          'phone': phone,
          'date_of_birth': dob,
        });
        Get.offNamed(routeName.homeScreen);
        print("User signed up and data saved: ${user.uid}");
      }
    } catch (e) {
      AppUtils.oneTimeSnackBar("Failed to sign in: $e",
          bgColor: Colors.red, time: 3);
      print("Failed to sign in: $e");
    }
  }

  void listenToUsers() {
    FirebaseFirestore.instance
        .collection('users')
        .snapshots()
        .listen((snapshot) {
      for (final DocumentSnapshot document in snapshot.docs) {
        print(document.data());
      }
    });
  }
}
