import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:navbar/auth/login/login_controller.dart';
import 'package:navbar/auth/signup.dart';
import 'package:navbar/theme/globals.dart';
import 'package:navbar/models/user_model.dart' as userModel;
import 'package:navbar/auth/register_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 80,
                ),
                SvgPicture.asset(
                  'assets/images/collectAR (logo).svg',
                  height: 70,
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Log in Now',
                      style:
                          TextStyle(fontFamily: 'Gotham Black', fontSize: 20)),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text('Please login to use our app'),
                const SizedBox(height: 50),
                GetBuilder<LoginController>(builder: (controller) {
                  return EmailWidget(
                    textController: controller.emailController,
                    textHint: 'Email',
                    isObscured: false,
                    isEmail: true,
                    isValid: controller.isEmailValid.value,
                  );
                }),
                const SizedBox(
                  height: 10,
                ),
                GetBuilder<LoginController>(builder: (controller) {
                  return PasswordWidget(
                    textHint: 'Password',
                    textController: controller.passwordController,
                    isObscured: true,
                    isValid: controller.isPasswordValid.value,
                  );
                }),
                const SizedBox(
                  height: 10,
                ),
                GetBuilder<LoginController>(builder: (controller) {
                  return SizedBox(
                    height: controller.errorMessage!.isNotEmpty ? 30 : 0,
                    width: 250,
                    child: Center(
                      child: Text(
                        controller.errorMessage ?? '',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  );
                }),
                Padding(
                  padding: const EdgeInsets.only(right: 45),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 300,
                  height: 30,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: GestureDetector(
                    onTap: () => controller.login(context),
                    child: Container(
                      decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        child: Text(
                          'LOGIN',
                          style: TextStyle(
                              color: AppColors.secondary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      )),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member?',
                      style: TextStyle(color: AppColors.secondary),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SignUp()));
                      },
                      child: Text(
                        '  Register here',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppColors.primary,
                            fontFamily: 'Montserrat-SemiBold',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ));
  }
}

class EmailWidget extends StatelessWidget {
  const EmailWidget({
    required this.textHint,
    required this.textController,
    required this.isObscured,
    required this.isEmail,
    required this.isValid,
  });

  final TextEditingController textController;
  final String textHint;
  final bool isObscured;
  final bool isEmail;
  final bool isValid;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        controller: textController,
        cursorColor: AppColors.primary,
        autofillHints: [AutofillHints.email],
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: emailValidator,
        decoration: InputDecoration(
          prefixIcon: Icon(Ionicons.person),
          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          prefixIconColor: AppColors.secondary,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: isValid == false ? Colors.red : AppColors.background,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.primary,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(10)),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: isValid == false ? Colors.red : AppColors.primary,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          hintText: textHint,
          border: InputBorder.none,
        ),
      ),
    );
  }

  String? emailValidator(String? formEmail) {
    if (formEmail == null || formEmail.isEmpty) {
      return 'Email address is empty';
    }

    String format = r'\w+@\w+\.\w+';
    RegExp regExp = RegExp(format);

    if (!regExp.hasMatch(formEmail)) {
      return 'Invalid Email format';
    }

    return null;
  }
}

class PasswordWidget extends StatelessWidget {
  const PasswordWidget({
    Key? key,
    required this.textHint,
    required this.textController,
    required this.isObscured,
    required this.isValid,
  }) : super(key: key);

  final String textHint;
  final TextEditingController textController;
  final bool isObscured;
  final bool isValid;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: TextFormField(
        keyboardType: TextInputType.text,
        obscureText: isObscured,
        cursorColor: AppColors.primary,
        controller: textController,
        autofillHints: [AutofillHints.password],
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => passwordValidator(value),
        decoration: InputDecoration(
          prefixIcon: Icon(Ionicons.lock_closed),
          prefixIconColor: AppColors.secondary,
          focusColor: AppColors.primary,
          focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.primary,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(10)),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: isValid == false ? Colors.red : AppColors.background,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: isValid == false ? Colors.red : AppColors.primary,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          hintText: textHint,
          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          border: InputBorder.none,
        ),
      ),
    );
  }

  String? passwordValidator(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is empty';
    }

    if (password.length < 8) {
      return 'Password should be at least 8 characters';
    }

    return null;
  }
}
