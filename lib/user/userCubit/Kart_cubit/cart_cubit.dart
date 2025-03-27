import 'dart:async';
import 'dart:convert';
import 'package:fastbuy/service/get_serverkey.dart';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../admin/adminModels/addProductModel/addproduct.dart';
import '../../../common/SentNotification.dart';
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
        final CartList = querysnapshots.docs
            .map((doc) =>
                CartModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList();

        emit(CartSuccess(CartList));
      });
    } catch (e) {
      emit(CartFail(e.toString()));
    }
  }

  Future<void> getCartByUserIdAndClear(String userId) async {
    emit(CartLoading());
    try {
      // Fetch and clear the cart items
      final querySnapshot = await FirebaseFirestore.instance
          .collection("cart")
          .where('userId', isEqualTo: userId)
          .get();

      // Loop through the documents and delete them
      for (var doc in querySnapshot.docs) {
        await FirebaseFirestore.instance
            .collection("cart")
            .doc(doc.id)
            .delete();
      }

      // Emit CartSuccess with an empty list (cart is now cleared)
      emit(CartSuccess([]));
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
      String userId, Product product, String price, String quantity) async {
    try {
      final firestore = FirebaseFirestore.instance.collection("cart").add({
        "product": product.toMap(),
        "price": price,
        "quantity": quantity,
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

    // Replace with your FCM server key
    final url =
        'https://fcm.googleapis.com/v1/projects/fastbuy-55678/messages:send';

    // Add order to Firestore
    try {
      String? title;
      String? payloadbody;

      DocumentReference docRef = await FirebaseFirestore.instance
          .collection('orders')
          .add(order.toMap());

      OrderModel ordermodel = OrderModel(
          id: docRef.id,
          userId: order.userId,
          marchantId: order.kartModel[0].product.userId,
          kartModel: order.kartModel,
          totalPrice: order.totalPrice,
          discount: 00,
          finalPrice: 00,
          status: "Pending",
          createdAt: DateTime.timestamp().toString(),
          updatedAt: DateTime.timestamp().toString());
      SentNotifications sentNotifications =
          SentNotifications(order.kartModel[0].product.userId, ordermodel);
      sentNotifications.sentNotification(title, payloadbody);

      emit(CartSuccess(listCartUser));
    } catch (e) {
      emit(BookingIsFailed());
      print('Failed to add order to Firestore: $e');
    }
  }

  Future<void> saveNotificationToFirestore(OrderModel order) async {
    await FirebaseFirestore.instance.collection('notifications').add({
      'orderId': order.id,
      'buyyerId': order.userId,
      'sellerId': order.kartModel[0].product.userId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
