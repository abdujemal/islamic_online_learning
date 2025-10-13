import "dart:convert";
import "dart:io";

import "package:connectivity_plus/connectivity_plus.dart";
import "package:http/http.dart" as http;
import "package:islamic_online_learning/core/lib/pref_consts.dart";
import "package:shared_preferences/shared_preferences.dart";

Future<http.Response> customGetRequest(String url,
    {bool authorized = false}) async {
  print("GET ${Uri.parse(url)}");
  final connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult.contains(ConnectivityResult.none)) {
    throw ConnectivityException("እባክዎ ኢንተርኔት ያብሩ!");
  }

  final token = await getToken();

  final response = await http.get(
    Uri.parse(url),
    headers: {
      if (authorized) ...{
        "authorization": "$token",
      }
    },
  );
  final parsed = jsonDecode(response.body);
  print(parsed);
  if (response.statusCode == 403) {
    if (parsed["type"] == "auth") {
      throw AuthException("ይቅርታ መለያዎ ታግድዋል!");
    } else {
      throw PaymentException("ያልተሟላ ከፍያ አሎት!");
    }
  }

  if (response.statusCode == 401) {
    if (parsed["type"] == "auth") {
      throw AuthException("መለያዎ ትክክላኛ አይደለም!");
    } else {
      throw PaymentException("ክፍያ የሎትም!");
    }
  }
  handleErrors(response);

  return response;
}

Future<http.Response> customPostRequest(String url, Map<String, dynamic>? map,
    {bool authorized = false}) async {
  print("POST $url");
  print("req body $map");

  final token = await getToken();

  final response = await http.post(
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
  print("res body ${response.body}");

  handleErrors(response);

  return response;
}

void handleErrors(http.Response response) {
  final parsed = jsonDecode(response.body);
  if (response.statusCode == 403) {
    if (parsed["type"] == "auth") {
      throw AuthException("ይቅርታ መለያዎ ታግድዋል!");
    } else {
      throw PaymentException("ያልተሟላ ከፍያ አሎት!");
    }
  }

  if (response.statusCode == 401) {
    if (parsed["type"] == "auth") {
      throw AuthException("መለያዎ ትክክላኛ አይደለም!");
    } else {
      throw PaymentException("ክፍያ የሎትም!");
    }
  }
}

Future<String?> getToken() async {
  final pref = await SharedPreferences.getInstance();
  final token = pref.getString(PrefConsts.token);
  print("token: $token");
  return token;
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

// T handleError<T>(Object err, T state) {
//   if (err is ConnectivityException) {
//     return state.copyWith(
//       isLoading: false,
//       error: err.message,
//     );
//   } else if (err is AuthException) {
//     return state.copyWith(
//       isLoading: false,
//       isErrorAuth: true,
//       error: err.message,
//     );
//   } else if (err is PaymentException) {
//     return state.copyWith(
//       isLoading: false,
//       isErrorPayment: true,
//       error: err.message,
//     );
//   } else {
//     print("Error: $err");
//     return state.copyWith(
//       isLoading: false,
//       error: "ደርሶቹን ማግኘት አልተቻለም።",
//     );
//   }
// }
