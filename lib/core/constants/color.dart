import 'package:flutter/material.dart';

class ColorConst {
  static Color black = Colors.black;
  static Color white = Colors.white;
  static Color red = Colors.red;
  static Color appColor = Color(0xffE34950);
  static Color black26 = Color(0xff262626);
  static Color black1F = Color(0xff1F2B2E);
  static Color greyDD = Color(0xffDDDDDD);

  static Color greyCC =const Color(0xffCCCCCC);
  static Color greyBB = const Color(0xffBBBBBB);
  static Color grey83 =const Color(0xff838383);
 static Color redButtonColor = fromHex('#EB2427');
  static Color green3D =const  Color(0xff3DBA42);

    static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
