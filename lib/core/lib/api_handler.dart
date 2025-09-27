import "package:http/http.dart" as http;

Future<http.Response> customGetRequest(String url) {
  print("GET $url");
  return http.get(Uri.parse(url));
}
