// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/route_manager.dart';
import 'package:trippy/bottom_navigation.dart';
import 'package:trippy/src/constant/toaster.dart';
import 'package:trippy/src/feature/screen/login_screen/cubit/login_cubit.dart';
import 'package:trippy/src/feature/screen/login_screen/cubit/login_screen_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void handleLoginState(
  BuildContext context,
  UserState state,
  TextEditingController email,
  TextEditingController password,
) {
  if (state is UserError) {
    ToasterService.error(message: state.error);
  } else if (state is UserSuccess) {
    if (context.mounted) {
      Get.offAll(() => const BottomNavigationScreen());
    }
    email.clear();
    password.clear();
    ToasterService.success(message: 'Logged In successfully');
  }
}

Future<void> handleLoginButtonPress(
  BuildContext context,
  GlobalKey<FormState> form,
  TextEditingController email,
  TextEditingController password,
  UserState state,
) async {
  final isValid = form.currentState?.validate();
  if (isValid == false) {
    ToasterService.error(message: 'Fields cannot be empty');
    return;
  }

  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    ToasterService.error(message: 'No Internet Connection');
    return;
  }

  if (state is! UserLoading) {
    FocusScope.of(context).unfocus();
    if (context.mounted) {
      context.read<UserCubit>().loginUser(email.text, password.text);
    }
  }
}
