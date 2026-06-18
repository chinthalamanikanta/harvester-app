import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/machine.dart';

class MachineService {

  static Future<List<Machine>> getMachines() async {

    final response = await http.get(
      Uri.parse(
        "http://127.0.0.1:8001/api/machines/"
      ),
    );

    if (response.statusCode == 200) {

      final List data = jsonDecode(response.body);

      return data
          .map((e) => Machine.fromJson(e))
          .toList();

    } else {
      throw Exception("Failed to load machines");
    }
  }
}