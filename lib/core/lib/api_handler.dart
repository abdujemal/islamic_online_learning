import "dart:convert";
import "dart:io";

import "package:connectivity_plus/connectivity_plus.dart";
import "package:http/http.dart" as http;
import "package:islamic_online_learning/core/lib/pref_consts.dart";
import "package:shared_preferences/shared_preferences.dart";

Future<http.Response> customGetRequest(String url,
    {bool authorized = false}) async {
  print("GET $url");
  final connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult.contains(ConnectivityResult.none)) {
    throw ConnectivityException("እባክዎ ኢንተርኔት ያብሩ!");
  }

  final token = await getToken();

  return http.get(
    Uri.parse(url),
    headers: {
      if (authorized) ...{
        "authorization": "$token",
      }
    },
  );
}

Future<http.Response> customPostRequest(String url, Map<String, dynamic> map,
    {bool authorized = false}) async {
  print("POST $url");
  print("res body $map");

  final token = await getToken();

  return http.post(
    Uri.parse(url),
    headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      if (authorized) ...{
        "authorization": "$token",
      }
    },
    body: jsonEncode(map),
  );
}

Future<String?> getToken() async {
  final pref = await SharedPreferences.getInstance();
  final token = pref.getString(PrefConsts.token);
  return token;
}

class ConnectivityException extends HttpException {
  ConnectivityException(super.message);
}
