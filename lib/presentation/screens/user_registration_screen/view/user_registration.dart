import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:my_app/core/common/scale.dart';
import 'package:my_app/core/constants/color.dart';
import 'package:my_app/core/constants/image.dart';
import 'package:my_app/core/constants/textstyle.dart';
import 'package:my_app/core/utiles/app_screen_util.dart';
import 'package:my_app/core/utiles/utiles.dart';
import 'package:my_app/presentation/screens/user_registration_screen/view/controller/user_registration_controller.dart';
import 'package:my_app/routes/index.dart';


class UserRegistration extends StatefulWidget {
  UserRegistration({super.key});

  @override
  State<UserRegistration> createState() => _UserRegistrationState();
}

class _UserRegistrationState extends State<UserRegistration> {
  final userRegCtrl = Get.put(UserRegistrationController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            // appBar: PreferredSize(
            //     preferredSize:
            //         Size.fromHeight(AppScreenUtil().screenHeight(100)),
            //     child: Container(
            //       decoration: BoxDecoration(
            //         color: ColorConst.white,
            //       ),
            //       child:  Center(
      
            //           child: Padding(
            //             padding:  EdgeInsets.only(top: AppScreenUtil().screenHeight(50)),
            //             child: 
                        
            //             Image.asset('assets/gif/Registation.gif',height: AppScreenUtil().screenWidth(200),width: AppScreenUtil().screenWidth(200),),
            //           ),
            //         ),
            //     )),
            backgroundColor: ColorConst.white,
            body: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(
                    left: AppScreenUtil().screenWidth(20),
                    right: AppScreenUtil().screenWidth(20),
                    bottom: AppScreenUtil().screenWidth(40)),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Text(
                      //   "Register",
                      //   style: TextStyleClass.poppinsRegular(
                      //       color: Colors.black, size: 28.0),
                      // ),
                      Container(
                decoration: BoxDecoration(
                  color: ColorConst.white,
                ),
                child:  Center(
                    
                    child: Padding(
                      padding:  EdgeInsets.only(top: AppScreenUtil().screenHeight(30)),
                      child: 
                      
                      Image.asset('assets/gif/Registation.gif',height: AppScreenUtil().screenWidth(130),width: AppScreenUtil().screenWidth(130),),
                    ),
                  ),
              ),
                      SizedBox(
                        height: AppScreenUtil().screenHeight(40),
                      ),
                      TextFormFieldCom(
                        // formKey: userRegCtrl.firstNameFormKey,
                        // controller: userRegCtrl.firstNameController,
                        hintText: 'First name',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter a valid first name";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: AppScreenUtil().screenHeight(20),
                      ),
                      TextFormFieldCom(
                        // formKey: userRegCtrl.lastNameFormKey,
                        // controller: userRegCtrl.lastNameController,
                        hintText: 'Dob',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter a valid last Dob";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: AppScreenUtil().screenHeight(20),
                      ),
                      TextFormFieldCom(
                        // formKey: userRegCtrl.emailorPhoneNumberFormKey,
                        // controller: userRegCtrl.emailorPhoneNumberController,
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
                        // formKey: userRegCtrl.PasswordFormKey,
                        // controller: userRegCtrl.PasswordController,
                        hintText: 'Password',
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length < 8) {
                            return "Please enter a valid password";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: AppScreenUtil().screenHeight(30),
                      ),
                      // Obx(
                      //   () => (userRegCtrl.isLoading.value == true)
                      //       ? CircularProgressIndicator(
                      //           strokeWidth: 2,
                      //           color: ColorConst.green3D,
                      //         )
                      //       :
                             CommonButton(
                                color: ColorConst.green3D,
                                title: "Send otp",
                                fontSize: FontSizes.f15,
                                onPresss: () {
                                  Get.toNamed(routeName.otpVerifyScreen);
                                  // if (userRegCtrl
                                  //         .firstNameFormKey.currentState!
                                  //         .validate() &&
                                  //     userRegCtrl
                                  //         .lastNameFormKey.currentState!
                                  //         .validate() &&
                                  //     userRegCtrl.emailorPhoneNumberFormKey
                                  //         .currentState!
                                  //         .validate() &&
                                  //     userRegCtrl
                                  //         .PasswordFormKey.currentState!
                                  //         .validate()) {
                                  //   userRegCtrl
                                  //       .userRegistration(
                                  //           firstName: userRegCtrl
                                  //               .firstNameController.text,
                                  //           lastName: userRegCtrl
                                  //               .lastNameController.text,
                                  //           emailorPhone: userRegCtrl
                                  //               .emailorPhoneNumberController
                                  //               .text,
                                  //           password: userRegCtrl
                                  //               .PasswordController.text)
                                  //       .then((value) {
                                  //     if (value == true) {
                                  //       Get.offNamed(routeName.loginScreen);
                                  //     }
                                  //   });
                                  // }
                                },
                              ),
                      // ),
                    ],
                  ),
                ),
              ),
            )));
  }
}
