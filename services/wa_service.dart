import 'dart:convert';

import 'package:http/http.dart' as http;

import '../env.dart';

class WaService {
  const WaService({
    required this.phone,
    required this.message,
  });

  final String phone;
  final String message;

  Future<bool> sendTextMessage() async {
    const uri = Env.WA_URL;

    final _response = await http.post(
      Uri.parse(uri),
      headers: {
        'Token': Env.WA_ADMIN_TOKEN,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'Phone': phone,
        'Body': message,
      }),
    );

    final _result = jsonDecode(_response.body) as Map<String, dynamic>;
    // print(_result);

    if (_result['code'] == 200) {
      return true;
    } else {
      // print(_result['data']);
      return false;
    }
  }
}
