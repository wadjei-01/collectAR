import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datepicker_dropdown/datepicker_dropdown.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:navbar/auth/dropdown_plus_one.dart';
import 'package:navbar/auth/rootpage.dart';
import 'package:navbar/collections/collections_controller.dart';
import 'package:navbar/homepage/homepage.dart';

import 'package:navbar/models/user_model.dart' as usermodel;

import '../box/boxes.dart';
import '../theme/globals.dart';
import '../main.dart';

class SignUp extends StatefulWidget {
  SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

List<GlobalKey<FormState>> formKeys = [
  GlobalKey<FormState>(),
  GlobalKey<FormState>(),
  GlobalKey<FormState>(),
  GlobalKey<FormState>()
];

class _SignUpState extends State<SignUp> {
  int currentStep = 0;
  String? emailInUse;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _locationController = TextEditingController();
  String dateOfBirth = '';
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isError = false;

  Future signUp() async {
    //user authentication
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
      isError = false;
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());

      addUserDetails(_firstNameController.text.trim(),
          _lastNameController.text.trim(), _emailController.text.trim());
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    } catch (signUpError) {
      print('object');

      setState(() {
        currentStep == 0;
        isError = true;
      });
      emailInUse == 'Email is already in use';
      print('fuckk');

      navigatorKey.currentState!.pop();
    }

    //user details
  }

  Future addUserDetails(String firstName, String lastName, String email) async {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    //print(firebaseUser!.uid);

    final docUser =
        FirebaseFirestore.instance.collection('users').doc(firebaseUser!.uid);

    dateOfBirth = '$day $month $year';

    final user = usermodel.User(
        id: docUser.id,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNo: _phoneNumberController.text.trim(),
        location: _locationController.text.trim(),
        date: dateOfBirth.trim(),
        userRole: 'Customer');

    Box box = Boxes.getUser();

    box.put('user', user);

    final json = user.toJson();

    await docUser.set(json);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  uploadImage() async {
    final profile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 72);
  }

  final reference = FirebaseStorage.instance.ref().child('profilepic.jpg');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          toolbarHeight: 100,
          title: Column(children: [
            Image.asset(
              'assets/images/logo.png',
              height: 50,
            ),
            const SizedBox(height: 10),
            const Text('REGISTER',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat-SemiBold',
                    fontSize: 20)),
          ]),
          elevation: 0,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              color: Colors.black,
              onPressed: () => Navigator.pop(context)),
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: Theme(
          data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                  primary: AppColors.secondary,
                  onPrimary: Colors.white,
                  onPrimaryContainer: AppColors.secondary)),
          child: Stepper(
              controlsBuilder: (context, details) {
                return Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (currentStep != 0)
                        Expanded(
                            child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              fixedSize: const Size(10, 50), elevation: 0),
                          onPressed: details.onStepCancel,
                          child: const Text('BACK',
                              style:
                                  TextStyle(fontFamily: 'MontSerrat-SemiBold')),
                        )),
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(
                          child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(10, 50), elevation: 0),
                        onPressed: details.onStepContinue,
                        child: const Text(
                          'CONTINUE',
                          style: TextStyle(fontFamily: 'MontSerrat-SemiBold'),
                        ),
                      )),
                    ],
                  ),
                );
              },
              elevation: 0,
              type: StepperType.horizontal,
              steps: getSteps(),
              onStepTapped: (value) => setState(() {
                    currentStep = value;
                  }),
              currentStep: currentStep,
              onStepContinue: () async {
                final isLastStep = (currentStep == getSteps().length - 1);

                if (formKeys[currentStep].currentState!.validate()) {
                  isPadded = false;
                  if (isLastStep) {
                    signUp();

                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => RootPage()));
                  } else {
                    print('Done');
                    setState(() => currentStep += 1);
                  }
                } else {
                  setState(() {
                    isPadded = true;
                  });
                }
              },
              onStepCancel: currentStep == 0
                  ? null
                  : () => setState(() {
                        currentStep--;
                      })),
        ));
  }

  List<Step> getSteps() => [
        Step(
            state: currentStep > 0 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 0,
            title: const Text('Step 1'),
            content: Form(
              key: formKeys[0],
              child: AccountDetails(
                emailController: _emailController,
                passwordController: _passwordController,
                confirmpasswordController: _confirmPasswordController,
                isError: isError,
              ),
            )),
        Step(
            state: currentStep > 1 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 1,
            title: const Text('Step 2'),
            content: Form(
              key: formKeys[1],
              child: PersonalInfo(
                firstNameController: _firstNameController,
                lastNameController: _lastNameController,
                phoneNumberController: _phoneNumberController,
                locationController: _locationController,
              ),
            )),
        Step(
            state: currentStep > 2 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 2,
            title: const Text('Step 3'),
            content: Form(
                key: formKeys[2],
                child: DropDownPlusOne(
                  value: isError,
                )))
      ];
}

late String day;
late String month;
late String year;

