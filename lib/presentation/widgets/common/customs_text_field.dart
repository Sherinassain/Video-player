import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class CustomsTextField extends StatefulWidget {
  const CustomsTextField({
    Key? key,
    this.formKey,
    required this.width10,
    this.height,
    required this.height10,
    required this.labelText,
    this.hintText,
    this.controller,
    this.maxLines,
    this.textStyle,
    this.labelStyle,
    this.hintTextStyle,
    this.bgColor,
    this.onChanged,
    this.onTapOutside,
    this.onTap,
    this.focusNode,
    this.validator,
    this.borderWidth = 1,
    this.borderColor,
    this.isPassword = false,
    this.readOnly = false,
    this.borderRadius,
    this.inputFormatters,
    this.keyboardType,
    this.textCapitalization,
    this.suffix,
    this.isValidData = true,
    this.errorMessage,
  }) : super(key: key);

  final double width10;
  final double? borderRadius;
  final double? height;
  final Color? borderColor;
  final double borderWidth;
  final double height10;
  final String? hintText;
  final String labelText;
  final TextEditingController? controller;
  final int? maxLines;
  final TextStyle? textStyle;
  final TextStyle? labelStyle;
  final TextStyle? hintTextStyle;
  final Color? bgColor;
  final Function(String)? onChanged;
  final Function()? onTap;
  final void Function(PointerDownEvent)? onTapOutside;
  final FocusNode? focusNode;
  final Function(String?)? validator;
  final bool isPassword;
  final bool readOnly;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final TextCapitalization? textCapitalization;
  final Widget? suffix;
   final GlobalKey? formKey;
   final bool isValidData;
   final String? errorMessage;

  

  @override
  State<CustomsTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomsTextField> {
  bool isVisible = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
     
        Container(
          margin: EdgeInsets.only(top: widget.height10 * 0.8),
          padding: EdgeInsets.only(
              left: widget.width10 * 1.7,
              right: widget.width10 * 0.5,
              bottom: widget.width10 * 0.5),
          height: widget.height ?? 4.7 * widget.height10,
          decoration: BoxDecoration(
              
              borderRadius:
                  BorderRadius.all(Radius.circular(widget.borderRadius ?? 1)),
              color: widget.bgColor),
          child: Center(
            child: Row(
              children: [
                Expanded(
                  child: Form(
                    key: widget.formKey,
                    child: TextFormField(
                      readOnly: widget.readOnly,
                      textCapitalization:
                          widget.textCapitalization ?? TextCapitalization.none,
                      keyboardType: widget.keyboardType,
                      obscureText: widget.isPassword ? isVisible : false,
                      onTap: widget.onTap,
                      focusNode: widget.focusNode,
                      onChanged: widget.onChanged,
                      onTapOutside: widget.onTapOutside,
                     
                      controller: widget.controller,
                      scrollPadding: EdgeInsets.zero,
                      maxLines: widget.maxLines ?? 1,
                      inputFormatters: widget.inputFormatters,
                      decoration: InputDecoration.collapsed(
                          hintText: widget.hintText ?? '',
                          hintStyle: widget.hintTextStyle ??
                              const TextStyle(fontSize: 14)),
                      validator: (value) {
                        widget.validator!(value);
                       // return widget.validator!(value);
                        // setState(() {
                          
                        // });
                      },
                    ),
                  ),
                ),
                widget.isPassword
                    ? Padding(
                        padding: EdgeInsets.only(right: widget.width10 / 2),
                        child: InkWell(
                            onTap: () {
                              isVisible == true
                                  ? isVisible = false
                                  : isVisible = true;
                              setState(() {});
                            },
                            child: Icon(
                              !isVisible
                                  ? Icons.remove_red_eye_outlined
                                  : Icons.visibility_off_outlined,
                              color: const Color(0xff9EA3AE),
                            )))
                    : widget.suffix?? const SizedBox(),
              ],
            ),
          ),
        ),
     
      ],
    );
  }
}
