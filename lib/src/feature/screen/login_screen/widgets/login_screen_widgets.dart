import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';
import 'package:trippy/src/constant/loader.dart';
import 'package:trippy/src/feature/screen/login_screen/cubit/login_cubit.dart';
import 'package:trippy/src/feature/screen/login_screen/cubit/login_screen_state.dart';
import 'package:trippy/src/feature/screen/register_screen/page/register_screen.dart';
import 'package:trippy/src/feature/widgets/app_btn.dart';
import 'package:trippy/src/feature/widgets/app_texts.dart';
import 'package:trippy/src/feature/widgets/new_field.dart';
import 'package:trippy/src/constant/validations.dart';
import 'package:trippy/src/feature/widgets/btn_text.dart';
import 'login_screen_operations.dart';

Widget buildTopImage(BoxConstraints constraints) {
  return Image.asset(
    'images/icon.png',
    height: constraints.maxHeight * 0.1,
    width: constraints.maxWidth * 0.3,
    fit: BoxFit.contain,
  );
}

Widget buildLoginText(BoxConstraints constraints) {
  return Texts(
    texts: 'Login',
    fontSize: constraints.maxWidth * 0.08,
    fontWeight: FontWeight.bold,
  );
}

Widget buildTextFields(
  BoxConstraints constraints,
  TextEditingController email,
  TextEditingController password,
  bool hidePassword,
  VoidCallback togglePassword,
) {
  return Column(
    children: [
      NewField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        mealController: email,
        validator: validateFields,
        hintText: 'Email',
        prefixIcon: const Icon(
          Icons.person_2_outlined,
        ),
      ),
      SizedBox(height: constraints.maxHeight * 0.02),
      NewField(
        validator: validateFields,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        mealController: password,
        onSuffixPressed: togglePassword,
        isPassword: hidePassword,
        iconSuffix:
            hidePassword ? Icons.visibility_off_sharp : Icons.visibility,
        prefixIcon: const Icon(Icons.lock_outline_rounded),
        hintText: 'Password',
      ),
    ],
  );
}

Widget buildLoginButton(
  BuildContext context,
  BoxConstraints constraints,
  GlobalKey<FormState> form,
  TextEditingController email,
  TextEditingController password,
) {
  return BlocConsumer<UserCubit, UserState>(
    listener: (context, state) =>
        handleLoginState(context, state, email, password),
    builder: (context, state) {
      return AppBtn(
        onTap: () =>
            handleLoginButtonPress(context, form, email, password, state),
        child: state is UserLoading ? loading() : btnText('Login'),
      );
    },
  );
}

Widget buildResButton(BoxConstraints constraints) {
  return AppBtn(
    onTap: () async {
      Get.to(() => const RegisterScreenPage());
    },
    child: btnText('Register'),
  );
}

Widget buildBottomImage(BoxConstraints constraints) {
  return Image.asset(
    'images/btm.png',
    height: constraints.maxHeight * 0.27,
    width: constraints.maxWidth * 0.48,
    fit: BoxFit.cover,
  );
}
