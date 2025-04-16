import 'dart:convert';
import 'package:fastbuy/admin/adminModels/addProductModel/addproduct.dart';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../admin/cubit/homeAdmin/home_admin_cubit.dart';
import '../SentNotification.dart';

part 'order_item_state.dart';

class OrderItemCubit extends Cubit<OrderItemState> {
  OrderItemCubit() : super(OrderItemInitial());

  Future<void> updateOrderStatus(
      String marchantId,
      String orderId,
      String newStatus,
      OrderModel? orderModel,
      String? title,
      String? payloadbody,
      bool isUser) async {
    try {
      String? sellerfcm;

      if (isUser) {
        final documentSnapshot = await FirebaseFirestore.instance
            .collection('users') // Replace with your collection name
            .where("userId", isEqualTo: marchantId)
            .get();
        //kart state must be change
        var sellerDoc = documentSnapshot.docs.first;
        sellerfcm = sellerDoc['selectedSeller']['sellerfcm'];
      } else {
        final documentSnapshot = await FirebaseFirestore.instance
            .collection('users') // Replace with your collection name
            .where("userId", isEqualTo: orderModel!.userId)
            .get();
        //kart state must be change
        var userDoc = documentSnapshot.docs.first;
        sellerfcm = userDoc['userFcm'];
      }

      SentNotifications sentNotifications =
          SentNotifications(marchantId, orderModel, sellerfcm);
      sentNotifications.sentNotification(title, payloadbody);

      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .update({
        'status': newStatus,
        'updatedAt': DateTime.now(), // Optional: track when status changed
      });
      upDateStatus(newStatus);
      print('Order status updated successfully');
    } catch (e) {
      print('Failed to update order status: $e');
    }
  }

  Future<void> upDateStatus(String status) async {
    if (status == 'Pending') {
      emit(OrderPending());
    } else if (status == "Packed") {
      emit(OrderItemPacked());
    } else if (status == "Delivered") {
      emit(OrderItemIDelivered());
    } else if (status == "Received") {
      emit(OrderItemReceived());
    } else {}
  }
}
