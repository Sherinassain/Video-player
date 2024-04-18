import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
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
  final databaseRef = FirebaseDatabase.instance.ref();

  RxBool isLoading = false.obs;
  RxBool otpSend = false.obs;
  String? _verificationId;
  String? uid;
  String? number;
  Future<void> sendOtp(BuildContext context) async {
    isLoading.value = true;
    // if (!firstNameFormkey.currentState!.validate()) {
    //   isLoading.value = false;
    //   return;
    // }
    try {
      await verifyPhoneNumber(context);
    } catch (error) {
      AppUtils.oneTimeSnackBar("An error occurred. Please try again later.",
          bgColor: Colors.red, time: 3);
      print('Error signing in: $error');
    } finally {
      isLoading.value = false;
    }
  }

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
        // [userModel.uuid]['balance'];
        // } else {
        //   creditsAvailable = (snapshot?.value! as Map)['balance'];
      }
      // // [userModel.parentUuid]['balance'];
      // }
      // );
    }
  }
// }

  Future<void> verifyPhoneNumber(BuildContext context) async {
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
        await getPhoneNumber(uid ?? "");

        if (number == phoneNumber) {
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
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OtpVerifyScreen(
                    verificationId: _verificationId!,
                    dob: dobController.text.trim(),
                    email: emailController.text.trim(),
                    name: firstNameController.text.trim(),
                    phone: phoneController.text.trim(),
                  )),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  Future<void> confirmCodeAndRegister(String? verificationId, String? phone,
      String? email, String? name, String? dob,
      {required BuildContext context}) async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: otpController.text.trim(),
      );
      final User? user =
          (await FirebaseAuth.instance.signInWithCredential(credential)).user;
      await listenToUsers(user?.uid ?? "");
      if (number != phone) {
        databaseRef.child("users/${user?.uid}").set(
            {'name': name, 'email': email, 'phone_number': phone, 'dob': dob});
        Get.offNamed(routeName.homeScreen);
        print("User signed up and data saved: ${user?.uid}");
      } else {
        Navigator.pop(context);
        AppUtils.oneTimeSnackBar("Already registered, please login",
            bgColor: Colors.red, time: 3);
      }
    } catch (e) {
      AppUtils.oneTimeSnackBar("Failed to sign in: $e",
          bgColor: Colors.red, time: 3);
      print("Failed to sign in: $e");
    }
  }

  Future<void> listenToUsers(String uid) async {
    // databaseRef.onValue.listen(
    //   (DatabaseEvent event) {
    //     final data = event.snapshot.value;
    //     if ((data as Map)['users'].containsKey(uid)) {
    //       number = (data)['users'][uid]['phone_number'];
    //       // Handle the data as required, possibly updating UI elements
    //     } else {
    //       number = null;
    //       otpSend.value = false;
    //     }
    //   },
    //   onError: (error) {
    //     // Handle errors or situations where the data cannot be retrieved
    //     print("Error occurred: $error");
    //   },
    // );
    //  if (userModel.isParentUser) {
    DataSnapshot? snapshot;
    snapshot = await databaseRef.child('users/$uid').get();
    // } else {
    // snapshot = await starCountRef.child('data/${userModel.parentUuid}').get();
    // }
    // final snapshot = await starCountRef.child('data/${userModel.uuid}').get();
    if (snapshot.exists) {
      if ((snapshot.value! as Map)['phone_number'] != null) {
        // setState(() {
        // if (userModel.isParentUser) {
        number = (snapshot.value! as Map)['phone_number'];
        // [userModel.uuid]['balance'];
        // } else {
        //   creditsAvailable = (snapshot?.value! as Map)['balance'];
        //   // [userModel.parentUuid]['balance'];
        // }
        // });
      }
    }
    // return true;
  }
}
