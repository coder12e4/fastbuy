import 'package:fastbuy/admin/adminModels/addProductModel/addproduct.dart';
import 'package:fastbuy/user/Models/Cartmodel.dart';
import 'package:fastbuy/user/userCubit/Kart_cubit/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartPage extends StatefulWidget {
  final String userId;
  const CartPage({super.key, required this.userId});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late CartCubit cartCubit;
  List<Product> products = [];
  double price = 0.0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cartCubit = CartCubit();
    cartCubit.getCartByuserId(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: BlocProvider<CartCubit>(
        create: (context) => cartCubit,
        child: BlocListener<CartCubit, CartState>(
          bloc: cartCubit,
          listener: (context, state) {
            if (state is CartInitial) {
            } else if (state is CartLoading) {
            } else if (state is CartSuccess) {
              for (int i = 0; i < state.listCartUser.length; i++) {
                products.add(state.listCartUser[i].product);
                price += price + double.parse(state.listCartUser[i].price);
              }
            } else if (state is CartFail) {}
          },
          child: BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              if (state is CartInitial) {
                return Container();
              } else if (state is CartLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is CartSuccess) {
                return Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: state.listCartUser.length,
                          itemBuilder: (ctx, i) {
                            CartModel model = state.listCartUser[i];
                            return ListTile(
                              leading: Image.network(model.product.image),
                              title: Text(model.product.id),
                              subtitle: Text(model.quantity.toString()),
                              trailing: IconButton(
                                icon: const Icon(Icons.remove_shopping_cart),
                                onPressed: () {
                                  cartCubit.deleteFromKart(
                                      widget.userId, model.productId);
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(14),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () {
                                OrderModel ordermodel = OrderModel(
                                    id: "",
                                    userId: widget.userId,
                                    products: products,
                                    totalPrice: price,
                                    discount: 00,
                                    finalPrice: 00,
                                    status: "oredred",
                                    createdAt: DateTime.timestamp(),
                                    updatedAt: DateTime.timestamp());

                                cartCubit
                                    .addOrderAndSendNotification(ordermodel);
                              },
                              child: Text(
                                "Order Now",
                                style: Theme.of(context).textTheme.bodyMedium,
                              )),
                        ),
                      ),
                    ],
                  ),
                );
              } else if (state is CartFail) {
                return Container(
                  child: ErrorWidget(state.error),
                );
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }
}
