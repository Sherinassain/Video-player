// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:my_app/core/constants/color.dart';
import 'package:my_app/core/constants/textstyle.dart';

///common button
// ignore: must_be_immutable
class CommonButton extends StatelessWidget {
  String title;
  var fontSize;
  var onPresss;
  var color;

  CommonButton(
      {required this.title, this.fontSize, required this.onPresss, this.color});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPresss,
      minWidth: MediaQuery.of(context).size.width,
      height: 50,
      elevation: 0,
      color: color ?? ColorConst.appColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        title,
        style: TextStyleClass.poppinsMedium(
          size: fontSize,
          color: Colors.white,
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class TextFormFieldCom extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final int? maxLine;
  final int? textLength;
  var isSelected;
  var onTap;
  var enable;
  var obscure;
  var prefix;
  var keyBoardType;
  var onChange;
  var suffix;
  bool readOnly;
  dynamic validator;
  GlobalKey<FormState>? formKey;

  TextFormFieldCom({
    this.hintText,
    this.controller,
    this.maxLine,
    this.textLength,
    this.readOnly = false,
    this.onTap,
    this.isSelected,
    this.enable,
    this.obscure,
    this.keyBoardType,
    this.onChange,
    this.prefix,
    this.suffix,
    this.validator,
    this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: TextFormField(
        validator: validator,
        readOnly: readOnly,
        onChanged: onChange ?? (val) {},
        controller: controller,
        enabled: enable ?? true,
        keyboardType: keyBoardType,
        cursorColor: ColorConst.black,
        obscureText: obscure ?? false,
        style: TextStyleClass.poppinsRegular(size: 18.0),
        maxLines: maxLine ?? 1,
        maxLength: textLength,
        /* cursorColor: ColorConst.greyDD,*/
        decoration: InputDecoration(
          // floatingLabelBehavior: FloatingLabelBehavior.,
          fillColor: Colors.white,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyleClass.poppinsRegular(
            color: ColorConst.grey83,
          ),
          suffixIcon: suffix ?? suffix,
          /* Icon(
                  Icons.edit,
                  color: ColorConst.appColor,
                ),*/
          prefixIcon: prefix ?? SizedBox.shrink(),
          /*Icon(
            Icons.email_outlined,
            color: ColorConst.appColor,
          ),*/
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: ColorConst.greyDD,
            ),
          ),
          disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: ColorConst.greyDD,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: ColorConst.greyDD,
            ),
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: ColorConst.greyDD,
            ),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: ColorConst.greyDD,
            ),
          ),
        ),
      ),
    );
  }
}
