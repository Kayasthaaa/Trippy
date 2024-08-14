// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trippy/bottom_navigation.dart';
import 'package:trippy/src/feature/screen/login_screen/page/login_form.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();
    _navigateToNextPage();
  }

  _navigateToNextPage() async {
    await Future.delayed(const Duration(seconds: 2), () {});

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('user_token') ?? '';

    if (token.isNotEmpty) {
      Get.offAll(() => const BottomNavigationScreen());
    } else {
      Get.offAll(() => const LoginScreenPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 200,
              width: 200,
              child: Lottie.asset('images/lottie.json'),
            ),
          ],
        ),
      ),
    );
  }
}
