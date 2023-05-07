import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io' as io;

import 'package:get/get.dart';

class GalleryView extends StatelessWidget {
  const GalleryView({super.key});

  @override
  Widget build(BuildContext context) {
    List<io.FileSystemEntity> images = Get.arguments;
    List<io.FileSystemEntity> orderedImages = images.reversed.toList();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(children: [
        CarouselSlider.builder(
            itemCount: images.length,
            itemBuilder: (cotext, index, realIndex) {
              return Container(
                  child: Image.file(io.File(orderedImages[index].uri.path)));
            },
            options: CarouselOptions(
              viewportFraction: 0.95,
              height: 1.sh,
              autoPlay: false,
              enableInfiniteScroll: false,
              enlargeCenterPage: true,
            ))
      ]),
    );
  }
}
