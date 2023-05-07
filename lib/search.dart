import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:navbar/productpage/product_model.dart';
import 'package:navbar/widgets.dart';

import 'theme/globals.dart';

class Search extends SearchDelegate {
  CollectionReference _firestoreDB =
      FirebaseFirestore.instance.collection('store');

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
            onPressed: () {
              if (query.isEmpty) {
                close(context, null);
              }
              query = '';
            },
            icon: const Icon(Icons.clear))
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
      onPressed: () => close(context, null), icon: Icon(Icons.arrow_back_ios));

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestoreDB.snapshots().asBroadcastStream(),
        builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          }

          if (snapshot.data!.docs
              .where((QueryDocumentSnapshot<Object?> element) => element['name']
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()))
              .isEmpty) {
            return const Center(child: Text('Nothing to show'));
          } else {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                    child: AnimationLimiter(
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 30.h,
                          childAspectRatio: 2.w / 2.2.h,
                          crossAxisSpacing: 30.w,
                        ),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          QueryDocumentSnapshot queryDocumentSnapshot =
                              snapshot.data!.docs[index];
                          Product store = Product.fromJson(queryDocumentSnapshot
                              .data() as Map<String, dynamic>);

                          return TweenAnimationBuilder<double>(
                              tween: Tween<double>(begin: 0.0, end: 1.0),
                              curve: Curves.easeInOut,
                              duration: const Duration(milliseconds: 1650),
                              builder: ((context, double opacity, child) {
                                return Opacity(
                                    opacity: opacity,
                                    child: ProductCard(
                                        storedProducts: store,
                                        onPressed: () {
                                          displayProduct(
                                            store,
                                          );
                                        }));
                              }));
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        }));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestions = [];

    if (query.isEmpty) {
      return Center(
        child: Text('Search anything here'),
      );
    }

    return ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];

          return ListTile(
            title: Text(suggestion),
            onTap: () {
              query = suggestion;
              showResults(context);
            },
          );
        });
  }
}
