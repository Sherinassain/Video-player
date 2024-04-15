import 'package:flutter/material.dart';
import 'package:my_app/core/constants/color.dart';

class CommonProgressIndicator extends StatelessWidget {
  final dynamic indicatorColor;
  const CommonProgressIndicator({Key? key,this.indicatorColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      strokeWidth: 2,
      color: indicatorColor??ColorConst.appColor,
    );
  }
}
