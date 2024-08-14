import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import 'navigation_service.dart';

abstract class ToasterService {
  static BuildContext? _context = NavigationService.navigatorKey.currentContext;

  ToasterService() {
    _context ??= NavigationService.navigatorKey.currentContext;
  }
  static error({
    String? title,
    String? message,
    bool hasIcon = true,
  }) =>
      Flushbar(
        borderRadius: BorderRadius.circular(5),
        margin: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
        title: title,
        message: message,
        backgroundColor: Colors.black38,
        titleColor: Theme.of(_context!).colorScheme.onError,
        messageColor: Theme.of(_context!).colorScheme.onError,
        icon: hasIcon
            ? Icon(
                Icons.error,
                color: Theme.of(_context!).colorScheme.onError,
              )
            : null,
        flushbarPosition: FlushbarPosition.BOTTOM,
        flushbarStyle: FlushbarStyle.FLOATING,
        duration: const Duration(seconds: 2),
      ).show(_context!);

  static success({
    String? title,
    String? message,
    bool hasIcon = true,
  }) =>
      Flushbar(
        borderRadius: BorderRadius.circular(5),
        margin: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
        title: title,
        message: message,
        backgroundColor: Colors.green.shade500,
        titleColor: Colors.white,
        messageColor: Colors.white,
        icon: hasIcon
            ? const Icon(
                Icons.check,
                color: Colors.white,
              )
            : null,
        flushbarPosition: FlushbarPosition.BOTTOM,
        flushbarStyle: FlushbarStyle.FLOATING,
        duration: const Duration(seconds: 2),
      ).show(_context!);

  static copied({
    String? title,
    String? message,
    bool hasIcon = true,
  }) =>
      Flushbar(
        borderRadius: BorderRadius.circular(5),
        margin: const EdgeInsets.only(left: 15, right: 15, bottom: 12),
        title: title,
        message: message,
        backgroundColor: Colors.black45,
        titleColor: Theme.of(_context!).colorScheme.onError,
        messageColor: Theme.of(_context!).colorScheme.onError,
        icon: hasIcon
            ? Icon(
                Icons.copy,
                color: Theme.of(_context!).colorScheme.onError,
              )
            : null,
        flushbarPosition: FlushbarPosition.BOTTOM,
        flushbarStyle: FlushbarStyle.FLOATING,
        duration: const Duration(seconds: 2),
      ).show(_context!);
}
