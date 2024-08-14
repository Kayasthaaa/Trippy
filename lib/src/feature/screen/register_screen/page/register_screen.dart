// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';
import 'package:trippy/src/constant/app_spaces.dart';
import 'package:trippy/src/constant/loader.dart';
import 'package:trippy/src/constant/toaster.dart';
import 'package:trippy/src/constant/validations.dart';
import 'package:trippy/src/feature/screen/login_screen/page/login_form.dart';
import 'package:trippy/src/feature/screen/login_screen/widgets/login_screen_widgets.dart';
import 'package:trippy/src/feature/screen/register_screen/cubit/register_cubit.dart';
import 'package:trippy/src/feature/screen/register_screen/cubit/register_state.dart';
import 'package:trippy/src/feature/widgets/app_btn.dart';
import 'package:trippy/src/feature/widgets/app_texts.dart';
import 'package:trippy/src/feature/widgets/btn_text.dart';
import 'package:trippy/src/feature/widgets/containers.dart';
import 'package:trippy/src/feature/widgets/new_field.dart';

class RegisterScreenPage extends StatefulWidget {
  const RegisterScreenPage({super.key});

  @override
  _RegisterScreenPageState createState() => _RegisterScreenPageState();
}

class _RegisterScreenPageState extends State<RegisterScreenPage> {
  final form = GlobalKey<FormState>();
  final TextEditingController fname = TextEditingController();
  final TextEditingController uname = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController num = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController bio = TextEditingController();
  bool hidePassword = true;
  @override
  void dispose() {
    email.dispose();
    password.dispose();
    fname.dispose();
    uname.dispose();
    address.dispose();
    num.dispose();
    bio.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: constraints.maxWidth * 0.1),
                child: Form(
                  key: form,
                  child: Column(
                    children: [
                      SizedBox(height: constraints.maxHeight * 0.05),
                      SizedBox(
                          width: maxWidth(context),
                          child: buildTopImage(constraints)),
                      SizedBox(height: constraints.maxHeight * 0.03),
                      Texts(
                        texts: 'Register',
                        fontSize: constraints.maxWidth * 0.08,
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(height: constraints.maxHeight * 0.07),
                      NewField(
                        mealController: fname,
                        hintText: 'Full Name',
                        validator: validateNames,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        prefixIcon: const Icon(
                          Icons.person_2_outlined,
                        ),
                      ),
                      SizedBox(height: constraints.maxHeight * 0.02),
                      NewField(
                        mealController: uname,
                        hintText: 'Username',
                        validator: validateFields,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        prefixIcon: const Icon(
                          Icons.person_2_outlined,
                        ),
                      ),
                      SizedBox(height: constraints.maxHeight * 0.02),
                      NewField(
                        mealController: email,
                        hintText: 'Email',
                        validator: validateFields,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        prefixIcon: const Icon(
                          Icons.mail_outline_outlined,
                        ),
                      ),
                      SizedBox(height: constraints.maxHeight * 0.02),
                      NewField(
                        inputType: TextInputType.phone,
                        mealController: num,
                        hintText: 'Contact',
                        validator: validateNumber,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        prefixIcon: const Icon(
                          Icons.call_outlined,
                        ),
                      ),
                      SizedBox(height: constraints.maxHeight * 0.02),
                      NewField(
                        mealController: address,
                        hintText: 'Address',
                        validator: validateFields,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        prefixIcon: const Icon(
                          Icons.home_outlined,
                        ),
                      ),
                      SizedBox(height: constraints.maxHeight * 0.02),
                      NewField(
                        mealController: bio,
                        hintText: 'Bio',
                        validator: validateFields,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        prefixIcon: const Icon(
                          Icons.abc_outlined,
                        ),
                      ),
                      SizedBox(height: constraints.maxHeight * 0.02),
                      NewField(
                        mealController: password,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onSuffixPressed: () {
                          setState(() {
                            hidePassword = !hidePassword;
                          });
                        },
                        isPassword: hidePassword,
                        iconSuffix: hidePassword
                            ? Icons.visibility_off_sharp
                            : Icons.visibility,
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                        hintText: 'Password',
                      ),
                      SizedBox(height: constraints.maxHeight * 0.04),
                      Containers(
                        onTap: () {
                          Get.to(() => const LoginScreenPage());
                        },
                        width: maxWidth(context),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Texts(
                              texts: 'Already have a account?',
                              decoration: TextDecoration.underline,
                              underlineColor: Color.fromRGBO(0, 122, 255, 1),
                              color: Color.fromRGBO(0, 122, 255, 1),
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            Texts(
                              texts: 'Login',
                              decoration: TextDecoration.underline,
                              underlineColor: Color.fromRGBO(0, 122, 255, 1),
                              color: Color.fromRGBO(0, 122, 255, 1),
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: constraints.maxHeight * 0.05),
                      BlocConsumer<RegisterCubit, RegisterState>(
                        listener: (context, state) {
                          if (state is RegisterError) {
                            ToasterService.error(message: state.error);
                          } else if (state is RegisterSuccess) {
                            if (context.mounted) {
                              Get.off(() => const LoginScreenPage());
                            }
                            email.clear();
                            password.clear();
                            fname.clear();
                            uname.clear();
                            address.clear();
                            num.clear();
                            bio.clear();
                            ToasterService.success(
                                message: 'User registered successfully');
                          }
                        },
                        builder: (context, state) {
                          return AppBtn(
                            onTap: () async {
                              final isValid = form.currentState?.validate();
                              if (isValid == false) {
                                ToasterService.error(
                                    message: 'Fields cannot be empty');
                                return;
                              }
                              var connectivityResult =
                                  await (Connectivity().checkConnectivity());
                              if (connectivityResult ==
                                  ConnectivityResult.none) {
                                ToasterService.error(
                                    message: 'No Internet Connection');
                                return;
                              }
                              if (state is! RegisterLoading) {
                                FocusScope.of(context).unfocus();
                                if (context.mounted) {
                                  context.read<RegisterCubit>().registerUser(
                                      fname.text,
                                      password.text,
                                      uname.text,
                                      password.text,
                                      address.text,
                                      num.text,
                                      email.text,
                                      bio.text);
                                }
                              }
                            },
                            child: state is RegisterLoading
                                ? loading()
                                : btnText('Register'),
                          );
                        },
                      ),
                      SizedBox(height: constraints.maxHeight * 0.02),
                      buildBottomImage(constraints),
                      SizedBox(height: constraints.maxHeight * 0.02),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
