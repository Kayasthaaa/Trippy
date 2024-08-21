import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:trippy/src/constant/app_spaces.dart';
import 'package:trippy/src/feature/widgets/app_texts.dart';
import 'package:trippy/src/feature/widgets/containers.dart';
import 'package:trippy/src/feature/widgets/custom_textfield.dart';

class UpdateFileds extends StatelessWidget {
  final Widget? prefixIcon;
  final String texts;
  final Widget? suffix;
  final AutovalidateMode? autovalidateMode;
  final String? hintText;
  final String? labelText;
  final int? maxLines;
  final TextInputType? inputType;
  final TextEditingController? controller;
  final bool readOnly;
  final String? Function(String?)? validator;
  const UpdateFileds({
    super.key,
    this.prefixIcon,
    required this.texts,
    this.suffix,
    this.readOnly = false,
    this.controller,
    this.hintText,
    this.labelText,
    this.maxLines,
    this.inputType,
    this.validator,
    this.autovalidateMode,
  });

  @override
  Widget build(BuildContext context) {
    return Containers(
      margin: const EdgeInsets.symmetric(horizontal: 22.0),
      width: maxWidth(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Texts(
            texts: texts,
            fontSize: 8,
            fontWeight: FontWeight.w600,
            color: const Color.fromRGBO(183, 183, 183, 1),
          ),
          const SizedBox(height: 6),
          Container(
            constraints: const BoxConstraints(minHeight: 46),
            child: CustomTextField(
              autovalidateMode: autovalidateMode,
              validator: validator,
              controller: controller,
              readOnly: readOnly,
              inputType: inputType,
              prefixIcon: prefixIcon,
              hintText: hintText,
              labelText: labelText,
              minLines: 1,
              maxLines: maxLines,
              suffix: suffix,
              contentPadding: const EdgeInsets.only(top: 4, left: 8),
            ),
          ),
          const SizedBox(height: 10)
        ],
      ),
    );
  }
}
