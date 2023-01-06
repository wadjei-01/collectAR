import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:navbar/otherpages/globals.dart';
import 'package:navbar/models/user_model.dart' as userModel;
import '../../main.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser!;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  userModel.User userDets = box.get('user');
  String userName = '';

  @override
  void initState() {
    super.initState();
    // _getUserName();
  }

  List<String> profileInfo = [
    'Payment',
    'Profile',
    'Settings',
    'About',
    'Help'
  ];

  List<IconData> profileIcon = [
    Icons.payment_rounded,
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
                return ListTile(
                  trailing: Icon(Icons.arrow_forward_ios_rounded),
                  contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
                  horizontalTitleGap: 10,
                  leading: Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: AppColors.lighten(AppColors.primary, 0.4)),
                    child: Icon(
                      profileIcon[index],
                      color: Colors.black,
                    ),
                  ),
                  title: Text(
                    profileInfo[index],
                    style: const TextStyle(
                      fontFamily: 'Montserrat-SemiBold',
                    ),
                  ),
                );
              },
              itemCount: profileInfo.length,
            ),
            const SizedBox(
              height: 70,
            ),
            Center(
              child: MaterialButton(
                minWidth: 200,
                height: 50,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                color: const Color.fromARGB(255, 20, 4, 82),
                child: const Text(
                  'SIGN OUT',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
