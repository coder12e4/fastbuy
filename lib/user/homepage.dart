import 'package:fastbuy/core/fbtheme.dart';
import 'package:fastbuy/user/productview.dart';
import 'package:fastbuy/user/userCubit/homeUserCubit/home_user_cubit.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../admin/adminModels/addProductModel/addproduct.dart';
import '../admin/productlistprovider.dart';
import 'kartpage.dart';

class HomePageUser extends ConsumerStatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePageUser> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List<Product> listProducts = [];
  List<Category> listCategoris = [];
  late HomeUserCubit homeUserCubit;
  @override
  void initState() {
    homeUserCubit = HomeUserCubit(HomeUserInitial());
    homeUserCubit.LoadHome();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Filter products based on search query

    return SafeArea(
      child: Scaffold(
        body: BlocProvider<HomeUserCubit>(
          create: (context) => homeUserCubit,
          child: BlocListener<HomeUserCubit, HomeUserState>(
            listener: (context, state) {
              if (state is HomeUserInitial) {
              } else if (state is HomeUserLoading) {
              } else if (state is HomeUserSucess) {
                listProducts = state.listAllProducts;
                listCategoris = state.listCategoris;
              } else {}
            },
            child: BlocBuilder<HomeUserCubit, HomeUserState>(
              builder: (context, state) {
                if (state is HomeUserInitial) {
                  return Column(
                    children: [
                      Container(
                        height: 220,
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
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
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
                                              builder: (context) =>
                                                  const CartPage(),
                                            ),
                                          );
                                        },
                                      ),
                                      Positioned(
                                        top: 2,
                                        right: -8,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 20),
                                          child: Container(
                                            width: 10,
                                            height: 10,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.white),
                                            child: Center(
                                              child: Text(
                                                "",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall,
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
                                        hintStyle: Theme.of(context)
                                            .textTheme
                                            .bodyMedium),
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
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
                                  height: 100,
                                  child: Expanded(
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: listCategoris.length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            padding: EdgeInsets.all(4),
                                            margin: EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                border: Border.all(
                                                    color: Colors.white,
                                                    width: 1)),
                                            child: Column(children: [
                                              Text(
                                                listCategoris[index].name,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium,
                                              ),
                                              Container(
                                                width: 40,
                                                alignment: Alignment.center,
                                                margin: const EdgeInsets.only(
                                                    left: 8, right: 8),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4)),
                                                child: Image.network(
                                                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSUkxiKQEI3TzkeV79In9QCV4HV7h22WA0CVQ&s",
                                                  fit: BoxFit.fill,
                                                  height: 40,
                                                  width: 40,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 90,
                                                height: 20,
                                                child:
                                                    DropdownButtonHideUnderline(
                                                  child: DropdownButton<String>(
                                                      isExpanded: false,
                                                      elevation: 2,
                                                      hint: const Text(
                                                        "Subcategories",
                                                        style: TextStyle(
                                                            fontSize: 6,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      icon: Icon(Icons
                                                          .arrow_drop_down),
                                                      items: [
                                                        'valiyaUlli',
                                                        'cheriaUlii'
                                                      ].map((String items) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: items,
                                                          child: Text(items),
                                                        );
                                                      }).toList(),
                                                      onChanged: (items) {}),
                                                ),
                                              )
                                            ]),
                                          );
                                        }),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
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
                    ],
                  );
                } else if (state is HomeUserLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is HomeUserSucess) {
                  return Column(
                    children: [
                      Container(
                        height: 220,
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
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
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
                                              builder: (context) =>
                                                  const CartPage(),
                                            ),
                                          );
                                        },
                                      ),
                                      Positioned(
                                        top: 2,
                                        right: -8,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 20),
                                          child: Container(
                                            width: 10,
                                            height: 10,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.white),
                                            child: Center(
                                              child: Text(
                                                "",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall,
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
                                        hintStyle: Theme.of(context)
                                            .textTheme
                                            .bodyMedium),
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
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
                                  height: 100,
                                  child: Expanded(
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: listCategoris.length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            padding: EdgeInsets.all(4),
                                            margin: EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                border: Border.all(
                                                    color: Colors.white,
                                                    width: 1)),
                                            child: Column(children: [
                                              Text(
                                                listCategoris[index].name,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium,
                                              ),
                                              Container(
                                                width: 40,
                                                alignment: Alignment.center,
                                                margin: const EdgeInsets.only(
                                                    left: 8, right: 8),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4)),
                                                child: Image.network(
                                                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSUkxiKQEI3TzkeV79In9QCV4HV7h22WA0CVQ&s",
                                                  fit: BoxFit.fill,
                                                  height: 40,
                                                  width: 40,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 90,
                                                height: 20,
                                                child:
                                                    DropdownButtonHideUnderline(
                                                  child: DropdownButton<String>(
                                                      isExpanded: false,
                                                      elevation: 2,
                                                      hint: const Text(
                                                        "Subcategories",
                                                        style: TextStyle(
                                                            fontSize: 6,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      icon: Icon(Icons
                                                          .arrow_drop_down),
                                                      items: [
                                                        'valiyaUlli',
                                                        'cheriaUlii'
                                                      ].map((String items) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: items,
                                                          child: Text(items),
                                                        );
                                                      }).toList(),
                                                      onChanged: (items) {}),
                                                ),
                                              )
                                            ]),
                                          );
                                        }),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
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
                              itemCount: listProducts.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4),
                              itemBuilder: (constex, intex) {
                                return GestureDetector(
                                  onTap: () {
                                    showProductDialog(
                                      context,
                                      'https://example.com/image.jpg', // Replace with the actual image URL
                                      'Product Name',
                                      100.0, // Original price
                                      10.0, // Discount percentage
                                    );
                                  },
                                  child: Card(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          child: Text("demo image"),
                                        ),
                                        Text(listProducts[intex].name)
                                      ],
                                    ),
                                  ),
                                );
                              }))
                    ],
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
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

void showProductDialog(BuildContext context, String imageUrl,
    String productName, double price, double discount) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      double discountedPrice = price - (price * discount / 100);
      String selectedUnit = 'kg';
      int quantity = 1;

      return AlertDialog(
        title: Text(productName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(imageUrl, height: 100, width: 100),
            SizedBox(height: 10),
            Text(
              'Price: \$${price.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Discount: ${discount.toStringAsFixed(1)}%',
              style: TextStyle(fontSize: 16, color: Colors.green),
            ),
            Text(
              'Discounted Price: \$${discountedPrice.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text('Quantity:', style: TextStyle(fontSize: 16)),
                SizedBox(width: 10),
                DropdownButton<String>(
                  value: selectedUnit,
                  items: ['kg', 'mg'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    selectedUnit = newValue!;
                    Navigator.of(context).pop(); // Close the dialog
                    showProductDialog(context, imageUrl, productName, price,
                        discount); // Reopen with updated state
                  },
                ),
                SizedBox(width: 10),
                DropdownButton<int>(
                  value: quantity,
                  items:
                      List.generate(10, (index) => index + 1).map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text('$value'),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    quantity = newValue!;
                    Navigator.of(context).pop(); // Close the dialog
                    showProductDialog(context, imageUrl, productName, price,
                        discount); // Reopen with updated state
                  },
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text('Add to Cart'),
            onPressed: () {
              // Handle adding to cart with selectedUnit and quantity
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
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
