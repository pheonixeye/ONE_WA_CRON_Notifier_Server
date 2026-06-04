import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:uuid/v4.dart';

Future<void> init(InternetAddress ip, int port) async {
  await initializeDateFormatting('ar');
  tz_data.initializeTimeZones();
}

Future<HttpServer> run(Handler handler, InternetAddress ip, int port) {
  return serve(handler, InternetAddress.anyIPv4, 8080);
}

const uuid = UuidV4();
