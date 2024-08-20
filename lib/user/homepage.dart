import 'package:fastbuy/core/fbtheme.dart';
import 'package:fastbuy/user/productview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../admin/adminModels/addProductModel/addproduct.dart';
import '../admin/productlistprovider.dart';
import 'kartpage.dart';

class HomePage extends ConsumerStatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    // Filter products based on search query

    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(170),
          child: Container(
            color: Colors.blue,
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "HI Username",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Expanded(child: SizedBox()),
                    Container(
                      alignment: Alignment.center,
                      child: Stack(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.shopping_cart),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const CartPage(),
                                ),
                              );
                            },
                          ),
                          Positioned(
                            top: 2,
                            right: -8,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: Container(
                                width: 10,
                                height: 10,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white),
                                child: Center(
                                  child: Text(
                                    "",
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 4,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                            hintText: 'Search...',
                            border: InputBorder.none,
                            hintStyle: Theme.of(context).textTheme.bodyMedium),
                        style: Theme.of(context).textTheme.bodyMedium,
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 54,
                      child: Expanded(
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return Column(children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  alignment: Alignment.center,
                                  margin:
                                      const EdgeInsets.only(left: 8, right: 8),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Image.network(
                                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSUkxiKQEI3TzkeV79In9QCV4HV7h22WA0CVQ&s",
                                    fit: BoxFit.fill,
                                    height: 20,
                                    width: 20,
                                  ),
                                ),
                                Text(
                                  "categories",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                )
                              ]);
                            }),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(
                  left: 20, right: 20, top: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "latest",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    "Show all",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(10.0),
                itemCount: 10,
                itemBuilder: (ctx, i) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ProductView()));
                    },
                    child: ProductItem(
                      product: Product(
                          id: "",
                          categoryId: "",
                          subcategoryId: "",
                          name: "",
                          price: 900,
                          userId: ''),
                    ),
                  );
                },
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class ProductItem extends ConsumerWidget {
  final Product product;

  const ProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Container(
        padding: const EdgeInsets.only(bottom: 4, left: 4, right: 4, top: 4),
        child: Stack(
          children: [
            const SizedBox(
              height: double.infinity,
              width: double.infinity,
            ),
            Positioned(
                top: 20,
                left: 20,
                right: 20,
                bottom: 80,
                child: Image.network(
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSUkxiKQEI3TzkeV79In9QCV4HV7h22WA0CVQ&s",
                  fit: BoxFit.fitHeight,
                )),
            Positioned(
              right: 4,
              top: 4,
              child: IconButton(
                icon: const Icon(Icons.favorite_border),
                onPressed: () {
                  //cartNotifier.addToCart(product);
                },
              ),
            ),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                      child: Row(children: [
                        Text(
                          product.name!,
                          style: Theme.of(context).textTheme.bodyLarge,
                          overflow: TextOverflow.fade,
                        ),
                        const Expanded(child: SizedBox()),
                        RichText(
                            text: const TextSpan(
                          text: '',
                          children: <TextSpan>[
                            TextSpan(
                              text: '\$8.99',
                              style: TextStyle(
                                  color: Colors.red,
                                  decoration: TextDecoration.lineThrough,
                                  fontSize: 8,
                                  fontFamily: "semibold"),
                            ),
                            TextSpan(
                              text: ' \$3.99',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontFamily: "semibold"),
                            ),
                          ],
                        )),
                      ]),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
