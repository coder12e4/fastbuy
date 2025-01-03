import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../admin/adminModels/addProductModel/addproduct.dart'; // For formatting dates

class OrderItemWidget extends StatelessWidget {
  final OrderModel order;
  OrderItemWidget({required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order ID: ${order.id}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8.0),
            Text(
                'Total Price: \$${order.products.fold(0, (sum, products) => sum + products.price.round())}'),
            Text('Discount: \$${order.discount.toStringAsFixed(2)}'),
            Text('Final Price: \$${order.finalPrice.toStringAsFixed(2)}'),
            Text('Status: ${order.status}'),
            Text('Created At: ${DateFormat.yMMMd().format(order.createdAt)}'),
            Text('Updated At: ${DateFormat.yMMMd().format(order.updatedAt)}'),
            SizedBox(height: 8.0),
            Text(
              'Products:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            Column(
              children: order.products.map((product) {
                return Row(
                  children: [
                    // Display product image
                    Image.network(
                      product.image,
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        '${product.name} (\$${product.price.toStringAsFixed(2)})',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
