import 'package:get/get.dart';

class PaymentController extends GetxController {
  RxBool isExtended = false.obs;

  extend() {
    isExtended(!isExtended.value);
    print(isExtended.value);
    update();
  }
}
