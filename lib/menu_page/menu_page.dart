import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navbar/collections/collections_view.dart';
import 'package:navbar/widgets.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListOfItems(
          title: "Collections",
          onTap: () => Get.to(CollectionsView()),
        )
      ],
    );
  }
}
