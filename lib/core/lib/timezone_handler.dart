import 'package:flutter_timezone/flutter_timezone.dart';

Future<String> getDeviceTimeZone() async {
  final TimezoneInfo timeZone = await FlutterTimezone.getLocalTimezone();
  print("timezone ${timeZone.identifier}");
  return timeZone.identifier;
}
