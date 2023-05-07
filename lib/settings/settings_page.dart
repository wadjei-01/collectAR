import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:navbar/models/user_model.dart' as userModel;
import 'package:navbar/settings/profile/profile_view.dart';
import '../../box/boxes.dart';
import '../../main.dart';
import '../../theme/fonts.dart';
import '../../widgets.dart';
import '../theme/globals.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final user = FirebaseAuth.instance.currentUser!;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  userModel.User userDets = Boxes.getUser().get('user')!;
  String userName = '';

  @override
  void initState() {
    super.initState();
    // _getUserName();
  }

  List<String> profileInfo = ['Profile', 'Settings', 'About', 'Help'];

  List<IconData> profileIcon = [
    Icons.person_outline_rounded,
    Icons.settings_outlined,
    Icons.info_outline_rounded,
    Icons.help_outline
  ];
  @override
  Widget build(BuildContext context) {
    userName = "${userDets.firstName} ${userDets.lastName}";
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  child: Icon(
                    Icons.person,
                    color: AppColors.title,
                    size: 70,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Color.fromARGB(255, 223, 223, 223)),
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(userDets.location)
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              'Personal Information',
              style: TextStyle(
                  color: Colors.grey, fontFamily: 'Gotham Black', fontSize: 15),
            ),
            const SizedBox(
              height: 10,
            ),
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              separatorBuilder: (context, index) => const Divider(
                color: Color.fromARGB(255, 208, 208, 208),
              ),
              itemBuilder: (context, index) {
                return ListOfItems(
                  icon: profileIcon[index],
                  title: profileInfo[index],
                  onTap: () {
                    if (index == 0) {
                      Get.to(ProfilePage());
                    }
                  },
                );
              },
              itemCount: profileInfo.length,
            ),
            const SizedBox(
              height: 70,
            ),
            Center(
              child: button(
                  onTap: () {
                    final box = Boxes.getCart();
                    box.clear();
                    FirebaseAuth.instance.signOut();
                  },
                  height: 150.h,
                  widget: Text(
                    "Sign Out",
                    style: MediumHeaderStyle(
                        color: AppColors.secondary, fontSize: 40.sp),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
