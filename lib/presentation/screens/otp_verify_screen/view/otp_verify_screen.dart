import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/core/common/scale.dart';
import 'package:my_app/core/constants/color.dart';
import 'package:my_app/core/constants/textstyle.dart';
import 'package:my_app/core/utiles/app_screen_util.dart';
import 'package:my_app/core/utiles/utiles.dart';
import 'package:my_app/presentation/screens/otp_verify_screen/controller/otp_verify_controller.dart';
import 'package:my_app/presentation/screens/user_registration_screen/view/controller/user_registration_controller.dart';
import 'package:pinput/pinput.dart';

class OtpVerifyScreen extends StatefulWidget {
  final String? verificationId;
  final String? phone;
  final String? email;
  final String? dob;
  final String? name;

  const OtpVerifyScreen(
      {super.key,
      this.verificationId,
      this.phone,
      this.email,
      this.dob,
      this.name});
  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  final FocusNode _pinPutFocusNode = FocusNode();

  final verifyOtpScreenCtrl = Get.put(UserRegistrationController());
    final otpCtrl = Get.put(OtpVerifyController());

  bool validationKey = false;

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(12),
    );
  }

  late Timer _timer;

  int _remainingSeconds = 20;

  bool _showText = true;
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        setState(() {
          _showText = !_showText;
        });
        _timer.cancel();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConst.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        foregroundColor: ColorConst.black1F,
        elevation: 0,
        backgroundColor: ColorConst.white,
        centerTitle: true,
        title: Text(
          "Verification",
          style: TextStyleClass.poppinsMedium(
            size: 20.0,
            color: ColorConst.black1F,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                "We’ve Send You The Verification\nCode On ${verifyOtpScreenCtrl.phoneController.text}",
                style: TextStyleClass.poppinsRegular(
                  size: 15.0,
                  color: ColorConst.black1F,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
            Container(
  color: ColorConst.white,
  child: Form(
    key: otpCtrl.otpFormKey,
    child: Pinput(
      length: 6,
      controller: verifyOtpScreenCtrl.otpController,
      validator: (value) {
        if (value == null || value.length != 6) {
          setState(() {
            validationKey = true;
          });
          return "OTP incomplete";
        }
        setState(() {
          validationKey = false;
        });
        return null;
      },
      focusNode: _pinPutFocusNode,
    ),
  ),
),
SizedBox(height: AppScreenUtil().screenHeight(30)),
CommonButton(
  color: ColorConst.green3D,
  title: "Verify OTP",
  fontSize: FontSizes.f15,
  onPresss: (){
        if (otpCtrl.otpFormKey.currentState!.validate()) {
      verifyOtpScreenCtrl.confirmCodeAndRegister(
        widget.verificationId,
        widget.phone,
        widget.email,
        widget.name,
        widget.dob,
      );
    }
  },
)
            ],
          ),
        ),
      ),
    );
  }
}
