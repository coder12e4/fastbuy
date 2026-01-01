import 'package:googleapis_auth/auth_io.dart';

class Serverkey {
  Future<String> getServerToken() async {
    final scope = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
    ];
    final client = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson({
          "type": "service_account",
          "project_id": "fastbuy-55678",
          "private_key_id": "1f037dce6fd0c8d309f109e0c4b43e6b7d58fc67",
          "client_email":
              "firebase-adminsdk-unecu@fastbuy-55678.iam.gserviceaccount.com",
          "client_id": "102073287884641063610",
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://oauth2.googleapis.com/token",
          "auth_provider_x509_cert_url":
              "https://www.googleapis.com/oauth2/v1/certs",
          "client_x509_cert_url":
              "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-unecu%40fastbuy-55678.iam.gserviceaccount.com",
          "universe_domain": "googleapis.com"
        }),
        scope);

    final accesskey = client.credentials.accessToken.data;

    return accesskey;
  }
}
