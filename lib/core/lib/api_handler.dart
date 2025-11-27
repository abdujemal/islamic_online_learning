import "dart:convert";
import "dart:io";

import "package:connectivity_plus/connectivity_plus.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:http/http.dart" as http;
import "package:islamic_online_learning/core/constants.dart";
import "package:islamic_online_learning/features/auth/view/pages/register_page.dart";
import "package:islamic_online_learning/features/main/presentation/pages/main_page.dart";

final storage = const FlutterSecureStorage();

Future<http.Response> customGetRequest(String url,
    {bool authorized = false}) async {
  print("GET ${Uri.parse(url)}");
  final connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult.contains(ConnectivityResult.none)) {
    throw ConnectivityException("እባክዎ ኢንተርኔት ያብሩ!");
  }

  final token = await getAccessToken();

  call() => http.get(
        Uri.parse(url),
        headers: {
          if (authorized) ...{
            "authorization": "$token",
          }
        },
      );

  var response = await call();

  if (authorized) {
    if (response.statusCode == 401 && response.body.contains("auth")) {
      // try refresh
      final r = await refreshToken();
      if (r['ok'] == true) {
        // retry
        // token = await getAccessToken();
        response = await call();
      } else {
        // cannot refresh: logout
        // await auth.logout();
        throw Exception("logout");
      }
    }
    return response;
  }

  final parsed = jsonDecode(response.body);
  print(parsed);

  print("res body ${response.body}");

  return response;
}

Future<http.Response> customPostRequest(String url, Map<String, dynamic>? map,
    {bool authorized = false}) async {
  final connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult.contains(ConnectivityResult.none)) {
    throw ConnectivityException("እባክዎ ኢንተርኔት ያብሩ!");
  }
  print("POST $url");
  print("req body $map");

  final token = await getAccessToken();

  call() => http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          if (authorized) ...{
            "authorization": "$token",
          }
        },
        body: map != null ? jsonEncode(map) : null,
      );

  var response = await call();

  if (authorized) {
    if (response.statusCode == 401 && response.body.contains("auth")) {
      // try refresh
      final r = await refreshToken();
      if (r['ok'] == true) {
        // retry
        // token = await getAccessToken();
        response = await call();
      } else {
        // cannot refresh: logout
        // await auth.logout();
        throw Exception("logout");
      }
    }
    return response;
  }

  print("res body ${response.body}");

  return response;
}

Future<http.StreamedResponse> customPostWithForm(
    String url, Map<String, dynamic>? map, File file,
    {bool authorized = false}) async {
  var uri = Uri.parse(url);
  print("POST $url");
  print("req body $map");
  if (!file.existsSync()) {
    print("⚠️ File not found: ${file.path}");
    throw Exception("File does not exist");
  }

  var request = http.MultipartRequest('POST', uri);
  if (map != null) {
    for (var kv in map.entries) {
      request.fields[kv.key] = kv.value;
    }
  }
  request.files.add(await http.MultipartFile.fromPath('file', file.path));

  // Optionally add headers (e.g., if your API needs auth)
  if (authorized) {
    final token = await getAccessToken();
    if (token == null) throw Exception("Token is null");
    request.headers['Authorization'] = token;
  }

  // Send request
  final res = await request.send();

  return res;

  // if (response.statusCode == 200 || response.statusCode == 201) {
  //   print('✅ Upload successful!');
  //   return true;
  // } else {
  //   print('❌ Upload failed with status: ${response.statusCode}');
  //   final respStr = await response.stream.bytesToString();
  //   print('Server response: $respStr');
  //   return false;
  // }
}

Future<String?> getAccessToken() async {
  final token = await storage.read(key: 'access_token');
  final refreshToken = await storage.read(key: "refresh_token");
  print("token: $token");
  print("refreshToken: $refreshToken");
  return token;
}

Future<void> deleteTokens() async {
  await storage.delete(key: "access_token");
  await storage.delete(key: "refresh_token");
}

Future<void> logout(BuildContext context) async {
  await deleteTokens();
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (_) => MainPage()),
    (_) => false,
  );
}

class ConnectivityException extends HttpException {
  ConnectivityException(super.message);
}

class AuthException extends HttpException {
  AuthException(super.message);
}

class PaymentException extends HttpException {
  PaymentException(super.message);
}

Future<void> handleError(
    String err, BuildContext context, VoidCallback action) async {
  if (err.contains("refresh_token")) {
    await logout(context);
  } else if (err.contains("your_account_is_blocked")) {
    await logout(context);
  } else if (err.contains("your_account_is_blocked")) {
    await logout(context);
  } else if (err.contains("no_refresh")) {
    await logout(context);
  } else if (err.contains("user_not_found")) {
    await logout(context);
  } else if (err.contains("logout")) {
    await logout(context);
  }
  action();
}

Future<Map<String, dynamic>> refreshToken() async {
  final refresh = await storage.read(key: 'refresh_token');
  final phone = await storage.read(key: "phone");
  if (refresh == null) return {'ok': false, 'error': 'no_refresh'};
  final res = await customPostRequest(
    refreshTokenApi,
    {
      "refreshToken": refresh,
      "phone": phone,
    },
  );
  final body = jsonDecode(res.body);
  final data = body["data"];
  if (data['ok'] == true &&
      data['token'] != null &&
      data['refreshToken'] != null) {
    await storage.write(key: 'access_token', value: "Bearer ${data['token']}");
    await storage.write(key: 'refresh_token', value: data['refreshToken']);
  }
  return body;
}
