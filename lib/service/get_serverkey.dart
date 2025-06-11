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
          "private_key":
              "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCU6iZn+3AHDRf7\nOuJBgHxK+163Ft9/WYvRuRC24Z+LJzGnFFwhHK6bTgGSMjj8JzjwaMtGH8Hj5NJq\n7QsCHZ+Lm4vILI45/lp9/iNI/BFzI4wflsnafg4I9T2I/y07AOG6jYfmiEAuWNRr\nRHy5i8lMIZsUdechR6khdObMHDGb1+PwuBznEFhqHvTBH/1013uD63qnWPDFc6Us\n5QzZ6E+L+ofJbqExK27aQs4IavAA2p4RfoXY8+6UoOFkCk2WfwMxaMpa6nqY10IM\ntAF0rEr+T+RGEs+JUloipbQpsImHT/gelx7BqnwK7HtyLQVRgn436YzgzAGPioDY\nLWGWEPXLAgMBAAECggEAAPCv4UxG9tadR45Ikph62SRYVD48C3V49NXh4FxClkq8\nMZBbY6R+TqHkxF97+81jxlKd9waDTdOKbXdlk0JvcE0p4VtXv8+H+4yozerXrqJf\nDFZfbW2tIdOejih2pcdmyFpVZ0bjN8Hf6Lsajk6dZvgmEzBQSWXpp3+mIZILdCNK\nM4NTGx+Pl56fqXuXHKaQBrbFBJkPTLPiJ9qokN2xCkZiXWP4lGkWFyfTgdheuYtY\n/kojuU2bqY7JTvOeMt6xnAKJHVC+9ZQilzXFmhp1PbhbF/y15dA2z3t8DNmcdIYo\n4WNuSLeVYjJRr9NLI5zK98cYB+/1W01Kwa+nD6UysQKBgQDMiy89ffVlUbcRf6EX\nPR/JoqqEhVqhmSidQRII5F8XHRhvzLQLfkvFiGztA6THu1dM7sY2hTIS3LtxAEbR\n4bTQdNLydv4QKbKeDw+7YHAyEl+hyXbLmRQxTkUG5t8GuT3ZqsOREyWZiNj77FCh\nEk4Ur7GCal7VD/lBjyL/rgZwMQKBgQC6YGZ9UrNo0TwJ/8krMaXIqCaNLUdZz0p4\nxVOynQstQtVvun09WsZ9uHpvooFasS192Zp2pl96iVtiNZNbWDhzmhoG5Bgd9wBQ\nXZi/TvIeYTS9rS+Pv82CFOe6v+ud40KpUfiYwT8M4mIWrUXYXfTq/jYUAUY1+7iV\nKDiwIL6iuwKBgBp8M0O9GZdi+1dytUMzEPik7Xt3YQLnuBCUqmcoWv+9LrrbQLz0\nP492WNRf0mhiY618hYHtwUwb9NFu/byTgzwyxFXM/pzNKWm5/Yl/tUdmhaeHVLCM\nQ8cWoW2BW4OdXNrgd65DUm0NATutn8sbeazICy4d4+WmydmpVRjSSdchAoGALxI5\n0F0awtZVe5EGlcosPMl7MxzEcIJSJL5xrSLMt9mxXk6TYvOSPh5hjeBVGzq0apyS\nznSmmKQoWF1/ogpd95RsDmF9VdQUWDfLZEXkEJgsYdtjr8KZfMka3aerMm07YNg7\nGRl1eyOR8nhAs6zHNrKNpe/Mc8XnkIRgDNu4ShECgYEAgvXTlvTQezAPGqjch/Uw\nkqE5FdbdmzbQjQsSUfeTsRa6nrmHFaD82ZmqCI/TQ66PqFQTfC9PNVJJ3N+1urR8\nSSiijP4I9ctVH4nhaHW3297xFFb0yqYBHEYMgT40Y5oQ3OWhXX6HdE9JcQSZDE3I\nTBLmSSLT2mjQM2LqKDAJMNs=\n-----END PRIVATE KEY-----\n",
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
