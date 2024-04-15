//ignore_for_file:file_names
// import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:my_app/core/config/session.dart';
import 'package:my_app/core/constants/color.dart';

// import 'package:shared_preferences/shared_preferences.dart';

// import '../../app_config.dart';
import '../../main.dart';
// import '../../routes.dart';

class AppUtils {
  ///use to print any data for testing and later will be useful to remove the print inside this
  printError(data) {
    print('============Error===============');
    print(data);
    print('============Error===============');
  }

  printData(data, {String info = 'DATA'}) {
    print('============$info===============');
    print(data);
    print('============$info===============');
  }


  tapWithNetworkCheckn(Function() function) {
    if (true) {
      function();
    }
  }


  static Logger logger = Logger();



  clearSnackBar() {
    ScaffoldMessenger.of(Get.context!).clearSnackBars();
  }

  // static NumberFormat formatter = NumberFormat('#,##,000');
  static snackBar(
    String? message, {
    int time = 2,
    Color? bgColor,
    TextStyle? textStyle,
    BuildContext? context,
    bool showOnTop = false,
  }) {
    // ScaffoldMessenger.of(Get.context!).clearSnackBars();///To CLEAR PREVIOUS SNACK BARS
    return ScaffoldMessenger.of(context ?? Get.context!).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: bgColor ?? Colors.blue,
        content: Text(message!, style: textStyle),
        duration: Duration(seconds: time),
        margin: showOnTop
            ? EdgeInsets.only(
                bottom:
                    MediaQuery.of(context ?? Get.context!).size.height - 100,
                right: 20,
                left: 20)
            : null,
      ),
    );
  }

  static tapWithNetworkCheck(Function() function) async {
    if (await AppUtils.isOnline()) {
      function;
    }
  }

  static oneTimeSnackBar(
    String? message, {
    int time = 2,
    Color? bgColor,
    TextStyle? textStyle,
    BuildContext? context,
    bool showOnTop = false,
  }) {
    ScaffoldMessenger.of(Get.context!).clearSnackBars();

    ///To CLEAR PREVIOUS SNACK BARS
    return ScaffoldMessenger.of(context ?? Get.context!)
        // ScaffoldMessenger.of(context??Get.context!)
        .showSnackBar(
      SnackBar(
        /*action:SnackBarAction(label: "Ok",
        onPressed: (){
          SystemSettings.internalStorage();
        },
        ) ,*/

        behavior: showOnTop ? SnackBarBehavior.floating : null,
        backgroundColor: bgColor ?? ColorConst.appColor,
        content: Text(message!, style: textStyle),
        duration: Duration(seconds: time),
        margin: showOnTop
            ? EdgeInsets.only(
                bottom:
                    MediaQuery.of(context ?? Get.context!).size.height - 100,
                right: 20,
                left: 20)
            : null,
      ),
    );
  }

  static oneTimeSnackBarAction(String? message,
      {int time = 2,
      Color? bgColor,
      TextStyle? textStyle,
      BuildContext? context,
      bool showOnTop = false,
      String? actionText,
      Function()? action}) {
    ScaffoldMessenger.of(Get.context!).clearSnackBars();

    ///To CLEAR PREVIOUS SNACK BARS
    return ScaffoldMessenger.of(context ?? Get.context!).showSnackBar(
      SnackBar(
        action: SnackBarAction(
            textColor: Colors.white,
            label: actionText ??'N/A',
            onPressed: action ?? () {}),
        behavior: showOnTop ? SnackBarBehavior.floating : null,
        backgroundColor: bgColor ?? Color(0xff9EBF6D),
        content: Text(message!, style: textStyle),
        duration: Duration(seconds: time),
        margin: showOnTop
            ? EdgeInsets.only(
                bottom:
                    MediaQuery.of(context ?? Get.context!).size.height - 100,
                right: 20,
                left: 20)
            : null,
      ),
    );
  }

  static bool validationOfEmail(String emailPassed) {
    var email = emailPassed;
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    return emailValid;
  }

  static bool validationOfName(String namePassed) {
    var name = namePassed;
    bool nameValid = RegExp(r"^[a-zA-Z ][a-zA-Z ]+[a-zA-Z ]$").hasMatch(name);
    return nameValid;
  }

  static bool validationOfPIN(String passedPIN) {
    var pin = passedPIN;
    bool isValid = RegExp(r"^[1-9]{1}\d{2}\s?\d{3}$").hasMatch(pin);
    return isValid;
  }

  static bool validationOfPhone(String passedPhone) {
    var phone = passedPhone;
    bool isValid = RegExp(r"^[0-9]{10,10}").hasMatch(phone);
    return isValid;
  }

  ///Used to check internet connectivity with package => internet_connection_checker: ^0.0.1+3
  ///user this on every btn / or can be implemented on service before API call
  static Future<bool> isOnline() async {
    bool isOnline = await InternetConnectionChecker().hasConnection;
    if (isOnline) {
      return true;
    } else {
      oneTimeSnackBar('No network connection!', bgColor: ColorConst.green3D);
      return false;
    }
  }



  ///Dotted line
  static Widget generateDottedLine({Color? dashColor}) {
    return Row(
      children: List.generate(
          1000 ~/ 10,
          (index) => Expanded(
                child: Container(
                  color: index % 2 == 0
                      ? Colors.transparent
                      : dashColor ?? Colors.black,
                  height: 0.5,
                ),
              )),
    );
  }

  ///date format
  static String dateFormatterDMY(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String dateFormatterDMonthY(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  static String dateFormatterDMonthYHHmmAM(DateTime date) {
    return DateFormat('dd  MMM yyyy hh:mm a').format(date);
  }

  static void throwError(Object e) {
    print("Error caught----XXXXXX--XXXX--XXX-");
    throw e;
  }

  static getAccessToken() {
    // return "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjgyNTk2MjI4LCJpYXQiOjE2ODA4NjgyMjgsImp0aSI6IjE0ZTA4YTY3MDhhZDQwMjhhNzM0MzNmMDRlN2I4NmIyIiwidXNlcl9pZCI6IjIyMjIyMjIyMjIiLCJuYW1lIjoiICIsInJvbGUiOjV9.W7xF2bTogtFyNCFSD_srNtZK1Knq3Tq7pOniwSwKtvo";
    return GetStorage().read(Session.authToken) ?? '';
  }

  static getId() {
    return GetStorage().read(Session.id) ?? '';
  }

}

class AppUtilDynamicSize {
  late BuildContext context;
  double screenHeight = 0;
  double screenWidth = 0;
  double height10 = 0;
  double width10 = 0;
  double width1 = 0;
  double blockSizeVertical = 0;
  double blockSizeHorizontal = 0;
  double uiWidth = 375;
  double uiHeight = 812;
  double textScaleFactor = 0;
  double ratioWidth1 = 0;
  double ratioHeight1 = 0;
  AppUtilDynamicSize(this.context) {
    this.screenHeight = MediaQuery.of(context).size.height < 600
        ? 600
        : MediaQuery.of(context).size.height;
    this.screenWidth = MediaQuery.of(context).size.width;
    this.height10 = screenHeight / (812 / 10); //use this only
    this.width10 = screenWidth / (375 / 10); //use this only
    this.width1 = screenWidth / (375 / 1);
    // print("width: $screenWidth");
    // print("height: $screenHeight");
    this.blockSizeVertical = MediaQuery.of(context).size.height / 100;
    this.blockSizeHorizontal = MediaQuery.of(context).size.width / 100;
    this.textScaleFactor = screenWidth / uiWidth;
    // print("blockSizeHorizontal : $blockSizeHorizontal");
    this.ratioWidth1 = (1 / uiWidth) * screenWidth;
    this.ratioHeight1 = (1 / uiHeight) * screenHeight;
    // print("ratioWidth10: $ratioWidth1");
    // print("ratioHeight10: $ratioHeight1");
  }
}

///used to capitalize the strings
extension StringExtension on String {
  String capitalizeFirstL() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

///to format the money / amount us format
final amountFormatter = new NumberFormat(
  "##,##,##0",
  "en_US",
);

///to format the money / amount seperated with commas 1,20,000

final amountFormatterIn = new NumberFormat(
  "#,##,##0",
  "en_IN",
);

// final moneyFormat = NumberFormat.compactCurrency(decimalDigits: 1, symbol: '',locale:"en_IN");
final moneyFormat =
    NumberFormat.compactCurrency(decimalDigits: 0, symbol: '', locale: "en_US");
////
// controller.financeData.value.paid_amount==null?'':
// amountFormatter.format(controller.financeData.value.paid_amount),
