// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:trippy/src/feature/screen/login_screen/widgets/login_screen_widgets.dart';

class LoginScreenPage extends StatefulWidget {
  const LoginScreenPage({super.key});

  @override
  _LoginScreenPageState createState() => _LoginScreenPageState();
}

class _LoginScreenPageState extends State<LoginScreenPage> {
  final form = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool hidePassword = true;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: constraints.maxWidth * 0.1),
                  child: Form(
                    key: form,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            SizedBox(height: constraints.maxHeight * 0.05),
                            buildTopImage(constraints),
                            SizedBox(height: constraints.maxHeight * 0.03),
                            buildLoginText(constraints),
                            SizedBox(height: constraints.maxHeight * 0.07),
                            buildTextFields(
                                constraints, email, password, hidePassword, () {
                              setState(() {
                                hidePassword = !hidePassword;
                              });
                            }),
                            SizedBox(height: constraints.maxHeight * 0.08),
                            buildLoginButton(
                                context, constraints, form, email, password),
                            SizedBox(height: constraints.maxHeight * 0.02),
                            buildResButton(constraints),
                            SizedBox(height: constraints.maxHeight * 0.02),
                          ],
                        ),
                        buildBottomImage(constraints),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
