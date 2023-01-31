import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_svg/svg.dart';
import 'package:navbar/auth/authpage.dart';
import 'package:navbar/auth/signup.dart';
import 'package:navbar/otherpages/globals.dart';
import 'package:navbar/models/user_model.dart' as userModel;
import '../main.dart';
import 'register_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isCorrect = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  String? errorMessage = '';
  late userModel.User user;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  fetchData() async {
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
            location: value.data()!['location']);
      });
      box.put('user', user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: key,
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
                        style: TextStyle(
                            fontFamily: 'Gotham Black', fontSize: 20)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text('Please login to use our app'),
                  const SizedBox(height: 50),
                  EmailWidget(
                    textController: _emailController,
                    textHint: 'Email',
                    isObscured: false,
                    isEmail: true,
                    isCorrect: isCorrect,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  PasswordWidget(
                    textHint: 'Password',
                    textController: _passwordController,
                    isObscured: true,
                    isEmail: false,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: errorMessage!.isNotEmpty ? 30 : 0,
                    width: 250,
                    child: Center(
                      child: Text(
                        errorMessage ?? '',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 10),
                    child: GestureDetector(
                      onTap: () async {
                        if (key.currentState!.validate()) {
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
                            await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: _emailController.text.trim(),
                                    password: _passwordController.text.trim());
                            errorMessage = '';
                            fetchData();
                          } on FirebaseAuthException catch (e) {
                            print('Problem');
                            errorMessage = e.message;

                            setState(() {
                              isCorrect = false;
                              print(isCorrect);
                            });
                          }
                          setState(() {
                            isCorrect = true;
                          });

                          navigatorKey.currentState!
                              .popUntil((route) => route.isFirst);
                        }
                      },
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUp()));
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
          ),
        ));
  }
}

class EmailWidget extends StatelessWidget {
  EmailWidget(
      {Key? key,
      required this.textHint,
      required TextEditingController textController,
      required this.isObscured,
      required this.isEmail,
      required this.isCorrect})
      : _textController = textController,
        super(key: key);

  final TextEditingController _textController;
  String textHint;
  bool isObscured;
  bool isEmail;
  bool isCorrect;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        controller: _textController,
        // autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => emailValidator(value),
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: Color.fromARGB(255, 213, 213, 213)),
              borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary, width: 2),
              borderRadius: BorderRadius.circular(10)),
          hintText: textHint,
          contentPadding: const EdgeInsets.only(left: 20),
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
  PasswordWidget(
      {Key? key,
      required this.textHint,
      required TextEditingController textController,
      required this.isObscured,
      required this.isEmail})
      : _textController = textController,
        super(key: key);

  final TextEditingController _textController;
  String textHint;
  bool isObscured;
  bool isEmail;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: TextFormField(
        keyboardType: TextInputType.text,
        obscureText: true,
        controller: _textController,
        validator: (value) => passwordValidator(value),
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: Color.fromARGB(255, 213, 213, 213)),
              borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary, width: 2),
              borderRadius: BorderRadius.circular(10)),
          hintText: textHint,
          contentPadding: const EdgeInsets.only(left: 20),
          border: InputBorder.none,
        ),
      ),
    );
  }

  String? passwordValidator(String? formPassword) {
    if (formPassword == null || formPassword.isEmpty) {
      return 'Password address is empty';
    }

    // String pattern =
    //     r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    // RegExp regex = RegExp(pattern);
    // if (!regex.hasMatch(formPassword)) {
    //   return '''
    //   Password must be at least 8 characters,
    //   include an uppercase letter, number and symbol.
    //   ''';
    // }

    return null;
  }
}
