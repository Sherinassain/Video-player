import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:get/get_core/src/get_main.dart';
import 'package:my_app/core/common/scale.dart';
import 'package:my_app/core/constants/color.dart';
import 'package:my_app/core/constants/image.dart';
import 'package:my_app/core/constants/textstyle.dart';
import 'package:my_app/core/utiles/app_screen_util.dart';
import 'package:my_app/core/utiles/utiles.dart';
import 'package:my_app/presentation/screens/login_screen/controller/login_controller.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:flutter_exit_app/flutter_exit_app.dart';
import 'package:my_app/routes/index.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final loginCtrl = Get.put(LoginController());
  DateTime? lastPressed;

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
        return true; // Return true to allow the app to exit
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
                          // const    Text(
                          //       "Login",
                          //       style:TextStyle(color: Colors.black, fontSize: 28.0)
                          //     ),
                          SizedBox(
                            height: AppScreenUtil().screenHeight(40),
                          ),
                          TextFormFieldCom(
                            formKey: loginCtrl.emailFormKey,
                            controller: loginCtrl.emailController,
                            hintText: 'Email',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter an email address";
                              }

                              // Define a regular expression for email validation
                              final emailRegex = RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

                              if (!emailRegex.hasMatch(value)) {
                                return "Please enter a valid email address";
                              }

                              return null;
                            },
                          ),
                          SizedBox(
                            height: AppScreenUtil().screenHeight(20),
                          ),
                          TextFormFieldCom(
                            formKey: loginCtrl.passwordFormKey,
                            controller: loginCtrl.passwordController,
                            hintText: 'Password',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter valid password";
                              }

                              // Define a regular expression for email validation
        final passwordRegex = RegExp(r'^.{8,}$');

                              if (!passwordRegex.hasMatch(value)) {
                                return "Please enter valid password";
                              }

                              return null;
                            },
                          ),
                          SizedBox(
                            height: AppScreenUtil().screenHeight(30),
                          ),
                          Obx(
                            () => (loginCtrl.isLoading.value == true)
                                ? CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: ColorConst.green3D,
                                  )
                                :
                          CommonButton(
                            color: ColorConst.green3D,
                            title: "Login",
                            fontSize: FontSizes.f15,
                            onPresss: () {
                              if (loginCtrl.emailFormKey.currentState!
                                      .validate() &&
                                  loginCtrl.passwordFormKey.currentState!
                                      .validate()) {
                                        loginCtrl.login();
                                      }
                        
                            },
                          ),),

                          SizedBox(
                            height: AppScreenUtil().screenHeight(20),
                          ),
                          // Align(
                          //   alignment: Alignment.topRight,
                          //   child: GestureDetector(
                          //     onTap: () {
                          //       Get.toNamed(routeName.forgotPasswordScreen);
                          //     },
                          //     child: Text(
                          //       "Forgot password",
                          //       style: TextStyleClass.poppinsMedium(
                          //           color: Colors.blueAccent, size: 15.0),
                          //     ),
                          //   ),
                          // ),
                          SizedBox(
                            height: AppScreenUtil().screenHeight(100),
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
