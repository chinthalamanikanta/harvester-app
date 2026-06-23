import 'dart:convert';
import 'package:http/http.dart' as http;

class BookingService {

  static Future<bool> createBooking({
    required int farmerId,
    required int machineId,
    required double acres,
    required String bookingDate,
  }) async {

    final response = await http.post(
      Uri.parse(
        "https://harvester-backend-5lcq.onrender.com/api/bookings/create",
      ),

      headers: {
        "Content-Type": "application/json",
      },

      body: jsonEncode({
        "farmer_id": farmerId,
        "machine_id": machineId,
        "acres": acres,
        "booking_date": bookingDate,
      }),
    );

    return response.statusCode == 200;
  }
}