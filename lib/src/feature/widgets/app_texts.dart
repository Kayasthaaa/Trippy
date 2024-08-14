import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Texts extends StatelessWidget {
  const Texts({
    super.key,
    required this.texts,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.textAlign,
    this.fontStyle,
    this.decoration,
    this.underlineColor, // New parameter for underline color
    this.onTap,
    this.overflow,
    this.maxLines,
    this.height,
  });

  final String texts;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final int? maxLines;
  final FontStyle? fontStyle;
  final double? height;
  final void Function()? onTap;
  final TextDecoration? decoration;
  final Color? underlineColor; // New parameter for underline color

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AutoSizeText(
        texts,
        overflow: overflow ?? TextOverflow.ellipsis,
        textAlign: textAlign,
        maxLines: maxLines,
        style: GoogleFonts.poppins(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          decoration: decoration,
          decorationColor: underlineColor, // Set the underline color
          fontStyle: fontStyle,
          textStyle: TextStyle(
            height: height,
          ),
        ),
      ),
    );
  }
}
