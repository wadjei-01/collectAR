import 'dart:core';
import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:navbar/models/store_category_model.dart' as cat;

int counter = 0;

class CategorySelectionPage extends StatefulWidget {
  CategorySelectionPage({Key? key}) : super(key: key);

  @override
  State<CategorySelectionPage> createState() => _CategorySelectionPageState();
}

class _CategorySelectionPageState extends State<CategorySelectionPage> {
  List<String> categoryName = [];
  List<Image> _image = [];
  List<cat.StoreCategory> categoryList = [];

  @override
  Widget build(BuildContext context) {
    setState(() {
      categoryName = ['Armchairs', 'Office', 'Tables'];
      _image = [
        Image.asset(
          'assets/images/table.png',
          fit: BoxFit.contain,
          width: 20,
        ),
        Image.asset('assets/images/table.png'),
        Image.asset('assets/images/table.png')
      ];

      categoryName.forEach((element) {
        categoryList.add(cat.StoreCategory(image: _image[0], name: element));
      });
    });

    return Scaffold(
      body: ListView.builder(
          itemCount: categoryList.length,
          itemBuilder: ((context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Container(
                  height: 190,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Text(
                        '${categoryList[index].name}',
                        style:
                            TextStyle(fontFamily: 'Gotham Black', fontSize: 20),
                      ),
                      categoryList[index].image
                    ],
                  )),
            );
          })),
    );
  }
}
