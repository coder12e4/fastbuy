import 'dart:async';
import 'package:fastbuy/user/pages/Profile/ProfilePage.dart';
import 'package:fastbuy/user/pages/loginpage.dart';
import 'package:fastbuy/user/pages/productview.dart';
import 'package:fastbuy/user/userCubit/Kart_cubit/cart_cubit.dart';
import 'package:fastbuy/user/userCubit/homeUserCubit/home_user_cubit.dart';
import 'package:fastbuy/user/userCubit/subcategories/cubit/subcategories_cubit.dart';
import 'package:fastbuy/common/OrderItems/OrderItemView.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../admin/adminModels/addProductModel/addproduct.dart';
import '../../core/constants.dart';
import '../../core/widgets/emptyoralert.dart';
import 'kartpage.dart';

class DropdownDialog extends StatelessWidget {
  final Product product;
  final CartCubit cart;
  final HomeUserCubit homeUserCubit;
  final String userId;
  final String sellerId;

  DropdownDialog(
      this.product, this.cart, this.userId, this.homeUserCubit, this.sellerId);

  @override
  Widget build(BuildContext context) {
    double quantityKg = 0;
    double quantityG = 0;
    double quantityMg = 0;

    double totalPriceInKg = 0.0;
    double totalPriceInG = 0.0;
    double totalPriceInMg = 0.0;
    double total = 0.0;
    double totalQuantity = 0.0;

    double calculate(double pricePerKg, String type, double value) {
      if (type == "kg") {
        totalPriceInKg = value * pricePerKg;
      } else if (type == "g") {
        totalPriceInG = value * pricePerKg / 1000;
      } else if (type == 'mg') {
        totalPriceInMg = value * pricePerKg / 1e6;
      }
      total = totalPriceInKg + totalPriceInG + totalPriceInMg;
      return total;
    }

    double calculateTotalQuantity(double kg, double g, double mg) {
      return kg + g / 1000 + mg / 1e6;
    }

    return AlertDialog(
      title: Center(child: Text(product.name)),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 140,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        product.image,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 80,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20))),
                          child: Text(
                            "${product.Discount}% off",
                            style: const TextStyle(
                                fontSize: 12, color: Colors.black),
                          ),
                        ))
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Price:',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${product.price.toStringAsFixed(2)}/kg',
                          style: const TextStyle(
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        TextSpan(
                          text: ' ${product.PriceAfterDiscount}/kg',
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Discount Price',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                  ),
                  Text(
                    "${double.parse(product.PriceAfterDiscount).toStringAsFixed(2)}/kg",
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Kg",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        DropdownButton<int>(
                          value: quantityKg.toInt(),
                          items: List.generate(11, (index) => index)
                              .map((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text('$value'),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              quantityKg = newValue!.toDouble();
                              total = calculate(
                                  double.parse(product.PriceAfterDiscount),
                                  "kg",
                                  quantityKg);
                              totalQuantity = calculateTotalQuantity(
                                  quantityKg, quantityG, quantityMg);
                            });
                          },
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("G",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500)),
                        DropdownButton<int>(
                          value: quantityG.toInt(),
                          items: List.generate(21, (index) => index * 50)
                              .map((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text('$value'),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              quantityG = newValue!.toDouble();
                              total = calculate(
                                  double.parse(product.PriceAfterDiscount),
                                  "g",
                                  quantityG);
                              totalQuantity = calculateTotalQuantity(
                                  quantityKg, quantityG, quantityMg);
                            });
                          },
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Mg",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500)),
                        DropdownButton<int>(
                          value: quantityMg.toInt(),
                          items: List.generate(20, (index) => index * 50)
                              .map((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text('$value'),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              quantityMg = newValue!.toDouble();
                              total = calculate(
                                  double.parse(product.PriceAfterDiscount),
                                  "mg",
                                  quantityMg);
                              totalQuantity = calculateTotalQuantity(
                                  quantityKg, quantityG, quantityMg);
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Total Quantity:',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${totalQuantity.toStringAsFixed(6)} kg",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Total Price:',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    total.toStringAsFixed(2),
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              const SizedBox(height: 10),
            ],
          );
        },
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                cart
                    .addproductToKart(userId, product, total.toString(),
                        totalQuantity.toString())
                    .then((value) {
                  homeUserCubit.fetchCategories(sellerId, userId);
                }).then((value) {
                  Navigator.of(context).pop();
                });
              },
              child: const Text('Add to Cart'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        )
      ],
    );
  }
}

