import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../theme/globals.dart';
import '../widgets.dart';
import 'collections_controller.dart';

class NewCollectionsController extends GetxController {
  //Retrieves an instance of CollectionsController and assign
  final collectionsController = Get.find<CollectionsController>();

  //a TextEditingController object that retrieves the name of the collection the user wants to create
  TextEditingController collectionNameController = TextEditingController();

  Rx<Color> screenPickerColor = HexColor('F90020').obs;

  //List of available colors the user can select for a collection
  List<Color> colorList = [
    HexColor('F90020'),
    HexColor('EB4511'),
    HexColor('FABC1F'),
    HexColor('339936'),
    HexColor('60B2E5'),
    HexColor('3334E7'),
    HexColor('5C139F'),
  ];

  //The selected variable is used to assign the index of the color selected by the user

  RxInt selected = 0.obs;

  //Once a user selects a color, this method is called which assigns the index to selected variable
  void onTap(int index) {
    selected(index);
    screenPickerColor(colorList[index]);
    update();
  }

  //onInit assigns a default color to screenPickercolor
  @override
  void onInit() {
    screenPickerColor(colorList[0]);
    super.onInit();
  }

  @override
  void onClose() {
    collectionNameController.clear();
    super.onClose();
  }

  //resets all the values
  void reset() {
    collectionNameController.text = '';
    selected(0);
    screenPickerColor(colorList[0]);
  }

  //Creates a new collection
  void createCollection(BuildContext context) {
    if (collectionNameController.text.isNotEmpty) {
      collectionsController.newCollection(
          collectionNameController.text, screenPickerColor.value.value);

      reset();
      Navigator.pop(context);
    } else {
      Get.snackbar(
        "Hi there!",
        "The collection needs a name",
        snackPosition: SnackPosition.TOP,
        borderRadius: 20.r,
      );
    }
  }

  Future<dynamic> modalBottomsheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Values.borderRadius),
                topRight: Radius.circular(Values.borderRadius))),
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: SizedBox(
              height: 800.h,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 70.h,
                    ),
                    Text(
                      'Create Collection',
                      style: TextStyle(
                          color: AppColors.secondary,
                          fontFamily: 'Montserrat-Bold',
                          fontSize: 50.sp),
                    ),
                    SizedBox(
                      height: 60.h,
                    ),
                    textField(collectionNameController,
                        hint: "Collection Name"),
                    SizedBox(
                      height: 40.h,
                    ),
                    Text(
                      'Pick Color',
                      style: TextStyle(
                          color: AppColors.secondary,
                          fontFamily: 'Montserrat-SemiBold',
                          fontSize: 40.sp),
                    ),
                    ColorPicker(
                        // onChangedColor: (value) {
                        //   collectionNameController.screenPickerColor = value;
                        // },
                        ),
                    SizedBox(
                      height: 40.h,
                    ),
                    button(
                        onTap: () => createCollection(context),
                        widget: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_circle_rounded,
                              color: AppColors.secondary,
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Text(
                              "Create",
                              style: TextStyle(
                                  color: AppColors.secondary,
                                  fontSize: 60.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ),
          );
        },
        context: context);
  }
}
