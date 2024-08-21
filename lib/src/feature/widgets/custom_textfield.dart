import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.title,
    this.controller,
    this.border,
    this.hintText,
    this.hintStyle,
    this.prefixIcon,
    this.textFieldStyle,
    this.inputType,
    this.isPassword = false,
    this.maxLines,
    this.onTap,
    this.isDisabled = false,
    this.readOnly = false,
    this.suffix,
    this.validator,
    this.labelText,
    this.labelStyle,
    this.labelColor,
    this.inputFormatters,
    this.autovalidateMode,
    this.contentPadding,
    this.minLines,
    this.focusNode,
  });
  final String? title;
  final Color? labelColor;
  final String? hintText;
  final TextEditingController? controller;
  final InputBorder? border;
  final TextStyle? hintStyle;
  final Widget? prefixIcon;
  final Widget? suffix;
  final int? minLines;
  final TextStyle? textFieldStyle;
  final TextInputType? inputType;
  final bool isPassword;
  final int? maxLines;
  final Function()? onTap;
  final bool isDisabled;
  final bool readOnly;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final String? labelText;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? labelStyle;
  final AutovalidateMode? autovalidateMode;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(9),
      onTap: onTap,
      child: TextFormField(
        focusNode: focusNode,
        autofocus: true,
        maxLines: maxLines ?? 1,
        style: textFieldStyle,
        minLines: minLines,
        controller: controller,
        readOnly: readOnly,
        validator: validator,
        keyboardType: inputType,
        autovalidateMode: autovalidateMode,
        obscureText: isPassword,
        obscuringCharacter: '*',
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          contentPadding: contentPadding,
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7.0),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 1.0,
            ),
          ),
          errorStyle: const TextStyle(fontSize: 0.01),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7.0),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 1.0,
            ),
          ),
          hintText: hintText,
          labelText: labelText,
          prefixIcon: prefixIcon,
          suffixIcon: suffix,
          labelStyle: GoogleFonts.inter(color: labelColor),
          hintStyle: hintStyle,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7.0),
            borderSide: const BorderSide(
                color: Color.fromRGBO(214, 214, 214, 1), width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7.0),
            borderSide: const BorderSide(
                color: Color.fromRGBO(214, 214, 214, 1), width: 2),
          ),
        ),
      ),
    );
  }
}
