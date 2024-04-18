import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/core/constants/color.dart';
import 'package:my_app/core/constants/textstyle.dart';
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
        leading: const BackButton(),
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
                  // key: verifyOtpScreenCtrl.otpFormKey,
                  child: Pinput(
                    length: 6,
                    controller: verifyOtpScreenCtrl.otpController,
                    onCompleted: (value) async =>
                        await verifyOtpScreenCtrl.confirmCodeAndRegister(
                      widget.verificationId,
                      widget.phone,
                      widget.email,
                      widget.name,
                      widget.dob,
                      context: context,
                    ),
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
              // const SizedBox(
              //   height: 10,
              // ),
              // Visibility(
              //   visible: validationKey,
              //   child: Text(
              //     'OTP incomplete',
              //     style: TextStyleClass.poppinsRegular(
              //       color: ColorConst.red,
              //       size: 12.0,
              //     ),
              //   ),
              // ),
              // const SizedBox(
              //   height: 30,
              // ),
              // (_showText == true)
              //     ? RichText(
              //         text: TextSpan(
              //           children: [
              //             TextSpan(
              //               text: "Re-send code in ",
              //               style: TextStyleClass.poppinsRegular(
              //                 color: ColorConst.black1F,
              //                 size: 15.0,
              //               ),
              //             ),
              //             TextSpan(
              //               text: "$_remainingSeconds",
              //               style: TextStyleClass.poppinsRegular(
              //                 color: ColorConst.appColor,
              //                 size: 15.0,
              //               ),
              //             ),
              //           ],
              //         ),
              //       )
              //     :
              //     // Obx(
              //     //     () => (sendOtpDetailScreenCtrl.isOtpSendLoading.value ==
              //     //             true)
              //     //         ? CommonProgressIndicator(
              //     //             indicatorColor: ColorConst.appColor,
              //     //           )
              //     //         :
              //     GestureDetector(
              //         onTap: () async {
              //           // await sendOtpDetailScreenCtrl
              //           //     .sendDeliveryOtp(
              //           //   orderId: orderDetailScreenCtrl
              //           //       .orderDetailRes!.id
              //           //       .toString(),
              //           // )
              //           //     .then((value) {
              //           //   if (sendOtpDetailScreenCtrl
              //           //           .otpSendSuccess.value ==
              //           //       true) {
              //           //     setState(() {
              //           //       _remainingSeconds = 20;
              //           //       _showText = true;
              //           //       _startTimer();
              //           //     });
              //           //   }
              //           // });
              //           // print(
              //           //     "Resend otp order id : ${orderDetailScreenCtrl.orderDetailRes!.id.toString()}");
              //         },
              //         child: Container(
              //           width: 130,
              //           height: 40,
              //           decoration: BoxDecoration(
              //               color: ColorConst.green3D,
              //               borderRadius: BorderRadius.circular(8)),
              //           child: Center(
              //             child: Text(
              //               "Re-send OTP",
              //               style: TextStyleClass.poppinsRegular(
              //                 color: ColorConst.white,
              //                 size: 15.0,
              //               ),
              //             ),
              //           ),
              //         ),
              //       ),
              // SizedBox(
              //   height: Get.height / 2.2,
              // ),
              // Padding(
              //     padding:
              //         const EdgeInsets.only(bottom: 30, left: 2.5, right: 2.5),
              //     child:
              //         // Obx(
              //         //   () =>
              //         //       (verifyOtpScreenCtrl.isOtpVerifyLoading.value == true)
              //         //           ? CommonProgressIndicator(
              //         //               indicatorColor: ColorConst.appColor,
              //         //             )
              //         //           :
              //         CommonButton(
              //       color: ColorConst.green3D,
              //       title: "Verify",
              //       fontSize: 20.0,
              //       onPresss: () async {
              //         Get.toNamed(routeName.homeScreen);
              //         // print(
              //         //     'Otp  field text :${verifyOtpScreenCtrl.verifyOtpController.text}');
              //         // print(
              //         //     ' Verify otp Order id : ${orderDetailScreenCtrl.orderDetailRes!.id.toString()}');
              //         // if (verifyOtpScreenCtrl
              //         //     .otpFormKey.currentState!
              //         //     .validate()) {
              //         //   await verifyOtpScreenCtrl
              //         //       .verifyDeliveryOtp(
              //         //           orderId: orderDetailScreenCtrl
              //         //               .orderDetailRes!.id
              //         //               .toString(),
              //         //           otp: verifyOtpScreenCtrl
              //         //               .verifyOtpController.text)
              //         //       .then((value) {
              //         //     if (verifyOtpScreenCtrl
              //         //             .otpVerifySuccess.value ==
              //         //         true) {
              //         //       Get.toNamed(
              //         //           routeName.deliveryDetailScreen);
              //         //       // Get.to(
              //         //       //   () => DeliveryDetailScreen(),
              //         //       // );
              //         //     }
              //         //   });
              //         // }
              //       },
              //     )),
            ],
          ),
        ),
      ),
    );
  }
}
