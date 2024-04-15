

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LatoFontStyle extends StatelessWidget {
  final String? text;
  final Color? color;
  final double fontSize;
  final FontWeight fontWeight;
  final TextDecoration textDecoration;
  final GestureTapCallback? onTap;
  final TextOverflow overflow;
  final double? letterSpacing;
  final TextAlign textAlign;
  final int? maxLine;

  const LatoFontStyle(
      {Key? key,
      this.text,
      this.color,
      this.onTap,
      this.letterSpacing,
      this.fontWeight = FontWeight.normal,
      this.fontSize = 16,
      this.textDecoration = TextDecoration.none,
      this.textAlign = TextAlign.left,
      this.overflow = TextOverflow.ellipsis,
        this.maxLine

      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Text(text??'',
            overflow: overflow,
            textAlign: textAlign,
            maxLines: maxLine??2,
            style: GoogleFonts.lato(
              color: color,
              fontSize: fontSize,
              fontWeight: fontWeight,
              letterSpacing: letterSpacing,
              decoration: textDecoration,
            )));
  }
}
