import 'dart:ui';

import 'package:admin/constants/constants.dart';
import 'package:admin/screens/auth/widgets/email_textfield.dart';
import 'package:admin/screens/auth/widgets/password_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../controllers/login_controller.dart';
import '../../models/login_model.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return Scaffold(
      body: Stack(
        children: [

          /// 🔥 BACKGROUND IMAGE
          SizedBox.expand(
            child: Image.asset(
              "assets/images/bg.png", // 👈 your background image
              fit: BoxFit.cover,
            ),
          ),

          /// 🔥 DARK OVERLAY (for readability)
          Container(
            color: Colors.black.withOpacity(0.6),
          ),

          /// 🔥 OPTIONAL BLUR EFFECT (premium UI)
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: Colors.black.withOpacity(0.2),
            ),
          ),

          /// 🔥 MAIN CONTENT
          ListView(
            padding: EdgeInsets.zero,
            children: [
              const SizedBox(height: 30),

              SizedBox(
                height: 500,
                child: Lottie.asset("assets/images/robo.json"),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [

                    /// EMAIL FIELD
                    EmailTextfield(
                      hintText: "Enter your email",
                      prefixIcon: const Icon(
                        CupertinoIcons.mail,
                        size: 22,
                        color: textGrey,
                      ),
                      controller: _emailController,
                    ),

                    const SizedBox(height: 25),

                    /// PASSWORD FIELD
                    PasswordTextfield(
                      controller: _passwordController,
                    ),

                    const SizedBox(height: 25),

                    /// LOGIN BUTTON
                    SizedBox(
                      width: 300,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_emailController.text.isNotEmpty &&
                              _passwordController.text.length >= 6) {

                            LoginModel model = LoginModel(
                              email: _emailController.text,
                              password: _passwordController.text,
                            );

                            String data = loginModelToJson(model);

                            controller.loginFunction(data);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryPurple,
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "LOGIN",
                          style: TextStyle(
                            color: textWhite,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}