import 'package:flutter/material.dart';
import 'package:trippy/src/constant/app_spaces.dart';

class AppBtn extends StatelessWidget {
  final Color? textColor;
  final Widget? child;
  final void Function()? onTap;

  const AppBtn({
    super.key,
    this.onTap,
    this.textColor,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color.fromRGBO(56, 183, 255, 1),
              Color.fromRGBO(131, 165, 255, 1),
            ],
          ),
          borderRadius: BorderRadius.circular(7.0),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(7.0),
          splashColor: Colors.white.withOpacity(0.3),
          highlightColor: Colors.white.withOpacity(0.1),
          onTap: onTap,
          child: SizedBox(
            width: maxWidth(context),
            height: 48.0,
            child: Center(
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
