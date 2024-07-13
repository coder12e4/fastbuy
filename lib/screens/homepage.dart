import 'package:fastbuy/core/fbtheme.dart';
import 'package:fastbuy/screens/productview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/ProductList.dart';
import '../models/product.dart';
import '../providers/kartprovider.dart';
import '../providers/productprovider/productprovider.dart';
import 'kartpage.dart';

class HomePage extends ConsumerStatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(productsProvider);
    final fprovider = ref.watch(futureprovider);

    final cart = ref.watch(cartProvider);
    // Filter products based on search query
    final filteredProducts = products.where((product) {
      return product.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(170),
          child: Container(
            color: Colors.blue,
            padding: EdgeInsets.only(left: 10, right: 10),
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
                    Expanded(child: SizedBox()),
                    Container(
                      alignment: Alignment.center,
                      child: Stack(
                        children: [
                          Container(
                            child: IconButton(
                              icon: Icon(Icons.shopping_cart),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => CartPage(),
                                  ),
                                );
                              },
                            ),
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
                                    cart.length.toString(),
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
                SizedBox(
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
                SizedBox(
                  height: 12,
                ),
                Column(
                  children: [
                    Container(
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
                                  margin: EdgeInsets.only(left: 8, right: 8),
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
        body: RefreshIndicator(
          onRefresh: () async {
            print("refreding");
          },
          child: fprovider.when(
              data: (p) => Column(
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
                          itemCount: p.data!.category![0].productlist!.length,
                          itemBuilder: (ctx, i) {
                            print(p.data!.category![0].productlist!.length);

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => productView()));
                              },
                              child: ProductItem(
                                product: p.data!.category![0].productlist![i],
                              ),
                            );
                          },
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 3 / 4,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                        ),
                      )
                    ],
                  ),
              error: (err, stack) => Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.error),
                      Text(
                        "Something went wrong,swipe to refresh",
                        style: Theme.of(context).textTheme.bodySmall,
                      )
                    ],
                  )),
              loading: () => Center(child: CircularProgressIndicator())),
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
  final Productlist product;

  ProductItem({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef watch) {
    final cartNotifier = watch.watch(cartProvider.notifier);

    return Card(
      child: Container(
        padding: const EdgeInsets.only(bottom: 4, left: 4, right: 4, top: 4),
        child: Stack(
          children: [
            Container(
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
              child: IconButton(
                icon: Icon(Icons.favorite_border),
                onPressed: () {
                  //cartNotifier.addToCart(product);
                },
              ),
              right: 4,
              top: 4,
            ),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Container(
                      height: 40,
                      child: Row(children: [
                        Text(
                          product.name!,
                          style: Theme.of(context).textTheme.bodyLarge,
                          overflow: TextOverflow.fade,
                        ),
                        Expanded(child: SizedBox()),
                        new RichText(
                            text: new TextSpan(
                          text: '',
                          children: <TextSpan>[
                            new TextSpan(
                              text: '\$8.99',
                              style: new TextStyle(
                                  color: Colors.red,
                                  decoration: TextDecoration.lineThrough,
                                  fontSize: 8,
                                  fontFamily: "semibold"),
                            ),
                            new TextSpan(
                              text: ' \$3.99',
                              style: new TextStyle(
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
