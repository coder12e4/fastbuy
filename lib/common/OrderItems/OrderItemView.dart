import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../admin/adminModels/addProductModel/addproduct.dart';
import '../../admin/cubit/homeAdmin/home_admin_cubit.dart';
import '../SentNotification.dart';
import 'order_item_cubit.dart'; // For formatting dates

class OrderItemWidget extends StatefulWidget {
  final OrderModel order;
  final bool Isuser;

  OrderItemWidget(this.order, this.Isuser, {super.key});

  @override
  State<OrderItemWidget> createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  late String selectedStatus;
  late OrderItemCubit orderItemCubit;

  @override
  void initState() {
    orderItemCubit = OrderItemCubit();
    selectedStatus = widget.order.status;
    orderItemCubit.upDateStatus(selectedStatus);
    super.initState();
  }

  late List<String> statusList = [];

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderItemCubit>(
      create: (context) => orderItemCubit,
      child: BlocListener<OrderItemCubit, OrderItemState>(
        bloc: orderItemCubit,
        listener: (context, state) {
          if (state is OrderItemInitial) {
          } else if (state is OrderPending) {
            selectedStatus = 'Pending';
            statusList = ['Pending', 'Packed', "Packed"];
          } else if (state is OrderItemPacked) {
            selectedStatus = 'Packed';
            statusList = [
              'Packed',
              'Delivered',
            ];
          } else if (state is OrderItemIDelivered) {
            selectedStatus = 'Delivered';
            statusList.clear();
            statusList = ['Delivered', 'Received'];
          } else if (state is OrderItemReceived) {
            selectedStatus = 'Delivered';
            statusList.clear();
            statusList = ['Received', 'Delivered'];
          }
        },
        child: BlocBuilder<OrderItemCubit, OrderItemState>(
          bloc: orderItemCubit,
          builder: (context, state) {
            if (state is OrderItemInitial) {
              return Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order Date: ${widget.order.createdAt}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                          'Total Price: \$${widget.order.kartModel.fold(0, (sum, products) => sum + products.product.price.round())}'),
                      Text('Updated At: ${widget.order.updatedAt}'),
                      const SizedBox(height: 8.0),
                      const Text(
                        'Products:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Column(
                        children: widget.order.kartModel.map((product) {
                          return Row(
                            children: [
                              // Display product image
                              Image.network(
                                product.product.image,
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(width: 8.0),
                              Column(
                                children: [
                                  Text(
                                    '${product.product.name} (\$${product.product.price.toStringAsFixed(2)})',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    'Price:  (\$${product.product.price.toStringAsFixed(2)})',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const Text(
                                    'Quantity: ',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              )
                            ],
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is OrderPending) {
              return Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order Date: ${widget.order.createdAt}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                          'Total Price: \$${widget.order.kartModel.fold(0, (sum, products) => sum + products.product.price.round())}'),
                      widget.Isuser
                          ? Text('Order Status: ${widget.order.status}')
                          : Center(
                              child: DropdownButton<String>(
                                value: selectedStatus,
                                items: [
                                  'Pending',
                                  'Packed',
                                ].map((String status) {
                                  return DropdownMenuItem<String>(
                                    value: status,
                                    child: Text(status),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedStatus = newValue!;
                                    orderItemCubit.updateOrderStatus(
                                        widget.order.userId,
                                        widget.order.id,
                                        selectedStatus,
                                        widget.order,
                                        "Fastbuy",
                                        "Your order ${widget.order.id} is Packed from marchant",
                                        true);
                                  });
                                },
                              ),
                            ),
                      Text('Ordered At: ${widget.order.createdAt}'),
                      Text('Updated At: ${widget.order.updatedAt}'),
                      Text('Order Status: ${widget.order.status}'),
                      const SizedBox(height: 8.0),
                      const Text(
                        'Products:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Column(
                        children: widget.order.kartModel.map((product) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                // Display product image
                                Image.network(
                                  product.product.image,
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(width: 8.0),
                                Column(
                                  children: [
                                    Text(
                                      '${product.product.name} (\$${product.product.price.toStringAsFixed(2)})',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is OrderItemPacked) {
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order Date: ${widget.order.createdAt}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                          'Total Price: \$${widget.order.kartModel.fold(0, (sum, products) => sum + products.product.price.round())}'),
                      widget.Isuser
                          ? Text('Order Status: ${widget.order.status}')
                          : Center(
                              child: DropdownButton<String>(
                                value: selectedStatus,
                                items: [
                                  'Packed',
                                  'Delivered',
                                ].map((String status) {
                                  return DropdownMenuItem<String>(
                                    value: status,
                                    child: Text(status),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedStatus = newValue!;
                                    orderItemCubit.updateOrderStatus(
                                        widget.order.userId,
                                        widget.order.id,
                                        selectedStatus,
                                        widget.order,
                                        "Fastbuy",
                                        "Your order ${widget.order.id} is Delivered from marchant",
                                        true);
                                  });
                                },
                              ),
                            ),
                      Text('Ordered At: ${widget.order.createdAt}'),
                      Text('Updated At: ${widget.order.updatedAt}'),
                      const SizedBox(height: 8.0),
                      const Text(
                        'Products:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Column(
                        children: widget.order.kartModel.map((product) {
                          return Row(
                            children: [
                              // Display product image
                              Image.network(
                                product.product.image,
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(width: 8.0),
                              Column(
                                children: [
                                  Text(
                                    '${product.product.name} (\$${product.product.price.toStringAsFixed(2)})',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              )
                            ],
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is OrderItemIDelivered) {
              return Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order Date: ${widget.order.createdAt}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                          'Total Price: \$${widget.order.kartModel.fold(0, (sum, products) => sum + products.product.price.round())}'),
                      widget.Isuser
                          ? Center(
                              child: DropdownButton<String>(
                                value: selectedStatus,
                                items: ['Delivered', 'Received']
                                    .map((String status) {
                                  return DropdownMenuItem<String>(
                                    value: status,
                                    child: Text(status),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedStatus = newValue!;
                                    orderItemCubit.updateOrderStatus(
                                      widget.order.marchantId,
                                      widget.order.id,
                                      newValue,
                                      widget.order,
                                      "Fastbuy",
                                      "order ${widget.order.id} is Received by buyer",
                                      false,
                                    );
                                  });
                                },
                              ),
                            )
                          : Text('Order Status: ${widget.order.status}'),
                      Text('Ordered At: ${widget.order.createdAt}'),
                      Text('Updated At: ${widget.order.updatedAt}'),
                      const SizedBox(height: 8.0),
                      const Text(
                        'Products:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Column(
                        children: widget.order.kartModel.map((product) {
                          return Row(
                            children: [
                              // Display product image
                              Image.network(
                                product.product.image,
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(width: 8.0),
                              Column(
                                children: [
                                  Text(
                                    '${product.product.name} (\$${product.product.price.toStringAsFixed(2)})',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              )
                            ],
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is OrderItemReceived) {
              return Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order Date: ${widget.order.createdAt}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                          'Total Price: \$${widget.order.kartModel.fold(0, (sum, products) => sum + products.product.price.round())}'),
                      Text('Ordered At: ${widget.order.createdAt}'),
                      Text('Updated At: ${widget.order.updatedAt}'),
                      widget.Isuser
                          ? Text('Order Status: ${widget.order.status}')
                          : Text('Order Status: ${widget.order.status}'),
                      const SizedBox(height: 8.0),
                      const Text(
                        'Products:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Column(
                        children: widget.order.kartModel.map((product) {
                          return Row(
                            children: [
                              // Display product image
                              Image.network(
                                product.product.image,
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(width: 8.0),
                              Column(
                                children: [
                                  Text(
                                    '${product.product.name} (\$${product.product.price.toStringAsFixed(2)})',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              )
                            ],
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Container(
                color: Colors.green,
                child: const SizedBox(
                  height: 100,
                  width: 100,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
