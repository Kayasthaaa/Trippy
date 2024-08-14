// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:trippy/src/feature/widgets/app_texts.dart';

class ConnectivityWrapper extends StatefulWidget {
  final Widget child;

  const ConnectivityWrapper({required this.child});

  @override
  _ConnectivityWrapperState createState() => _ConnectivityWrapperState();
}

class _ConnectivityWrapperState extends State<ConnectivityWrapper> {
  ConnectivityResult? _connectionStatus;

  @override
  void initState() {
    super.initState();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        _connectionStatus = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_connectionStatus == ConnectivityResult.none) {
      //? -----> Show snack bar for no internet connection
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              margin: const EdgeInsets.only(left: 15, right: 15, bottom: 12),
              backgroundColor: Colors.black45,
              content: const Row(
                children: [
                  Icon(
                    Icons.wifi_off,
                    color: Colors.white,
                    size: 20,
                  ),
                  SizedBox(
                    width: 7,
                  ),
                  Texts(
                    texts: 'No internet connection',
                    color: Colors.white,
                  ),
                ],
              ),
              duration: const Duration(days: 2),
            ),
          );
        },
      );
    } else {
      //? -----> Show snack bar when internet connection is restored
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              margin: const EdgeInsets.only(left: 15, right: 15, bottom: 12),
              backgroundColor: Colors.green.shade500,
              content: const Row(
                children: [
                  Icon(
                    Icons.wifi,
                    color: Colors.white,
                    size: 20,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Texts(
                    texts: 'Internet connection restored',
                    color: Colors.white,
                  ),
                ],
              ),
              duration: const Duration(seconds: 2),
            ),
          );
          //? -----> Close all snackbars
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      );
    }

    return widget.child;
  }
}
