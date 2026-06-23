import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/machine.dart';

class MachineService {

  static Future<List<Machine>> getMachines() async {

    final response = await http.get(
      Uri.parse(
        "https://harvester-backend-5lcq.onrender.com/api/machines/"
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