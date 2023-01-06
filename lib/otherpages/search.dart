import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:navbar/otherpages/productpage/product_controller.dart';
import 'package:navbar/otherpages/productpage/product_model.dart';
import 'package:navbar/otherpages/globals.dart';
import 'package:navbar/otherpages/productpage/product_view.dart';
import 'package:navbar/widgets.dart';

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
                  AnimationLimiter(
                    child: GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      children: [
                        ...snapshot.data!.docs
                            .where((QueryDocumentSnapshot<Object?> element) =>
                                element['name']
                                    .toString()
                                    .toLowerCase()
                                    .contains(query.toLowerCase()))
                            .map((QueryDocumentSnapshot<Object?> data) {
                          Product store = Product(
                              id: data['id'],
                              name: data['name'],
                              description: data['description'],
                              price: data['price'],
                              stock: data['stock'],
                              images: data['images'],
                              bookmarked: data['bookmarked'],
                              imageColour: data['imageColour'],
                              primaryColour: data['primaryColour'],
                              secondaryColour: data['secondaryColour'],
                              tetiaryColour: data['tetiaryColour'],
                              dateAdded: data['dateAdded'],
                              category: data['category']);

                          return TweenAnimationBuilder<double>(
                              tween: Tween<double>(begin: 0.0, end: 1.0),
                              curve: Curves.easeInOut,
                              duration: const Duration(milliseconds: 1650),
                              builder: ((context, double opacity, child) {
                                return Opacity(
                                    opacity: opacity,
                                    child: SearchCard(
                                        // ignore: unnecessary_null_comparison
                                        storedProducts: store,
                                        onPressed: () {
                                          onCardPressed(
                                              store, ProductController());
                                        }));
                              }));
                        })
                      ],
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

class SearchCard extends StatelessWidget {
  SearchCard({Key? key, required this.storedProducts, required this.onPressed})
      : super(key: key);

  var storedProducts;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    Color color = Colors.white;
    Color textColor =
        color.computeLuminance() < 0.6 ? Colors.black : Colors.white;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 200,
        height: 200,
        margin: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: HexColor(storedProducts.imageColour),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                curve: Curves.easeInOut,
                duration: const Duration(seconds: 1),
                builder: ((context, double opacity, child) {
                  return Opacity(
                    opacity: opacity,
                    child: Center(
                      child: CachedNetworkImage(
                        imageUrl: storedProducts.images[0],
                        height: 80,
                      ),
                    ),
                  );
                })),
            const SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    storedProducts.id,
                    style: TextStyle(
                        fontFamily: 'Gotham Book',
                        fontSize: 12,
                        color: textColor),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    '${storedProducts.price}',
                    style: TextStyle(
                        fontFamily: 'Montserrat Black',
                        fontSize: 13,
                        color: textColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
