import 'package:fastbuy/admin/add_products.dart';
import 'package:fastbuy/admin/cubit/auth_cubit.dart';
import 'package:fastbuy/admin/cubit/homeAdmin/home_admin_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../adminModels/addProductModel/addproduct.dart';
import '../../cubit/addProducts/productCubit.dart';
import '../../cubit/addProducts/subcategorycubit.dart';
import '../products/categorypage.dart';

class Homepageadmin extends StatefulWidget {
  const Homepageadmin({super.key});
  @override
  State<Homepageadmin> createState() => _HomepageadminState();
}

class _HomepageadminState extends State<Homepageadmin> {
  late HomeAdminCubit adminCubit;
  late String? userId;
  late List<Product?> products;
  late List<Category> categories;

  void getData(BuildContext context) async {
    try {
      userId = await context.read<AuthCubit>().getUserId();
      print(userId);
      adminCubit.getCategories(userId!);
    } catch (e) {
      print(e);
    }
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
      ],
      child: Scaffold(
        body: BlocProvider<HomeAdminCubit>(
          create: (context) => HomeAdminCubit(),
          child: BlocListener<HomeAdminCubit, HomeAdminState>(
            bloc: adminCubit,
            listener: (context, state) {
              if (state is HomeAdminInitial) {
              } else if (state is HomeAdminLoading) {
              } else if (state is HomeAdminSuccess) {
                products = state.products;
                categories = state.categories;
              } else if (state is HomeAdminFailed) {}
            },
            child: BlocBuilder<HomeAdminCubit, HomeAdminState>(
              bloc: adminCubit,
              builder: (context, state) {
                if (state is HomeAdminInitial) {
                  return Container(
                    child: Text("initial"),
                  );
                } else if (state is HomeAdminLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is HomeAdminSuccess) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 40,
                      ),
                      Container(
                        margin: EdgeInsets.all(8),
                        child: TextField(),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20, left: 10, right: 10),
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
                                    margin:
                                        EdgeInsets.only(bottom: 4, right: 10),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(60),
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Colors.blueAccent, width: 1),
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      size: 24,
                                    ),
                                  ),
                                ),
                                Text(
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
                                  print(categories.length);
                                  return Column(
                                    children: [
                                      Container(
                                        height: 60,
                                        width: 60,
                                        margin: EdgeInsets.only(
                                            bottom: 4, right: 10),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(60),
                                          color: Colors.white,
                                          border: Border.all(
                                              color: Colors.blueAccent,
                                              width: 1),
                                        ),
                                        child: Container(),
                                      ),
                                      Text(
                                        categories[intex].name,
                                        style: TextStyle(color: Colors.black),
                                      )
                                    ],
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                } else if (state is HomeAdminFailed) {
                  return Center(
                    child: Text("Failed"),
                  );
                } else {
                  return Center(
                    child: Text("Failed"),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