class AccountDetails extends StatelessWidget {
  AccountDetails(
      {Key? key,
      required this.emailController,
      required this.passwordController,
      required this.confirmpasswordController,
      required this.isError})
      : super(key: key);

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmpasswordController;
  bool isError;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            obscureText: false,
            controller: emailController,
            validator: (email) => emailValidator(email, isError),
            decoration: Globals.personalDecoration('Email'),
          ),
          const SizedBox(height: 20),
          TextFormField(
            keyboardType: TextInputType.text,
            obscureText: true,
            controller: passwordController,
            validator: ((value) => passwordValidator(value)),
            decoration: Globals.personalDecoration('Password'),
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            keyboardType: TextInputType.text,
            obscureText: true,
            controller: confirmpasswordController,
            validator: (password) => passwordValidator(password),
            decoration: Globals.personalDecoration('Confirm Password'),
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    ));
  }

  String? emailValidator(String? formEmail, bool isError) {
    if (formEmail == null || formEmail.isEmpty) {
      return 'Email address is empty';
    }

    String format = r'\w+@\w+\.\w+';
    RegExp regExp = RegExp(format);

    if (!regExp.hasMatch(formEmail)) {
      return 'Invalid Email format';
    }
    if (isError) {
      return 'Email already exists in Direa';
    }

    return null;
  }

  String? passwordValidator(String? formPassword) {
    if (formPassword == null || formPassword.isEmpty) {
      return 'Password address is empty';
    }

    // String pattern =
    //     r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    // RegExp regex = RegExp(pattern);
    if (formPassword.length < 8) {
      return '''
      Password must be at least 8 characters,
      ''';
    }

    if (passwordController.text.trim() !=
        confirmpasswordController.text.trim()) {
      return 'Password is different';
    }

    return null;
  }
}

bool isPadded = false;

class PersonalInfo extends StatefulWidget {
  PersonalInfo(
      {Key? key,
      required this.firstNameController,
      required this.lastNameController,
      required this.phoneNumberController,
      required this.locationController})
      : super(key: key);
  TextEditingController firstNameController;
  TextEditingController lastNameController;
  TextEditingController phoneNumberController;
  TextEditingController locationController;

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  DateTime? data;

  @override
  void initState() {
    isPadded = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                color: const Color.fromARGB(255, 230, 230, 230)),
            child: const Icon(
              Icons.person,
              color: Colors.white,
              size: 80,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            keyboardType: TextInputType.text,
            obscureText: false,
            controller: widget.firstNameController,
            // autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) => stringValidator(value, "First Name"),
            decoration: Globals.personalDecoration('First Name'),
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            keyboardType: TextInputType.text,
            obscureText: false,
            controller: widget.lastNameController,
            // autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) => stringValidator(value, "Last Name"),
            decoration: Globals.personalDecoration('Last Name'),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 50,
            child: DropdownDatePicker(
              monthFlex: 1,
              dayFlex: 1,
              yearFlex: 1,

              inputDecoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 213, 213, 213),
                      width: 1.0,
                    ),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))), // optional
              isDropdownHideUnderline: true, // optional
              isFormValidator: true, // optional
              startYear: 1950, // optional
              endYear: 2010, // optional
              width: 5, // optional
              // selectedDay: 14, // optional
              // selectedMonth: 07, // optional
              // selectedYear: 2022, // optional
              onChangedDay: (value) {
                if (value != null) {
                  day = value;
                }
              },
              onChangedMonth: (value) {
                if (value != null) {
                  month = value;
                }
              },
              onChangedYear: (value) {
                if (value != null) {
                  year = value;
                }
              },
              //boxDecoration: BoxDecoration(
              // border: Border.all(color: Colors.grey, width: 1.0)), // optional
              // showDay: false,// optional
              // dayFlex: 2,// optional
              // locale: "zh_CN",// optional
              hintDay: 'Day', // optional
              hintMonth: 'Month', // optional
              hintYear: 'Year', // optional
              hintTextStyle:
                  const TextStyle(color: Colors.grey, fontSize: 13), // optional
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: isPadded ? 20 : 0),
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: 90,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromARGB(255, 238, 238, 238)),
                  child: const Text(
                    '+233',
                    style: const TextStyle(fontFamily: 'Montserrat-SemiBold'),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  obscureText: false,
                  controller: widget.phoneNumberController,
                  validator: (value) => stringValidator(value, 'Phone Number'),
                  decoration: Globals.personalDecoration('Phone Number'),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            keyboardType: TextInputType.text,
            obscureText: false,
            controller: widget.locationController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) => stringValidator(value, 'Location'),
            decoration: Globals.personalDecoration('Location'),
          ),
          SizedBox(
            height: 20,
          )
        ]),
      ),
    );
  }

  String? stringValidator(String? formString, String type) {
    if (formString == null || formString.isEmpty) {
      return 'Enter your $type';
    }

    return null;
  }
}
