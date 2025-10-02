import 'dart:convert';
import 'package:http/http.dart' as http;

class Api {
  static String baseUrl = 'https://backend-prototype-x8en.onrender.com';

  static void setBaseUrl(String url) {
    baseUrl = url;
  }

  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (res.statusCode >= 200 && res.statusCode < 300)
      return jsonDecode(res.body);
    throw Exception('Login failed: ${res.statusCode} ${res.body}');
  }

  static Future<Map<String, dynamic>> parentCurrent(
    String token,
    String studentId,
  ) async {
    final res = await http.get(
      Uri.parse('$baseUrl/parent/child/current?student_id=$studentId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (res.statusCode >= 200 && res.statusCode < 300)
      return jsonDecode(res.body);
    throw Exception('Fetch current failed: ${res.statusCode} ${res.body}');
  }

  static Future<List<dynamic>> parentAlerts(
    String token,
    String studentId,
  ) async {
    final res = await http.get(
      Uri.parse('$baseUrl/parent/alerts?student_id=$studentId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (res.statusCode >= 200 && res.statusCode < 300)
      return jsonDecode(res.body);
    throw Exception('Fetch alerts failed: ${res.statusCode} ${res.body}');
  }

  static Future<List<dynamic>> staffStudents(String token) async {
    final res = await http.get(
      Uri.parse('$baseUrl/staff/students'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (res.statusCode >= 200 && res.statusCode < 300)
      return jsonDecode(res.body);
    throw Exception('Fetch students failed: ${res.statusCode} ${res.body}');
  }

  static Future<List<dynamic>> staffZones(String token) async {
    final res = await http.get(
      Uri.parse('$baseUrl/staff/zones'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (res.statusCode >= 200 && res.statusCode < 300)
      return jsonDecode(res.body);
    throw Exception('Fetch zones failed: ${res.statusCode} ${res.body}');
  }
}
