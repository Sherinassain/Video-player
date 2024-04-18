import 'package:flutter/material.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:my_app/core/common/scale.dart';
import 'package:my_app/core/constants/color.dart';
import 'package:my_app/core/constants/textstyle.dart';
import 'package:my_app/core/utiles/app_screen_util.dart';
import 'package:my_app/core/utiles/app_utils.dart';
import 'package:my_app/core/utiles/utiles.dart';
import 'package:my_app/presentation/screens/login_screen/controller/login_controller.dart';
import 'package:my_app/routes/index.dart';
import 'package:pinput/pinput.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final loginCtrl = Get.put(LoginController());
  DateTime? lastPressed;

  String? validatePhoneNumber(
    String? value,
  ) {
    // final usedNumber = context.read<OtpVerificationProvider>().isUsedNumber;
    final phoneNumberValidator = value?.trim();
    if (phoneNumberValidator!.isEmpty) {
      return 'Phone number is required';
    }
    if (phoneNumberValidator.length != 10) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  @override
  void initState() {
    loginCtrl.otpSend.value = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        DateTime now = DateTime.now();
        if (lastPressed == null ||
            now.difference(lastPressed!) > const Duration(seconds: 2)) {
          lastPressed = now;
          Fluttertoast.showToast(
            msg: "Press back again to exit",
            backgroundColor: Colors.black,
            textColor: Colors.white,
          );
          return false;
        }

        ///Exit the app
        FlutterExitApp.exitApp();
        return true;
      },
      child: SafeArea(
          child: Scaffold(
              appBar: PreferredSize(
                  preferredSize:
                      Size.fromHeight(AppScreenUtil().screenHeight(200)),
                  child: Container(
                    decoration: BoxDecoration(
                      color: ColorConst.white,
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: AppScreenUtil().screenHeight(100)),
                        child: Image.asset(
                          'assets/gif/login.gif',
                          height: AppScreenUtil().screenWidth(150),
                          width: AppScreenUtil().screenWidth(100),
                        ),
                      ),
                    ),
                  )),
              backgroundColor: ColorConst.white,
              body: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  height: AppScreenUtil().screenHeight(480),
                  decoration: BoxDecoration(color: ColorConst.white),
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: AppScreenUtil().screenWidth(30),
                        left: AppScreenUtil().screenWidth(20),
                        right: AppScreenUtil().screenWidth(20),
                        bottom: AppScreenUtil().screenWidth(20)),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: AppScreenUtil().screenHeight(40),
                          ),
                          TextFormFieldCom(
                              prefix: const Icon(Icons.phone_android_outlined),
                              formKey: loginCtrl.phoneFormKey,
                              controller: loginCtrl.phoneController,
                              hintText: 'Phone Number',
                              onChange: (value){
                                loginCtrl.otpSend.value = false;

                              },
                              validator: (value) => validatePhoneNumber(value)),
                          SizedBox(
                            height: AppScreenUtil().screenHeight(30),
                          ),
                          Obx(
                            () => ((loginCtrl.otpSend.value == true))
                                ? Column(
                                    children: [
                                      Pinput(
                                        length: 6,
                                        controller: loginCtrl.otpController,
                                        pinputAutovalidateMode:
                                            PinputAutovalidateMode.onSubmit,
                                        onCompleted: (value) {
                                          AppUtils.oneTimeSnackBar(
                                              "Please wait Few moments",
                                              bgColor: Colors.green,
                                              time: 3);
                                          loginCtrl.signInWithPhoneNumber();
                                        },
                                      ),
                                      SizedBox(
                                        height:
                                            AppScreenUtil().screenHeight(30),
                                      ),
                                    ],
                                  )
                                : const SizedBox(),
                          ),
                          Obx(() => (loginCtrl.isLoading.value == true)
                              ? CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: ColorConst.green3D,
                                )
                              : (loginCtrl.otpSend.value == false)
                                  ? CommonButton(
                                      color: ColorConst.green3D,
                                      title: "Send OTP",
                                      fontSize: FontSizes.f15,
                                      onPresss: () {
                                        if (loginCtrl.phoneFormKey.currentState!
                                            .validate()) {
                                          loginCtrl.login();
                                        }
                                      },
                                    )
                                  : const SizedBox()),
                          SizedBox(
                            height: AppScreenUtil().screenHeight(180),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Don't have any account?",
                                style: TextStyleClass.poppinsRegular(
                                    color: Colors.black, size: 13.0),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed(routeName.userRegistration);
                                },
                                child: Text(
                                  "Sign Up",
                                  style: TextStyleClass.poppinsMedium(
                                      color: Colors.blueAccent, size: 13.0),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ))),
    );
  }
}
