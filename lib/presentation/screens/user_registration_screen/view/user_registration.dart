import 'package:flutter/material.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_app/core/common/scale.dart';
import 'package:my_app/core/constants/color.dart';
import 'package:my_app/core/utiles/app_screen_util.dart';
import 'package:my_app/core/utiles/utiles.dart';
import 'package:my_app/presentation/screens/user_registration_screen/view/controller/user_registration_controller.dart';

class UserRegistration extends StatefulWidget {
  const UserRegistration({super.key});

  @override
  State<UserRegistration> createState() => _UserRegistrationState();
}

class _UserRegistrationState extends State<UserRegistration> {
  final userRegCtrl = Get.put(UserRegistrationController());

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

  DateTime? selectedDate;

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        userRegCtrl.dobController.text =
            DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // userRegCtrl.listenToUsers();
    });
  }
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
        return true; 
      },
      child: SafeArea(
          child: Scaffold(
              appBar: AppBar(
                leading: const BackButton(),
              ),
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
                    child: Form(
                      // key: userRegCtrl.firstNameFormkey,
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
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: AppScreenUtil().screenHeight(30)),
                                child: Image.asset(
                                  'assets/gif/Registation.gif',
                                  height: AppScreenUtil().screenWidth(130),
                                  width: AppScreenUtil().screenWidth(130),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: AppScreenUtil().screenHeight(40),
                          ),
                          TextFormFieldCom(
                            formKey: userRegCtrl.firstNameFormkey,
                            controller: userRegCtrl.firstNameController,
                            prefix: const Icon(Icons.person),
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
                          GestureDetector(
                            onTap: () => _selectDate(context),
                            child: AbsorbPointer(
                              child: TextFormFieldCom(
                                formKey: userRegCtrl.dobFormKey,
                                controller: userRegCtrl.dobController,
                                prefix: const Icon(Icons.calendar_month),
                                hintText: 'Dob',
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter a valid last Dob";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: AppScreenUtil().screenHeight(20),
                          ),
                          TextFormFieldCom(
                            formKey: userRegCtrl.emailFormKey,
                            controller: userRegCtrl.emailController,
                            prefix: const Icon(Icons.email),
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
                              prefix: const Icon(Icons.phone_android_outlined),
                              formKey: userRegCtrl.phoneFormKey,
                              controller: userRegCtrl.phoneController,
                              hintText: 'Phone Number',
                              validator: (value) => validatePhoneNumber(value)),
                          SizedBox(
                            height: AppScreenUtil().screenHeight(30),
                          ),
                          Obx(
                            () => (userRegCtrl.isLoading.value == true)
                                ? CircularProgressIndicator(
                                    strokeWidth: 2, color: ColorConst.green3D)
                                : CommonButton(
                                    color: ColorConst.green3D,
                                    title: "Send otp",
                                    fontSize: FontSizes.f15,
                                    onPresss: () {
                                      if (userRegCtrl
                                              .firstNameFormkey.currentState!
                                              .validate() &&
                                          userRegCtrl.dobFormKey.currentState!
                                              .validate() &&
                                          userRegCtrl.emailFormKey.currentState!
                                              .validate() &&
                                          userRegCtrl.phoneFormKey.currentState!
                                              .validate()) {
                                        userRegCtrl.sendOtp(context);
                                      }
                                    },
                                  ),
                          )
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              ))),
    );
  }
}
