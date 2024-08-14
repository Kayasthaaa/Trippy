// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class NewField extends StatefulWidget {
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final AutovalidateMode? autovalidateMode;
  final String? hintText;
  final TextEditingController? mealController;
  final TextStyle? hintStyle;
  final Widget? prefixIcon;
  final Widget? suffix;
  final TextStyle? textFieldStyle;
  final TextInputType? inputType;
  final bool isPassword;
  final int? maxLines;
  final Function()? onTap;
  final bool isDisabled;
  final bool readOnly;
  final IconData? iconSuffix;
  final String? Function(String?)? validator;
  final String? labelText;
  final void Function()? onSuffixPressed;
  final TextStyle? labelStyle;
  final Color? iconColor;
  final double? iconSize;

  const NewField({
    super.key,
    this.hintText,
    this.mealController,
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
    this.onChanged,
    this.onSaved,
    this.autovalidateMode,
    this.onSuffixPressed,
    this.iconSuffix,
    this.iconColor,
    this.iconSize,
  });

  @override
  _NewFieldState createState() => _NewFieldState();
}

class _NewFieldState extends State<NewField> {
  late FocusNode _focusNode;
  late TextEditingController _controller;
  bool _isIconClicked = false;
  bool _hasError = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _controller = widget.mealController ?? TextEditingController();

    _focusNode.addListener(() {
      if (mounted) {
        setState(() {}); // Update UI based on focus change
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    if (widget.mealController == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _handleChange(String value) {
    if (widget.onChanged != null) {
      widget.onChanged!(value);
    }

    if (widget.validator != null) {
      final error = widget.validator!(value);
      if (error != _errorText || _hasError != (error != null)) {
        Future.microtask(() {
          if (mounted) {
            setState(() {
              _errorText = error;
              _hasError = error != null;
            });
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: false,
      maxLines: widget.maxLines ?? 1,
      style: const TextStyle(
        color: Color.fromRGBO(0, 122, 255, 1),
      ),
      onChanged: (value) {
        _handleChange(value);
        setState(() {}); // Trigger rebuild to update text color
      },
      onSaved: widget.onSaved,
      autovalidateMode: widget.autovalidateMode,
      controller: _controller,
      readOnly: widget.readOnly,
      validator: (value) {
        final error = widget.validator?.call(value);
        if (error != _errorText || _hasError != (error != null)) {
          Future.microtask(() {
            if (mounted) {
              setState(() {
                _errorText = error;
                _hasError = error != null;
              });
            }
          });
        }
        return error;
      },
      keyboardType: widget.inputType,
      obscureText: widget.isPassword,
      obscuringCharacter: '*',
      focusNode: _focusNode,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        hintText: widget.hintText,
        labelText: widget.labelText,
        prefixIcon: widget.prefixIcon != null
            ? Padding(
                padding: const EdgeInsets.only(left: 12, right: 8),
                child: Icon(
                  widget.prefixIcon is Icon
                      ? (widget.prefixIcon as Icon).icon
                      : Icons.help,
                  color: _focusNode.hasFocus
                      ? const Color.fromRGBO(0, 122, 255, 1)
                      : const Color.fromRGBO(164, 164, 164, 1),
                  size: widget.iconSize ?? 24,
                ),
              )
            : null,
        suffixIcon: widget.iconSuffix != null
            ? IconButton(
                icon: Icon(
                  widget.iconSuffix,
                  color: _isIconClicked
                      ? const Color.fromRGBO(0, 122, 255, 1)
                      : widget.iconColor,
                  size: widget.iconSize,
                ),
                onPressed: () {
                  setState(() {
                    _isIconClicked = !_isIconClicked;
                  });
                  if (widget.onSuffixPressed != null) {
                    widget.onSuffixPressed!();
                  }
                },
              )
            : null,
        labelStyle: widget.labelStyle,
        hintStyle: widget.hintStyle,
        alignLabelWithHint: true,
        isDense: true,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: _focusNode.hasFocus
                ? const Color.fromRGBO(0, 122, 255, 1)
                : const Color.fromRGBO(164, 164, 164, 1),
            width: 1,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color:
                _hasError ? Colors.red : const Color.fromRGBO(164, 164, 164, 1),
            width: 1,
          ),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
            width: 1.0,
          ),
        ),
        focusedErrorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
            width: 1.0,
          ),
        ),
      ),
    );
  }
}
