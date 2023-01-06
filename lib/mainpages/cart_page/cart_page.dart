import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:navbar/mainpages/cart_page/cartcontroller.dart';
import 'package:navbar/otherpages/globals.dart';
import 'cartmodel.dart';
import '../../otherpages/productpage/product_view.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartController cartVM = Get.put(CartController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cart',
          style: TextStyle(color: Colors.black, fontFamily: 'Gotham Black'),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: GetBuilder<CartController>(
            init: cartVM,
            builder: (value) {
              if (value.box.isNotEmpty) {
                return ListView.builder(
                    itemCount: value.box.length,
                    itemBuilder: (context, index) {
                      final quantity = value.box.getAt(index)!.quantity.obs;
                      final item = value.box.getAt(index)!;
                      return Dismissible(
                        key: const ValueKey(0),
                        background: Container(
                          color: Colors.red,
                          child: Container(
                            height: 50,
                            width: 50,
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        onDismissed: (direction) => value.del(index),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Color(
                                                value.box.getAt(index)!.color)),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(5)),
                                        color: Color(
                                            value.box.getAt(index)!.color)),
                                    child: Center(
                                      child: CachedNetworkImage(
                                        imageUrl: value.box.getAt(index)!.image,
                                        width: 70,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Container(
                                    height: 100,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          value.box.getAt(index)!.name,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 19,
                                              fontFamily: 'Gotham',
                                              color: AppColors.darken(Color(
                                                  value.box
                                                      .getAt(index)!
                                                      .color))),
                                        ),
                                        Text(
                                          'Size: 140 x 50',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              fontFamily: 'Montserrat-Medium',
                                              color:
                                                  Color.fromARGB(103, 0, 0, 0)),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  ItemNumberButton(
                                                    bgColor: Color(value.box
                                                        .getAt(index)!
                                                        .color),
                                                    buttonSize: 23,
                                                    buttonRadius: 5,
                                                    isAdd: false,
                                                    number: quantity.value,
                                                    onCountChange: () {
                                                      quantity.value--;
                                                      value.add(
                                                          value.box
                                                              .getAt(index)!
                                                              .id,
                                                          value.box
                                                              .getAt(index)!
                                                              .image,
                                                          value.box
                                                              .getAt(index)!
                                                              .name,
                                                          '₵${value.box.getAt(index)!.price}',
                                                          quantity.value,
                                                          Color(value.box
                                                              .getAt(index)!
                                                              .color));

                                                      if (quantity.value == 0) {
                                                        value.del(index);
                                                      }
                                                    },
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 5),
                                                    child: SizedBox(
                                                      width: 30,
                                                      child: Center(
                                                        child: Obx(
                                                          () => Text(
                                                              value.box
                                                                          .getAt(
                                                                              index)!
                                                                          .quantity <=
                                                                      9
                                                                  ? '0${quantity.value}'
                                                                  : '${quantity.value}',
                                                              style: const TextStyle(
                                                                  fontFamily:
                                                                      'Gotham',
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                      17)),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  ItemNumberButton(
                                                    bgColor: Color(value.box
                                                        .getAt(index)!
                                                        .color),
                                                    isAdd: true,
                                                    buttonSize: 23,
                                                    buttonRadius: 5,
                                                    number: quantity.value,
                                                    onCountChange: () {
                                                      quantity.value++;
                                                      value.add(
                                                          value.box
                                                              .getAt(index)!
                                                              .id,
                                                          value.box
                                                              .getAt(index)!
                                                              .image,
                                                          value.box
                                                              .getAt(index)!
                                                              .name,
                                                          '₵${value.box.getAt(index)!.price}',
                                                          quantity.value,
                                                          Color(value.box
                                                              .getAt(index)!
                                                              .color));
                                                    },
                                                  ),
                                                ]),
                                            SizedBox(
                                              width: 45,
                                            ),
                                            Text(
                                              '₵ ${value.box.getAt(index)!.price.toString()}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14,
                                                  fontFamily:
                                                      'Montserrat-Medium',
                                                  color: Color.fromARGB(
                                                      103, 0, 0, 0)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              color: AppColors.lighten(Colors.grey, 0.2),
                              thickness: 0.5,
                              indent: 20,
                              endIndent: 20,
                            )
                          ],
                        ),
                      );
                    });
              }
              return Center(
                child: Text("Cart Empty"),
              );
            }),
      ),
    );
  }
}
