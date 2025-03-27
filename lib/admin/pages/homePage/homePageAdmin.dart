import 'package:fastbuy/admin/cubit/homeAdmin/home_admin_cubit.dart';
import 'package:fastbuy/common/OrderItems/order_item_cubit.dart';
import 'package:fastbuy/core/constants.dart';
import 'package:fastbuy/core/widgets/emptyoralert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../user/pages/loginpage.dart';
import '../../../common/OrderItems/OrderItemView.dart';
import '../../adminModels/addProductModel/addproduct.dart';
import '../../cubit/addProducts/productCubit/product_cubit.dart';
import '../../cubit/addProducts/subCategoryCubit/subcategory_cubit.dart';
import '../products/categorypage.dart';

class Homepageadmin extends StatefulWidget {
  final String userId;
  const Homepageadmin({super.key, required this.userId});
  @override
  State<Homepageadmin> createState() => _HomepageadminState();
}

class _HomepageadminState extends State<Homepageadmin> {
  late HomeAdminCubit adminCubit;
  late String? userId;
  late List<Product?> products = [];
  late List<Category> categories = [];
  List<Subcategory> subcategories = [];
  int _selectedIndex = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<OrderModel> orderlist = [];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (_selectedIndex == 1) {
      adminCubit.fetchOrdersByUserId(userId!);
    } else {
      getData(context);
      /*    adminCubit.fetchCategories(sellerId!, userId);
       adminCubit.getCartByuserId(userId);
   */
    }
  }

  void getData(BuildContext context) async {
    try {
      userId = widget.userId;

      adminCubit.getCategories(userId!);
    } catch (e) {}
  }

  final TextEditingController _searchController = TextEditingController();
  Widget Search() {
    return Row(
      children: [
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: TextField(
            style: const TextStyle(fontSize: 14, color: Colors.black),
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                adminCubit.loadProductsformSearch(value, userId);
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
                borderSide: BorderSide(color: FbColors.primaryColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: FbColors.primaryColor),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.red),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.green),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 10,
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
  void initState() {
    adminCubit = HomeAdminCubit();
    getData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SubcategoryCubit()),
        BlocProvider(create: (context) => ProductCubit()),
        BlocProvider(create: (context) => OrderItemCubit()),
      ],
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
                  child: Text(
                    "Fast Buy",
                    style: TextTheme.of(context).titleMedium,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 40,
                        height: 60,
                      ),
                      Icon(Icons.person),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Profile")
                    ],
                  ),
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: FbColors.primaryColor,
                ),
                GestureDetector(
                  onTap: () {
                    /*   homeUserCubit.logout().then((t) => Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (c) => Login())));
                 */
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 40,
                        height: 60,
                      ),
                      Icon(Icons.settings),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Settings")
                    ],
                  ),
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: FbColors.primaryColor,
                ),
                GestureDetector(
                  onTap: () {
                    adminCubit.logout().then((t) => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (c) => const Login())));
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 40,
                        height: 60,
                      ),
                      Icon(Icons.logout),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Logout")
                    ],
                  ),
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: FbColors.primaryColor,
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
                const Text(
                  "Hi",
                  style: TextStyle(
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
                          /*  Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CartPage(
                                userId: userId,
                              ),
                            ),
                          );
                        */
                        },
                      ),
                      /*    Positioned(
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
                                        style: TextStyle(
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
                  */
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.store),
                label: 'Store',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.drive_eta_sharp),
                label: 'Orders',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history_edu),
                label: 'Deliverys',
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
          body: BlocProvider<HomeAdminCubit>(
            create: (context) => HomeAdminCubit(),
            child: BlocListener<HomeAdminCubit, HomeAdminState>(
              bloc: adminCubit,
              listener: (context, state) {
                if (state is HomeAdminInitial) {
                } else if (state is HomeAdminLoading) {
                } else if (state is HomeAdminSuccess) {
                  categories = state.categories;
                } else if (state is HomeAdminFailed) {
                } else if (state is LoadSubcategorisLoding) {
                } else if (state is LoadSubcategorisSuccess) {
                  subcategories.clear();
                  subcategories = state.subcategory;
                } else if (state is LoadProductsLoading) {
                } else if (state is LoadProductsSuccess) {
                  products.clear();
                  products = state.productList;
                } else if (state is LoadProductsFailed) {
                } else if (state is OrderListLoading) {
                } else if (state is OrderListSuccess) {
                  orderlist.clear();
                  orderlist = state.orderlist;
                } else if (state is OrderListFail) {}
              },
              child: BlocBuilder<HomeAdminCubit, HomeAdminState>(
                bloc: adminCubit,
                builder: (context, state) {
                  if (state is HomeAdminInitial) {
                    return const Text("initial");
                  } else if (state is HomeAdminLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is HomeAdminSuccess) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Search(),
                        const SizedBox(
                          height: 8,
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Categories",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              top: 8, left: 10, right: 10),
                          height: 80,
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CategoryPage(userId!)));
                                    },
                                    child: Container(
                                      height: 60,
                                      width: 60,
                                      margin: const EdgeInsets.only(
                                          bottom: 4, right: 10),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(60),
                                        color: Colors.white,
                                        border: Border.all(
                                            color: Colors.green, width: 1),
                                      ),
                                      child: const Icon(
                                        Icons.add,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    "Add new",
                                    style: TextStyle(color: Colors.black),
                                  )
                                ],
                              ),
                              Expanded(
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: categories.length,
                                  itemBuilder: (context, intex) {
                                    return GestureDetector(
                                      onTap: () {
                                        adminCubit.getSubcategoris(
                                            userId!, categories[intex].id);
                                      },
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 60,
                                            width: 60,
                                            padding: const EdgeInsets.all(4),
                                            margin: const EdgeInsets.only(
                                                bottom: 4, right: 10),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(60),
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.green,
                                                  width: 1),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(60)),
                                              child: Image.network(
                                                  categories[intex].image),
                                            ),
                                          ),
                                          Text(
                                            categories[intex].name,
                                            style: const TextStyle(
                                                color: Colors.black),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Subcategories",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              top: 8, left: 10, right: 10),
                          height: 80,
                          child: Row(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: subcategories.length,
                                  itemBuilder: (context, intex) {
                                    return GestureDetector(
                                      onTap: () {
                                        adminCubit.getSubcategoris(userId!,
                                            subcategories[intex].categoryId);
                                      },
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 60,
                                            width: 60,
                                            padding: const EdgeInsets.all(4),
                                            margin: const EdgeInsets.only(
                                                bottom: 4, right: 10),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(60),
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.green,
                                                  width: 1),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(60)),
                                              child: Image.network(
                                                  subcategories[intex].image),
                                            ),
                                          ),
                                          Text(
                                            subcategories[intex].name,
                                            style: const TextStyle(
                                                color: Colors.black),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  } else if (state is LoadSubcategorisLoding) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Search(),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Categories",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              top: 10, left: 10, right: 10),
                          height: 80,
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CategoryPage(userId!)));
                                    },
                                    child: Container(
                                      height: 60,
                                      width: 60,
                                      margin: const EdgeInsets.only(
                                          bottom: 4, right: 10),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(60),
                                        color: Colors.white,
                                        border: Border.all(
                                            color: Colors.green, width: 1),
                                      ),
                                      child: const Icon(
                                        Icons.add,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    "Add new",
                                    style: TextStyle(color: Colors.black),
                                  )
                                ],
                              ),
                              Expanded(
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: categories.length,
                                  itemBuilder: (context, intex) {
                                    return GestureDetector(
                                      onTap: () {
                                        adminCubit.getSubcategoris(
                                            userId!, categories[intex].id);
                                      },
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 60,
                                            width: 60,
                                            padding: const EdgeInsets.all(4),
                                            margin: const EdgeInsets.only(
                                                bottom: 4, right: 10),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(60),
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.green,
                                                  width: 1),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(60)),
                                              child: Image.network(
                                                  categories[intex].image),
                                            ),
                                          ),
                                          Text(
                                            categories[intex].name,
                                            style: const TextStyle(
                                                color: Colors.black),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Subcategories",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 80,
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                color: Colors.green,
                              )
                            ],
                          ),
                        )
                      ],
                    );
                  } else if (state is LoadSubcategorisSuccess) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Search(),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Categories",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              top: 10, left: 10, right: 10),
                          height: 80,
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CategoryPage(userId!)));
                                    },
                                    child: Container(
                                      height: 60,
                                      width: 60,
                                      margin: const EdgeInsets.only(
                                          bottom: 4, right: 10),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(60),
                                        color: Colors.white,
                                        border: Border.all(
                                            color: Colors.green, width: 1),
                                      ),
                                      child: const Icon(
                                        Icons.add,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    "Add new",
                                    style: TextStyle(color: Colors.black),
                                  )
                                ],
                              ),
                              Expanded(
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: categories.length,
                                  itemBuilder: (context, intex) {
                                    return GestureDetector(
                                      onTap: () {
                                        adminCubit.getSubcategoris(
                                            userId!, categories[intex].id);
                                      },
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 60,
                                            width: 60,
                                            padding: const EdgeInsets.all(4),
                                            margin: const EdgeInsets.only(
                                                bottom: 4, right: 10),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(60),
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.green,
                                                  width: 1),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(60)),
                                              child: Image.network(
                                                  categories[intex].image),
                                            ),
                                          ),
                                          Text(
                                            categories[intex].name,
                                            style: const TextStyle(
                                                color: Colors.black),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Subcategories",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              top: 10, left: 10, right: 10, bottom: 10),
                          height: 80,
                          child: Row(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: subcategories.length,
                                  itemBuilder: (context, intex) {
                                    return GestureDetector(
                                      onTap: () {
                                        adminCubit.getProducts(
                                            subcategories[intex].categoryId,
                                            subcategories[intex].id);
                                      },
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 60,
                                            width: 60,
                                            padding: const EdgeInsets.all(4),
                                            margin: const EdgeInsets.only(
                                                bottom: 4, right: 10),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(60),
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.green,
                                                  width: 1),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(60)),
                                              child: Image.network(
                                                  subcategories[intex].image),
                                            ),
                                          ),
                                          Text(
                                            subcategories[intex].name,
                                            style: const TextStyle(
                                                color: Colors.black),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Subcategories",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  } else if (state is HomeAdminFailed) {
                    return const Center(
                      child: Text("Failed"),
                    );
                  } else if (state is LoadProductsLoading) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Search(),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Categories",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              top: 10, left: 10, right: 10),
                          height: 80,
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CategoryPage(userId!)));
                                    },
                                    child: Container(
                                      height: 60,
                                      width: 60,
                                      margin: const EdgeInsets.only(
                                          bottom: 4, right: 10),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(60),
                                        color: Colors.white,
                                        border: Border.all(
                                            color: Colors.green, width: 1),
                                      ),
                                      child: const Icon(
                                        Icons.add,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    "Add new",
                                    style: TextStyle(color: Colors.black),
                                  )
                                ],
                              ),
                              Expanded(
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: categories.length,
                                  itemBuilder: (context, intex) {
                                    return GestureDetector(
                                      onTap: () {
                                        adminCubit.getSubcategoris(
                                            userId!, categories[intex].id);
                                      },
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 60,
                                            width: 60,
                                            padding: const EdgeInsets.all(4),
                                            margin: const EdgeInsets.only(
                                                bottom: 4, right: 10),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(60),
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.green,
                                                  width: 1),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(60)),
                                              child: Image.network(
                                                  categories[intex].image),
                                            ),
                                          ),
                                          Text(
                                            categories[intex].name,
                                            style: const TextStyle(
                                                color: Colors.black),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Subcategories",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              top: 10, left: 10, right: 10, bottom: 10),
                          height: 80,
                          child: Row(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: subcategories.length,
                                  itemBuilder: (context, intex) {
                                    return GestureDetector(
                                      onTap: () {
                                        adminCubit.getSubcategoris(userId!,
                                            subcategories[intex].categoryId);
                                      },
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 60,
                                            width: 60,
                                            padding: const EdgeInsets.all(4),
                                            margin: const EdgeInsets.only(
                                                bottom: 4, right: 10),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(60),
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.green,
                                                  width: 1),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(60)),
                                              child: Image.network(
                                                  subcategories[intex].image),
                                            ),
                                          ),
                                          Text(
                                            subcategories[intex].name,
                                            style: const TextStyle(
                                                color: Colors.black),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Subcategories",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Expanded(
                            child: Center(
                          child: CircularProgressIndicator(),
                        ))
                      ],
                    );
                  } else if (state is LoadProductsSuccess) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Search(),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Categories",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              top: 10, left: 10, right: 10),
                          height: 80,
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CategoryPage(userId!)));
                                    },
                                    child: Container(
                                      height: 60,
                                      width: 60,
                                      margin: const EdgeInsets.only(
                                          bottom: 4, right: 10),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(60),
                                        color: Colors.white,
                                        border: Border.all(
                                            color: Colors.green, width: 1),
                                      ),
                                      child: const Icon(
                                        Icons.add,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    "Add new",
                                    style: TextStyle(color: Colors.black),
                                  )
                                ],
                              ),
                              Expanded(
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: categories.length,
                                  itemBuilder: (context, intex) {
                                    return GestureDetector(
                                      onTap: () {
                                        adminCubit.getSubcategoris(
                                            userId!, categories[intex].id);
                                      },
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 60,
                                            width: 60,
                                            padding: const EdgeInsets.all(4),
                                            margin: const EdgeInsets.only(
                                                bottom: 4, right: 10),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(60),
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.green,
                                                  width: 1),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(60)),
                                              child: Image.network(
                                                  categories[intex].image),
                                            ),
                                          ),
                                          Text(
                                            categories[intex].name,
                                            style: const TextStyle(
                                                color: Colors.black),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Subcategories",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              top: 10, left: 10, right: 10, bottom: 10),
                          height: 80,
                          child: Row(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: subcategories.length,
                                  itemBuilder: (context, intex) {
                                    return GestureDetector(
                                      onTap: () {
                                        adminCubit.getSubcategoris(userId!,
                                            subcategories[intex].categoryId);
                                      },
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 60,
                                            width: 60,
                                            padding: const EdgeInsets.all(4),
                                            margin: const EdgeInsets.only(
                                                bottom: 4, right: 10),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(60),
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.green,
                                                  width: 1),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(60)),
                                              child: Image.network(
                                                  subcategories[intex].image),
                                            ),
                                          ),
                                          Text(
                                            subcategories[intex].name,
                                            style: const TextStyle(
                                                color: Colors.black),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Subcategories",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                            child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, // 3 items per row
                            childAspectRatio:
                                0.75, // Adjust this ratio as needed
                            crossAxisSpacing: 4,
                            mainAxisSpacing: 4,
                          ),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            return SizedBox(
                              width: 100,
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
                                                  const EdgeInsets.all(4.0),
                                              child: Image.network(
                                                products[index]!.image,
                                                fit: BoxFit.fitHeight,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            products[index]!.name,
                                            style: const TextStyle(
                                                color: Colors.black),
                                          ),
                                          Text(
                                            products[index]!.price.toString(),
                                            style: const TextStyle(
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: const BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                          ),
                                        ),
                                        child: Text(
                                          products[index]!.price.toString(),
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
                            );
                          },
                        ))
                      ],
                    );
                  } else if (state is LoadProductsFailed) {
                    return const Center(
                      child: Text('something went wrong while product loading'),
                    );
                  } else if (state is OrderListLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is OrderListSuccess) {
                    return Expanded(
                        child: ListView.builder(
                            itemCount: orderlist.length,
                            itemBuilder: (context, intex) {
                              if (orderlist.isEmpty) {
                                return const EmptyOrAlert(empty: true);
                              } else {
                                return OrderItemWidget(orderlist[intex], false);
                              }
                            }));
                  } else if (state is OrderListFail) {
                    return const Center(
                      child: Text("Error"),
                    );
                  } else {
                    return const Center(
                      child: Text("Failed"),
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
}
