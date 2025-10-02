import "dart:convert";
import "dart:io";

import "package:connectivity_plus/connectivity_plus.dart";
import "package:http/http.dart" as http;

Future<http.Response> customGetRequest(String url) async {
  print("GET $url");
  final connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult.contains(ConnectivityResult.none)) {
    throw ConnectivityException("እባክዎ ኢንተርኔት ያብሩ!");
  }

  return http.get(Uri.parse(url));
}

Future<http.Response> customPostRequest(String url, Map<String, dynamic> map) {
  print("POST $url");
  print("res body $map");

  return http.post(
    Uri.parse(url),
    headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    },
    body: jsonEncode(map),
  );
}

class ConnectivityException extends HttpException {
  ConnectivityException(super.message);
}
