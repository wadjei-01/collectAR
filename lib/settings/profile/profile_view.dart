import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:navbar/settings/profile/profile_controller.dart';
import 'package:navbar/theme/fonts.dart';
import 'package:navbar/widgets.dart';

import '../../theme/globals.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.symmetric(horizontal: 120.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              alignment: Alignment.center,
              height: 500.r,
              width: 500.r,
              decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(250.r)),
              child: Icon(
                Ionicons.person,
                color: Colors.white,
                size: 250.r,
              ),
            ),
          ),
          SizedBox(
            height: 130.h,
          ),
          textField(controller.textInputFormatter,
              hint: controller.currentUser?.displayName ?? 'William Adjei',
              textInputType: TextInputType.name),
          SizedBox(
            height: 50.h,
          ),
          textField(controller.textInputFormatter,
              hint: '0550239005', textInputType: TextInputType.name),
          SizedBox(
            height: 50.h,
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 40.w),
            height: 135.h,
            width: double.infinity,
            decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(20.r)),
            child: Text(
              controller.currentUser?.email ?? 'null',
              style: MediumHeaderStyle(
                  color: AppColors.lighten(AppColors.secondary, 0.3),
                  fontSize: 40.sp),
            ),
          ),
          SizedBox(
            height: 50.h,
          ),
          button(
              widget: Text(
            'Update',
            style: MediumHeaderStyle(fontSize: 40.sp),
          ))
        ],
      ),
    ));
  }
}
