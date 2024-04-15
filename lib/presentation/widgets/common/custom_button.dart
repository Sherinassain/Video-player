import 'package:flutter/material.dart';
import 'package:my_app/core/constants/textstyle.dart';

class CustomButton extends StatelessWidget {
  final dynamic buttonHeight;
  final dynamic buttonWidth;
  final dynamic borderRadius;
  final double textSize;
  final dynamic onTap;
  final String buttonText;
  final FontWeight fontWeight;
  final dynamic buttonColor;
  final dynamic textColor;
  final dynamic border;
  const CustomButton({
    Key? key,
    this.buttonHeight,
    this.buttonWidth,
    required this.borderRadius,
    required this.buttonText,
    this.onTap,
    required this.textSize,
    required this.fontWeight,
    required this.buttonColor,
    required this.textColor,
    this.border,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: buttonHeight,
        width: buttonWidth,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: borderRadius,
          border: border,
        ),
        child: Center(
          child: Text(
            buttonText,
            style: TextStyleClass.poppinsMedium(
              color: textColor,
              size: textSize,
            ),
          ),
        ),
      ),
    );
  }
}
