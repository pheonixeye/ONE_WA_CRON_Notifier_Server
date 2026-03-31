import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> init(InternetAddress ip, int port) async {
  await initializeDateFormatting('ar');
}

Future<HttpServer> run(Handler handler, InternetAddress ip, int port) {
  return serve(handler, InternetAddress.anyIPv4, 8080);
}
