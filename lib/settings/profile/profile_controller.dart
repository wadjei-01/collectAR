import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:navbar/firebase/firebaseDB.dart';

class ProfileController extends GetxController {
  TextEditingController textInputFormatter = TextEditingController();
  final currentUser = FireStoreDB.auth.currentUser;
}
