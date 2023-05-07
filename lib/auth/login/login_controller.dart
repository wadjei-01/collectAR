import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:navbar/theme/globals.dart';
import 'package:navbar/models/user_model.dart' as userModel;

import 'package:navbar/main.dart';

import '../../box/boxes.dart';

class LoginController extends GetxController {
  RxBool isCorrect = true.obs;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? errorMessage = '';
  late userModel.User user;

  get emailController => _emailController;
  get passwordController => _passwordController;

  RxBool isEmailValid = true.obs;
  RxBool isPasswordValid = true.obs;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  fetchUserData() async {
    final firebaseUser = await FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get()
          .then((value) {
        user = userModel.User(
            email: value.data()!['email'],
            firstName: value.data()!['firstName'],
            lastName: value.data()!['lastName'],
            date: value.data()!['date'],
            phoneNo: value.data()!['phoneNo'],
            location: value.data()!['location'],
            userRole: value.data()!['userRole']);
      });
      final box = Boxes.getUser();
      box.put('user', user);
    }
  }

  login(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Center(
              child: CircularProgressIndicator(
            color: AppColors.primary,
          ));
        });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());
      errorMessage = '';
      isEmailValid(true);
      isPasswordValid(true);
      fetchUserData();
    } on FirebaseAuthException catch (e) {
      if (e.message == 'Given String is empty or null') {
        errorMessage = 'Please enter you credentials';
      } else if (e.message ==
          'There is no user record corresponding to this identifier. The user may have been deleted.') {
        isEmailValid(false);
        errorMessage = 'User does not exist in our database';
      } else if (e.message ==
          'The password is invalid or the user does not have a password.') {
        isEmailValid(true);
        isPasswordValid(false);

        errorMessage = 'Password is incorrect. Please try again';
      } else {
        errorMessage = e.message;
      }

      isCorrect(false);

      print(e.message);
      update();
    }

    // Future.delayed(Duration(seconds: 2), );s
    navigator!.pop();
    TextInput.finishAutofillContext();
    isCorrect(true);
  }
}
