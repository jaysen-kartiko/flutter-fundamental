import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

// error code
// const String apiUrl = "https://randomuser.me/ap/";
const String apiUrl = "https://randomuser.me/api/";

Future<List<dynamic>> fetchProfiles() async {
  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      
      final List<dynamic> results = data['results'];

      debugPrint('Berhasil memuat! Jumlah item: ${results.length}');

      return results;
    } else {
      throw Exception('Gagal memuat data: HTTP ${response.statusCode}');
    }
  } catch (e) {
    debugPrint('Terjadi error: $e');
    rethrow;
  }
}