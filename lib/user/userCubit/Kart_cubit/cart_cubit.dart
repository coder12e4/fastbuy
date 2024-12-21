import 'dart:async';
import 'dart:convert';
import 'package:fastbuy/service/get_serverkey.dart';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../admin/adminModels/addProductModel/addproduct.dart';
import '../../Models/Cartmodel.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());
  StreamSubscription? _CartSubsription;
  List<CartModel> listCartUser = [];
  int? kartLength;
  Future<void> getCartByuserId(String userId) async {
    emit(CartLoading());
    try {
      _CartSubsription = FirebaseFirestore.instance
          .collection("cart")
          .where('userId', isEqualTo: userId)
          .snapshots()
          .listen((querysnapshots) {
        final categories = querysnapshots.docs
            .map((doc) =>
                CartModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList();
        kartLength = categories.length;
        // Emit CartSuccess state with the list of cart items
        emit(CartSuccess(categories));
      });
    } catch (e) {
      emit(CartFail(e.toString()));
    }
  }

  Future<void> deleteFromKart(String userId, String productId) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection("cart")
          .where('userId', isEqualTo: userId)
          .where("productId", isEqualTo: productId)
          .get();

      for (var doc in querySnapshot.docs) {
        await FirebaseFirestore.instance
            .collection("cart")
            .doc(doc.id)
            .delete();
      }
      // After deletion, re-fetch the cart items
      getCartByuserId(userId);
    } catch (e) {
      emit(CartFail(e.toString()));
    }
  }

  Future<void> addproductToKart(
      String userId, Product product, String price, String count) async {
    try {
      final firestore = FirebaseFirestore.instance.collection("cart").add({
        "product": product.toMap(),
        "price": price,
        "count": count,
        "userId": userId,
        "productId": product.id
      });
      getCartByuserId(userId);
    } catch (e) {}
  }

  Future<String?> getString(String key) async {
    try {
      SharedPreferences value = await SharedPreferences.getInstance();
      return value.getString(key);
    } catch (e) {
      print(e);
      return "";
    }
  }

  Future<void> addOrderAndSendNotification(OrderModel order) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? serverKey = sharedPreferences.getString("serverkey");
    String? fcmToken = sharedPreferences.getString("sellerfcm");
    print("---server key----");
    print(serverKey);
    print("--fcm--");
    print(fcmToken);

    final firestore = FirebaseFirestore.instance;

    // Replace with your FCM server key
    final url =
        'https://fcm.googleapis.com/v1/projects/fastbuy-55678/messages:send';

    // Add order to Firestore
    try {
      await firestore.collection('orders').add(order.toMap());

      if (fcmToken != null) {
        // Prepare headers and body for FCM notification
        final headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $serverKey',
        };

        final body = jsonEncode({
          "message": {
            "token": fcmToken,
            "notification": {
              "title": "Breaking News",
              "body": "New news story available."
            },
            "data": {"story_id": "story_12345"},
            "android": {
              "notification": {"click_action": "TOP_STORY_ACTIVITY"}
            },
            "apns": {
              "payload": {
                "aps": {"category": "NEW_MESSAGE_CATEGORY"}
              }
            }
          }
        });

        // Send FCM notification
        final response =
            await http.post(Uri.parse(url), headers: headers, body: body);

        if (response.statusCode == 200) {
          print('Notification sent to user');
        } else {
          print(response.body);
          print('Failed to send notification');
        }
      } else {
        print('FCM token not found for user ${order.userId}');
      }
    } catch (e) {
      print('Failed to add order to Firestore: $e');
    }
  }
}
