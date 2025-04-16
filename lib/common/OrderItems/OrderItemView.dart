import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../admin/adminModels/addProductModel/addproduct.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider<OrderItemCubit>(
          create: (context) => orderItemCubit,
        ),
      ],
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
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
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
                  BlocBuilder<OrderItemCubit, OrderItemState>(
                    bloc: orderItemCubit,
                    builder: (context, state) {
                      if (state is OrderItemInitial) {
                        return const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [SizedBox()],
                        );
                      } else if (state is OrderPending) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                              false);
                                        });
                                      },
                                    ),
                                  ),
                          ],
                        );
                      } else if (state is OrderItemPacked) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                              false);
                                        });
                                      },
                                    ),
                                  ),
                          ],
                        );
                      } else if (state is OrderItemIDelivered) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                          ],
                        );
                      } else if (state is OrderItemReceived) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            widget.Isuser
                                ? Text('Order Status: ${widget.order.status}')
                                : Text('Order Status: ${widget.order.status}'),
                          ],
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
                  const Text(
                    'Products:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${product.product.name} (\$${product.product.price.toStringAsFixed(2)})',
                                style: const TextStyle(fontSize: 14),
                              ),
                              Text(
                                'Price:  (\$${product.product.price.toStringAsFixed(2)})',
                                style: const TextStyle(fontSize: 14),
                              ),
                              Text(
                                'Quantity: ${product.quantity}',
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
          )),
    );
  }
}
