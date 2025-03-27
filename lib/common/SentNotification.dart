import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../admin/adminModels/addProductModel/addproduct.dart';

class SentNotifications {
  String? marchantId;
  OrderModel? orderModel;
  SentNotifications(this.marchantId, this.orderModel);
  final url =
      'https://fcm.googleapis.com/v1/projects/fastbuy-55678/messages:send';

  Future sentNotification(String? title, String? payloadbody) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? serverKey = sharedPreferences.getString("serverkey");
    final documentSnapshot = await FirebaseFirestore.instance
        .collection('sellers') // Replace with your collection name
        .where("userId", isEqualTo: marchantId)
        .get();
    //kart state must be change
    var sellerDoc = documentSnapshot.docs.first;
    String sellerfcm = sellerDoc['sellerfcm'];
    // Prepare headers and body for FCM notification
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $serverKey',
    };

    final body = jsonEncode({
      "message": {
        "token": sellerfcm,
        "notification": {"title": title, "body": payloadbody},
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
      await saveNotificationToFirestore(orderModel!);
      //   await getCartByUserIdAndClear(order.userId);
      print('Notification sent to user');
    } else {
      print(response.body);
      print('Failed to send notification');
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