class HomePageUser extends StatefulWidget {
  final String userId;
  final String sellerId;
  const HomePageUser({super.key, required this.userId, required this.sellerId});

  @override
  State<HomePageUser> createState() => _HomePageUserState();
}

class _HomePageUserState extends State<HomePageUser> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  late String userId;
  List<Product> listProducts = [];
  List<Category> listCategoris = [];
  List<Subcategory> listSubCategoris = [];
  late HomeUserCubit homeUserCubit;
  late HomeUserCubit homeUserCubit1;
  late SubcategoriesCubit subcategoryCubit;
  late CartCubit cartCubit;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String? sellerId;
  int CartCount = 0;
  int _selectedIndex = 0;
  List<OrderModel> orderlist = [];
  bool isGridView = false;
  bool isGridViewSubCategory = false;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (_selectedIndex == 1) {
      homeUserCubit.fetchOrdersByUserId(userId);
    } else {
      homeUserCubit.fetchCategories(sellerId!, userId);
      homeUserCubit1.getCartByuserId(userId);
    }
  }

  late String userName_;
  @override
  void initState() {
    homeUserCubit = HomeUserCubit(HomeUserInitial());
    homeUserCubit1 = HomeUserCubit(HomeUserInitial());

    subcategoryCubit = SubcategoriesCubit();
    userId = widget.userId;
    sellerId = widget.sellerId;
    homeUserCubit.fetchCategories(sellerId!, userId);
    homeUserCubit1.getCartByuserId(userId);
    cartCubit = CartCubit();
    super.initState();
  }

  Widget Search() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            style: const TextStyle(fontSize: 14, color: Colors.black),
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
                homeUserCubit.loadProductsformSearch(_searchQuery, sellerId);
              });
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'Search',
              hintStyle: const TextStyle(fontSize: 14),
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.black,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.green),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.red),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<bool> _onWillPop(BuildContext context) async {
    bool exitApp = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Do you want to exit the app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (exitApp) {
      SystemNavigator.pop();
    }

    return exitApp;
  }

  @override
  Widget build(BuildContext context) {
    // Filter products based on search query
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          return _onWillPop(context);
        },
        child: Scaffold(
          key: _scaffoldKey,
          drawer: Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10))),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width - 100,
            child: Column(
              children: [
                Container(
                  color: FbColors.primaryColor,
                  height: 180,
                  width: MediaQuery.of(context).size.width - 100,
                  alignment: Alignment.center,
                  child: const Text(
                    "Fast Buy",
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (c) => Profilepage(
                                  userId: userId,
                                )));
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 30,
                        height: 48,
                      ),
                      Icon(Icons.person),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Profile", style: TextStyle(fontSize: 14))
                    ],
                  ),
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.grey[300],
                ),
                GestureDetector(
                  onTap: () {
                    homeUserCubit.logout().then((t) =>
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (c) => Login())));
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 30,
                        height: 48,
                      ),
                      Icon(Icons.settings),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Settings",
                        style: TextStyle(fontSize: 14),
                      )
                    ],
                  ),
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.grey[300],
                ),
                GestureDetector(
                  onTap: () {
                    homeUserCubit.logout().then((t) =>
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (c) => Login())));
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 30,
                        height: 48,
                      ),
                      Icon(Icons.logout),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Logout", style: TextStyle(fontSize: 14))
                    ],
                  ),
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.grey[300],
                ),
              ],
            ),
          ),
          appBar: AppBar(
            backgroundColor: FbColors.primaryColor,
            leading: GestureDetector(
                onTap: () {
                  if (_scaffoldKey.currentState!.isDrawerOpen) {
                    _scaffoldKey.currentState!.openEndDrawer();
                  } else {
                    _scaffoldKey.currentState!.openDrawer();
                  }
                },
                child: const Icon(
                  Icons.menu,
                  color: Colors.white,
                )),
            title: Row(
              children: [
                Text(
                  "Hi",
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                const Expanded(child: SizedBox()),
                Container(
                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CartPage(
                                userId: userId,
                              ),
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
                            width: 14,
                            height: 14,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                color: Colors.red),
                            child: Center(
                              child: BlocProvider<HomeUserCubit>(
                                create: (context) => homeUserCubit1,
                                child:
                                    BlocBuilder<HomeUserCubit, HomeUserState>(
                                  builder: (context, state) {
                                    if (state is cartCountStateHome) {
                                      return Text(
                                        state.count,
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 10),
                                      );
                                    } else {
                                      return Container(
                                        color: Colors.green,
                                      );
                                    }
                                  },
                                ),
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
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list_alt),
                label: 'Orders',
              ),
            ],
            currentIndex: _selectedIndex,
            unselectedItemColor: Colors.grey,
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
            selectedItemColor: Colors.white,
            onTap: _onItemTapped,
            backgroundColor: FbColors.primaryColor,
          ),
          body: BlocProvider<HomeUserCubit>(
            create: (context) => homeUserCubit,
            child: BlocListener<HomeUserCubit, HomeUserState>(
              listener: (context, state) {
                if (state is HomeUserInitial) {
                } else if (state is HomeUserLoading) {
                } else if (state is HomeUserSucess) {
                } else if (state is HomeUserCategoryProductsLoading) {
                } else if (state is HomeUserCategoryProductsSucess) {
                  listCategoris = state.categories;
                  listProducts.clear();
                } else if (state is HomeUserCategoryProductsFail) {
                } else if (state is HomeUsersubCategoryProductsLoading) {
                } else if (state is HomeUsersubCategoryProductsSucess) {
                  isGridView = false;
                  listSubCategoris = state.subcategories;
                } else if (state is HomeUsersubCategoryProductsFail) {
                } else if (state is HomeUserProductsLoading) {
                } else if (state is HomeUserProductsSuc) {
                  listProducts.clear();
                  listProducts = state.products;

                  int? k = cartCubit.kartLength;
                  isGridView = false;
                  isGridViewSubCategory = false;
                } else if (state is HomeUserProductsFail) {
                } else if (state is UserOrderLoading) {
                } else if (state is UserOrderSuccess) {
                  //orderlist.clear();
                  orderlist = state.orderlist;
                } else if (state is UserOrderFail) {
                } else {}
              },
              child: BlocBuilder<HomeUserCubit, HomeUserState>(
                builder: (context, state) {
                  if (state is HomeUserInitial) {
                    return Column(
                      children: [
                        Container(
                          height: 220,
                          color: Colors.green,
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 4,
                              ),
                              Search(),
                              const SizedBox(
                                height: 12,
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: 100,
                                    child: Center(
                                      child: SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: CircularProgressIndicator(
                                          color: FbColors.primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  } else if (state is HomeUserLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: FbColors.primaryColor,
                      ),
                    );
                  } else if (state is HomeUserSucess) {
                    return Column(
                      children: [
                        Container(
                          height: 70,
                          color: FbColors.primaryColor,
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 4,
                              ),
                              Search(),
                              const SizedBox(
                                height: 12,
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: 80,
                                    child: Expanded(
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: listCategoris.length,
                                          itemBuilder: (context, index) {
                                            if (listCategoris.isEmpty) {
                                              return const Center(
                                                child: EmptyOrAlert(
                                                  empty: true,
                                                ),
                                              );
                                            } else {
                                              return GestureDetector(
                                                onTap: () {
                                                  subcategoryCubit
                                                      .GetAllSubCategoriesById(
                                                          listCategoris[index]
                                                              .id);
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(4),
                                                  margin: EdgeInsets.all(4),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                      border: Border.all(
                                                          color: Colors.black,
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
                                                      alignment:
                                                          Alignment.center,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 8,
                                                              right: 8),
                                                      decoration: BoxDecoration(
                                                          color: Colors.black,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4)),
                                                      child: Image.network(
                                                        listCategoris[index]
                                                            .image,
                                                        fit: BoxFit.fill,
                                                        height: 40,
                                                        width: 40,
                                                      ),
                                                    ),
                                                  ]),
                                                ),
                                              );
                                            }
                                          }),
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: 80,
                                    child: BlocProvider<SubcategoriesCubit>(
                                      create: (context) => subcategoryCubit,
                                      child: BlocListener<SubcategoriesCubit,
                                          SubcategoriesState>(
                                        bloc: subcategoryCubit,
                                        listener: (context, state) {
                                          if (state is SubcategoriesLoading) {
                                          } else if (state
                                              is SubcategoriesSuccess) {
                                            listSubCategoris.clear();
                                            listSubCategoris =
                                                state.listSubcategoris;
                                          } else if (state
                                              is SubcategoriesFailed) {}
                                        },
                                        child: BlocBuilder<SubcategoriesCubit,
                                            SubcategoriesState>(
                                          builder: (context, state) {
                                            if (state is SubcategoriesLoading) {
                                              return const Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            } else if (state
                                                is SubcategoriesSuccess) {
                                              return Expanded(
                                                child: ListView.builder(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount:
                                                        listSubCategoris.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4),
                                                        margin: const EdgeInsets
                                                            .all(4),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4),
                                                            border: Border.all(
                                                                color: Colors
                                                                    .white,
                                                                width: 1)),
                                                        child:
                                                            Column(children: [
                                                          Text(
                                                            listSubCategoris[
                                                                    index]
                                                                .name,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyMedium,
                                                          ),
                                                        ]),
                                                      );
                                                    }),
                                              );
                                            } else if (state
                                                is SubcategoriesFailed) {
                                              return const Center(
                                                child: Icon(
                                                  Icons.hourglass_empty,
                                                  size: 24,
                                                  color: Colors.black,
                                                ),
                                              );
                                            } else {
                                              return const SizedBox();
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
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
                                  if (listProducts.isEmpty) {
                                    return const Center(
                                      child: EmptyOrAlert(empty: true),
                                    );
                                  } else {
                                    return GestureDetector(
                                      onTap: () {},
                                      child: Card(
                                        child: Column(
                                          children: [
                                            const SizedBox(
                                              child: Text("demo image"),
                                            ),
                                            Text(
                                              listProducts[intex].name,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                }))
                      ],
                    );
                  } else if (state is HomeUserCategoryProductsLoading) {
                    return Container(
                      height: 90,
                      color: FbColors.primaryColor,
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 4,
                          ),
                          Search(),
                          const SizedBox(
                            height: 12,
                          ),
                        ],
                      ),
                    );
                  } else if (state is HomeUserCategoryProductsSucess) {
                    return Column(children: [
                      Container(
                        height: 90,
                        color: FbColors.primaryColor,
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 4,
                            ),
                            Search(),
                            const SizedBox(
                              height: 12,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Categories",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w800),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      isGridView =
                                          !isGridView; // Toggle between views
                                    });
                                  },
                                  child: Text(
                                      isGridView ? "View as List" : "View All"),
                                ),
                              ),
                            ],
                          ),

                          // Animated Container
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            height: isGridView
                                ? ((listCategoris.length + 3) ~/ 4) * 100
                                : 100, // Adjust height for smooth transition
                            child: isGridView
                                ? GridView.builder(
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4, // Number of columns
                                      crossAxisSpacing: 2,
                                      mainAxisSpacing: 2,
                                    ),
                                    itemCount: listCategoris.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          homeUserCubit.fetchSubCategories(
                                              listCategoris[index].id);
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.all(4),
                                          child: Column(children: [
                                            Container(
                                              width: 60,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(60),
                                                  border: Border.all(
                                                      color: Colors.black,
                                                      width: 1)),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(60),
                                                child: Image.network(
                                                  listCategoris[index].image,
                                                  fit: BoxFit.fill,
                                                  height: 60,
                                                  width: 60,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Text(listCategoris[index].name,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w900)),
                                          ]),
                                        ),
                                      );
                                    },
                                  )
                                : ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: listCategoris.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          homeUserCubit.fetchSubCategories(
                                              listCategoris[index].id);
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              left: 14,
                                              right: 14,
                                              top: 4,
                                              bottom: 4),
                                          child: Column(children: [
                                            Container(
                                              width: 60,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(60),
                                                  border: Border.all(
                                                      color: Colors.black,
                                                      width: 1)),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(60),
                                                child: Image.network(
                                                  listCategoris[index].image,
                                                  fit: BoxFit.fill,
                                                  height: 60,
                                                  width: 60,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Text(listCategoris[index].name,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w900)),
                                          ]),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ],
                      )
                    ]);
                  } else if (state is HomeUserCategoryProductsFail) {
                    return Container();
                  } else if (state is HomeUsersubCategoryProductsLoading) {
                    return Column(
                      children: [
                        Container(
                          height: 90,
                          color: FbColors.primaryColor,
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 4,
                              ),
                              Search(),
                              const SizedBox(
                                height: 12,
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Categories",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        isGridView =
                                            !isGridView; // Toggle between views
                                      });
                                    },
                                    child: Text(isGridView
                                        ? "View as List"
                                        : "View All"),
                                  ),
                                ),
                              ],
                            ),

                            // Animated Container
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              height: isGridView
                                  ? ((listCategoris.length + 3) ~/ 4) * 100
                                  : 100, // Adjust height for smooth transition
                              child: isGridView
                                  ? GridView.builder(
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4, // Number of columns
                                        crossAxisSpacing: 2,
                                        mainAxisSpacing: 2,
                                      ),
                                      itemCount: listCategoris.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            homeUserCubit.fetchSubCategories(
                                                listCategoris[index].id);
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.all(4),
                                            child: Column(children: [
                                              Container(
                                                width: 60,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            60),
                                                    border: Border.all(
                                                        color: Colors.black,
                                                        width: 1)),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(60),
                                                  child: Image.network(
                                                    listCategoris[index].image,
                                                    fit: BoxFit.fill,
                                                    height: 60,
                                                    width: 60,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 4,
                                              ),
                                              Text(listCategoris[index].name,
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w900)),
                                            ]),
                                          ),
                                        );
                                      },
                                    )
                                  : ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: listCategoris.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            homeUserCubit.fetchSubCategories(
                                                listCategoris[index].id);
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                left: 14,
                                                right: 14,
                                                top: 4,
                                                bottom: 4),
                                            child: Column(children: [
                                              Container(
                                                width: 60,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            60),
                                                    border: Border.all(
                                                        color: Colors.black,
                                                        width: 1)),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(60),
                                                  child: Image.network(
                                                    listCategoris[index].image,
                                                    fit: BoxFit.fill,
                                                    height: 60,
                                                    width: 60,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              Text(listCategoris[index].name,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w900)),
                                            ]),
                                          ),
                                        );
                                      },
                                    ),
                            ),
                          ],
                        ),
                      ],
                    );
                  } else if (state is HomeUsersubCategoryProductsSucess) {
                    return Column(
                      children: [
                        Container(
                          height: 90,
                          color: FbColors.primaryColor,
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 4,
                              ),
                              Search(),
                              const SizedBox(
                                height: 12,
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Categories",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        isGridView =
                                            !isGridView; // Toggle between views
                                      });
                                    },
                                    child: Text(isGridView
                                        ? "View as List"
                                        : "View All"),
                                  ),
                                ),
                              ],
                            ),

                            // Animated Container
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              height: isGridView
                                  ? ((listCategoris.length + 3) ~/ 4) * 100
                                  : 100, // Adjust height for smooth transition
                              child: isGridView
                                  ? GridView.builder(
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4, // Number of columns
                                        crossAxisSpacing: 2,
                                        mainAxisSpacing: 2,
                                      ),
                                      itemCount: listCategoris.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            homeUserCubit.fetchSubCategories(
                                                listCategoris[index].id);
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.all(4),
                                            child: Column(children: [
                                              Container(
                                                width: 60,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            60),
                                                    border: Border.all(
                                                        color: Colors.black,
                                                        width: 1)),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(60),
                                                  child: Image.network(
                                                    listCategoris[index].image,
                                                    fit: BoxFit.fill,
                                                    height: 60,
                                                    width: 60,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 4,
                                              ),
                                              Text(listCategoris[index].name,
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w900)),
                                            ]),
                                          ),
                                        );
                                      },
                                    )
                                  : ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: listCategoris.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            homeUserCubit.fetchSubCategories(
                                                listCategoris[index].id);
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                left: 14,
                                                right: 14,
                                                top: 4,
                                                bottom: 4),
                                            child: Column(children: [
                                              Container(
                                                width: 60,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            60),
                                                    border: Border.all(
                                                        color: Colors.black,
                                                        width: 1)),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(60),
                                                  child: Image.network(
                                                    listCategoris[index].image,
                                                    fit: BoxFit.fill,
                                                    height: 60,
                                                    width: 60,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 4,
                                              ),
                                              Text(listCategoris[index].name,
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w900)),
                                            ]),
                                          ),
                                        );
                                      },
                                    ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Sub Categories",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        isGridViewSubCategory =
                                            !isGridViewSubCategory; // Toggle between views
                                      });
                                    },
                                    child: Text(isGridViewSubCategory
                                        ? "View as List"
                                        : "View All"),
                                  ),
                                ),
                              ],
                            ),

                            // Animated Container
                            AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              height: isGridViewSubCategory
                                  ? ((listSubCategoris.length + 3) ~/ 4) * 100
                                  : 100, // Adjust height for smooth transition
                              child: isGridViewSubCategory
                                  ? GridView.builder(
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4, // Number of columns
                                        crossAxisSpacing: 2,
                                        mainAxisSpacing: 2,
                                      ),
                                      itemCount: listSubCategoris.length,
                                      itemBuilder: (context, index) {
                                        if (listCategoris.isEmpty) {
                                          return const EmptyOrAlert(
                                              empty: true);
                                        } else {
                                          return GestureDetector(
                                            onTap: () {
                                              homeUserCubit
                                                  .GetProductsbycatogorysubcategory(
                                                      listCategoris[0].id,
                                                      listSubCategoris[index]
                                                          .id);
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.all(4),
                                              child: Column(children: [
                                                Container(
                                                  width: 60,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              60),
                                                      border: Border.all(
                                                          color: Colors.black,
                                                          width: 1)),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            60),
                                                    child: Image.network(
                                                      listSubCategoris[index]
                                                          .image,
                                                      fit: BoxFit.fill,
                                                      height: 60,
                                                      width: 60,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 4,
                                                ),
                                                Text(
                                                    listSubCategoris[index]
                                                        .name,
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w900)),
                                              ]),
                                            ),
                                          );
                                        }
                                      },
                                    )
                                  : ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: listSubCategoris.length,
                                      itemBuilder: (context, index) {
                                        if (listSubCategoris.isEmpty) {
                                          return const EmptyOrAlert(
                                              empty: true);
                                        } else {
                                          return GestureDetector(
                                            onTap: () {
                                              homeUserCubit
                                                  .GetProductsbycatogorysubcategory(
                                                      listCategoris[0].id,
                                                      listSubCategoris[index]
                                                          .id);
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.all(4),
                                              child: Column(children: [
                                                Container(
                                                  width: 60,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              60),
                                                      border: Border.all(
                                                          color: Colors.black,
                                                          width: 1)),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            60),
                                                    child: Image.network(
                                                      listSubCategoris[index]
                                                          .image,
                                                      fit: BoxFit.fill,
                                                      height: 60,
                                                      width: 60,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 4,
                                                ),
                                                Text(
                                                    listSubCategoris[index]
                                                        .name,
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w900)),
                                              ]),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                            ),
                          ],
                        ),
                      ],
                    );
                  } else if (state is HomeUsersubCategoryProductsFail) {
                    return Center(
                      child: Text("subcategoryloading failed"),
                    );
                  } else if (state is HomeUserProductsLoading) {
                    return Column(
                      children: [
                        Container(
                          height: 90,
                          color: FbColors.primaryColor,
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 4,
                              ),
                              Search(),
                              const SizedBox(
                                height: 12,
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Categories",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        isGridView =
                                            !isGridView; // Toggle between views
                                      });
                                    },
                                    child: Text(isGridView
                                        ? "View as List"
                                        : "View All"),
                                  ),
                                ),
                              ],
                            ),

                            // Animated Container
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              height: isGridView
                                  ? ((listCategoris.length + 3) ~/ 4) * 100
                                  : 100, // Adjust height for smooth transition
                              child: isGridView
                                  ? GridView.builder(
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4, // Number of columns
                                        crossAxisSpacing: 2,
                                        mainAxisSpacing: 2,
                                      ),
                                      itemCount: listCategoris.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            homeUserCubit.fetchSubCategories(
                                                listCategoris[index].id);
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.all(4),
                                            child: Column(children: [
                                              Container(
                                                width: 60,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            60),
                                                    border: Border.all(
                                                        color: Colors.black,
                                                        width: 1)),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(60),
                                                  child: Image.network(
                                                    listCategoris[index].image,
                                                    fit: BoxFit.fill,
                                                    height: 60,
                                                    width: 60,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 4,
                                              ),
                                              Text(listCategoris[index].name,
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w900)),
                                            ]),
                                          ),
                                        );
                                      },
                                    )
                                  : ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: listCategoris.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            homeUserCubit.fetchSubCategories(
                                                listCategoris[index].id);
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                left: 14,
                                                right: 14,
                                                top: 4,
                                                bottom: 4),
                                            child: Column(children: [
                                              Container(
                                                width: 60,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            60),
                                                    border: Border.all(
                                                        color: Colors.black,
                                                        width: 1)),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(60),
                                                  child: Image.network(
                                                    listCategoris[index].image,
                                                    fit: BoxFit.fill,
                                                    height: 60,
                                                    width: 60,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              Text(listCategoris[index].name,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w900)),
                                            ]),
                                          ),
                                        );
                                      },
                                    ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Sub Categories",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        isGridViewSubCategory =
                                            !isGridViewSubCategory; // Toggle between views
                                      });
                                    },
                                    child: Text(isGridViewSubCategory
                                        ? "View as List"
                                        : "View All"),
                                  ),
                                ),
                              ],
                            ),

                            // Animated Container
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              height: isGridViewSubCategory
                                  ? ((listSubCategoris.length + 3) ~/ 4) * 100
                                  : 100, // Adjust height for smooth transition
                              child: isGridViewSubCategory
                                  ? GridView.builder(
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4, // Number of columns
                                        crossAxisSpacing: 2,
                                        mainAxisSpacing: 2,
                                      ),
                                      itemCount: listSubCategoris.length,
                                      itemBuilder: (context, index) {
                                        if (listCategoris.isEmpty) {
                                          return const EmptyOrAlert(
                                              empty: true);
                                        } else {
                                          return GestureDetector(
                                            onTap: () {
                                              homeUserCubit
                                                  .GetProductsbycatogorysubcategory(
                                                      listCategoris[0].id,
                                                      listSubCategoris[index]
                                                          .id);
                                            },
                                            child: Container(
                                              margin: EdgeInsets.all(4),
                                              child: Column(children: [
                                                Container(
                                                  width: 60,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              60),
                                                      border: Border.all(
                                                          color: Colors.black,
                                                          width: 1)),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            60),
                                                    child: Image.network(
                                                      listSubCategoris[index]
                                                          .image,
                                                      fit: BoxFit.fill,
                                                      height: 60,
                                                      width: 60,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 4,
                                                ),
                                                Text(
                                                    listSubCategoris[index]
                                                        .name,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w900)),
                                              ]),
                                            ),
                                          );
                                        }
                                      },
                                    )
                                  : ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: listSubCategoris.length,
                                      itemBuilder: (context, index) {
                                        if (listSubCategoris.isEmpty) {
                                          return const EmptyOrAlert(
                                              empty: true);
                                        } else {
                                          return GestureDetector(
                                            onTap: () {
                                              homeUserCubit
                                                  .GetProductsbycatogorysubcategory(
                                                      listCategoris[0].id,
                                                      listSubCategoris[index]
                                                          .id);
                                            },
                                            child: Container(
                                              margin: EdgeInsets.all(4),
                                              child: Column(children: [
                                                Container(
                                                  width: 60,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              60),
                                                      border: Border.all(
                                                          color: Colors.black,
                                                          width: 1)),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            60),
                                                    child: Image.network(
                                                      listSubCategoris[index]
                                                          .image,
                                                      fit: BoxFit.fill,
                                                      height: 60,
                                                      width: 60,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 4,
                                                ),
                                                Text(
                                                    listSubCategoris[index]
                                                        .name,
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w900)),
                                              ]),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                            ),
                          ],
                        ),
                      ],
                    );
                  } else if (state is HomeUserProductsSuc) {
                    return Column(
                      children: [
                        Container(
                          height: 90,
                          color: FbColors.primaryColor,
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 4,
                              ),
                              Search(),
                              const SizedBox(
                                height: 12,
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Categories",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        isGridView =
                                            !isGridView; // Toggle between views
                                      });
                                    },
                                    child: Text(isGridView
                                        ? "View as List"
                                        : "View All"),
                                  ),
                                ),
                              ],
                            ),

                            // Animated Container
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              height: isGridView
                                  ? ((listCategoris.length + 3) ~/ 4) * 100
                                  : 100, // Adjust height for smooth transition
                              child: isGridView
                                  ? GridView.builder(
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4, // Number of columns
                                        crossAxisSpacing: 2,
                                        mainAxisSpacing: 2,
                                      ),
                                      itemCount: listCategoris.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            homeUserCubit.fetchSubCategories(
                                                listCategoris[index].id);
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.all(4),
                                            child: Column(children: [
                                              Container(
                                                width: 60,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            60),
                                                    border: Border.all(
                                                        color: Colors.black,
                                                        width: 1)),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(60),
                                                  child: Image.network(
                                                    listCategoris[index].image,
                                                    fit: BoxFit.fill,
                                                    height: 60,
                                                    width: 60,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 4,
                                              ),
                                              Text(listCategoris[index].name,
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w900)),
                                            ]),
                                          ),
                                        );
                                      },
                                    )
                                  : ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: listCategoris.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            homeUserCubit.fetchSubCategories(
                                                listCategoris[index].id);
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                left: 14,
                                                right: 14,
                                                top: 4,
                                                bottom: 4),
                                            child: Column(children: [
                                              Container(
                                                width: 60,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            60),
                                                    border: Border.all(
                                                        color: Colors.black,
                                                        width: 1)),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(60),
                                                  child: Image.network(
                                                    listCategoris[index].image,
                                                    fit: BoxFit.fill,
                                                    height: 60,
                                                    width: 60,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              Text(listCategoris[index].name,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w900)),
                                            ]),
                                          ),
                                        );
                                      },
                                    ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Sub Categories",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        isGridViewSubCategory =
                                            !isGridViewSubCategory; // Toggle between views
                                      });
                                    },
                                    child: Text(isGridViewSubCategory
                                        ? "View as List"
                                        : "View All"),
                                  ),
                                ),
                              ],
                            ),

                            // Animated Container
                            AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              height: isGridViewSubCategory
                                  ? ((listSubCategoris.length + 3) ~/ 4) * 100
                                  : 100, // Adjust height for smooth transition
                              child: isGridViewSubCategory
                                  ? GridView.builder(
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4, // Number of columns
                                        crossAxisSpacing: 2,
                                        mainAxisSpacing: 2,
                                      ),
                                      itemCount: listSubCategoris.length,
                                      itemBuilder: (context, index) {
                                        if (listCategoris.isEmpty) {
                                          return const EmptyOrAlert(
                                              empty: true);
                                        } else {
                                          return GestureDetector(
                                            onTap: () {
                                              homeUserCubit
                                                  .GetProductsbycatogorysubcategory(
                                                      listCategoris[0].id,
                                                      listSubCategoris[index]
                                                          .id);
                                            },
                                            child: Container(
                                              margin: EdgeInsets.all(4),
                                              child: Column(children: [
                                                Container(
                                                  width: 60,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              60),
                                                      border: Border.all(
                                                          color: Colors.black,
                                                          width: 1)),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            60),
                                                    child: Image.network(
                                                      listSubCategoris[index]
                                                          .image,
                                                      fit: BoxFit.fill,
                                                      height: 60,
                                                      width: 60,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 4,
                                                ),
                                                Text(
                                                    listSubCategoris[index]
                                                        .name,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w900)),
                                              ]),
                                            ),
                                          );
                                        }
                                      },
                                    )
                                  : ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: listSubCategoris.length,
                                      itemBuilder: (context, index) {
                                        if (listSubCategoris.isEmpty) {
                                          return const EmptyOrAlert(
                                              empty: true);
                                        } else {
                                          return GestureDetector(
                                            onTap: () {
                                              homeUserCubit
                                                  .GetProductsbycatogorysubcategory(
                                                      listCategoris[0].id,
                                                      listSubCategoris[index]
                                                          .id);
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.all(4),
                                              child: Column(children: [
                                                Container(
                                                  width: 60,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              60),
                                                      border: Border.all(
                                                          color: Colors.black,
                                                          width: 1)),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            60),
                                                    child: Image.network(
                                                      listSubCategoris[index]
                                                          .image,
                                                      fit: BoxFit.fill,
                                                      height: 60,
                                                      width: 60,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 4,
                                                ),
                                                Text(
                                                    listSubCategoris[index]
                                                        .name,
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w900)),
                                              ]),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: GridView.builder(
                            itemCount: listProducts.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 8.0,
                              crossAxisSpacing: 8.0,
                              childAspectRatio:
                                  1.0, // Ensures a square grid item, adjust as needed
                            ),
                            itemBuilder: (context, index) {
                              if (listProducts.isEmpty) {
                                return EmptyOrAlert(empty: true);
                              } else {
                                return GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return DropdownDialog(
                                            listProducts[index],
                                            cartCubit,
                                            userId,
                                            homeUserCubit,
                                            sellerId!);
                                      },
                                    );
                                  },
                                  child: SizedBox(
                                    height:
                                        100, // Set the desired height for the grid item
                                    child: Card(
                                      child: Stack(
                                        children: [
                                          Container(
                                            height: 110,
                                            alignment: Alignment.center,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  height: 70,
                                                  width: 70,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: Image.network(
                                                      listProducts[index].image,
                                                      fit: BoxFit.fitHeight,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  listProducts[index].name,
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                                Text(
                                                  listProducts[index]
                                                      .price
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Positioned(
                                            top: 0,
                                            right: 0,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                              decoration: const BoxDecoration(
                                                color: Colors.green,
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(10),
                                                  topRight: Radius.circular(10),
                                                ),
                                              ),
                                              child: Text(
                                                listProducts[index]
                                                    .price
                                                    .toString(),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        )
                      ],
                    );
                  } else if (state is HomeUserProductsFail) {
                    return Container(
                      child: Center(
                        child: ErrorWidget(state.error),
                      ),
                    );
                  } else if (state is UserOrderLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is UserOrderSuccess) {
                    return Expanded(
                        child: ListView.builder(
                            itemCount: orderlist.length,
                            itemBuilder: (context, intex) {
                              return OrderItemWidget(orderlist[intex], true);
                            }));
                  } else if (state is UserOrderFail) {
                    return Center(
                      child: ErrorWidget("error"),
                    );
                  } else {
                    return Container(
                      child: Center(
                        child: ErrorWidget("error"),
                      ),
                    );
                  }
                },
              ),
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
