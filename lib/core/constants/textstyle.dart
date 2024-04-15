import 'package:flutter/material.dart';
import 'package:my_app/core/constants/color.dart';

class TextStyleClass {
  ///poppins Regular
  static poppinsRegular({var color, var size}) {
    return TextStyle(
      color: color ?? ColorConst.black,
      fontSize: size ?? 14.0,
      fontFamily: "Poppins",
      fontWeight: FontWeight.w400,
    );
  }

  ///poppins medium
  static poppinsMedium({var color, var size}) {
    return TextStyle(
      color: color ?? ColorConst.black,
      fontSize: size ?? 14.0,
      fontFamily: "Poppins",
      fontWeight: FontWeight.w500,
    );
  }

  ///poppins semiBold
  static poppinsSemiBold({var color, var size}) {
    return TextStyle(
      color: color ?? ColorConst.black,
      fontSize: size ?? 14.0,
      fontFamily: "Poppins",
      fontWeight: FontWeight.w600,
    );
  }

  /// poppins Bold
  static poppinsBold({var color, var size}) {
    return TextStyle(
      color: color ?? ColorConst.black,
      fontSize: size ?? 14.0,
      fontFamily: "Poppins",
      fontWeight: FontWeight.w700,
    );
  }
}
