// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:trippy/src/constant/app_spaces.dart';
import 'package:trippy/src/feature/screen/login_screen/cubit/login_cubit.dart';
import 'package:trippy/src/feature/screen/login_screen/page/login_form.dart';
import 'package:trippy/src/feature/widgets/app_texts.dart';
import 'package:trippy/src/feature/widgets/containers.dart';

class LogoutBtn extends StatelessWidget {
  const LogoutBtn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Containers(
          margin: const EdgeInsets.symmetric(horizontal: 22),
          decoration: BoxDecoration(
              color: Colors.red, borderRadius: BorderRadius.circular(6)),
          width: maxWidth(context),
          height: 50,
          onTap: () {
            context.read<UserCubit>().logout();
            Get.offAll(() => const LoginScreenPage());
          },
          child: const Center(
              child: Texts(
            texts: 'logout',
            color: Colors.white,
          )),
        ),
      ),
    );
  }
}
