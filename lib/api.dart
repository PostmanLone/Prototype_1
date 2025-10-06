// lib/api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class Api {
  /// Change this at runtime with [setBaseUrl] if needed.
  static String baseUrl = 'https://backend-prototype-x8en.onrender.com';

  static void setBaseUrl(String url) {
    baseUrl = url;
  }

  static const _timeout = Duration(seconds: 15);

  // -------------------- AUTH --------------------

  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final res = await http
        .post(
          Uri.parse('$baseUrl/auth/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email, 'password': password}),
        )
        .timeout(_timeout);

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return _json(res.body);
    }
    throw Exception('Login failed (${res.statusCode}): ${res.body}');
  }

  static Future<void> register(Map<String, dynamic> payload) async {
    final res = await http
        .post(
          Uri.parse('$baseUrl/auth/register'), // <-- fixed here
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(payload),
        )
        .timeout(_timeout);

    if (res.statusCode >= 200 && res.statusCode < 300) return;

    // Try to surface backend detail if present
    try {
      final m = _json(res.body);
      final detail = (m['detail'] ?? m['message'])?.toString();
      throw Exception(detail ?? 'Registration failed (${res.statusCode})');
    } catch (_) {
      throw Exception('Registration failed (${res.statusCode})');
    }
  }

  // -------------------- PARENT --------------------

  static Future<Map<String, dynamic>> parentCurrent(
    String token,
    String studentId,
  ) async {
    final res = await http.get(
      Uri.parse('$baseUrl/parent/child/current?student_id=$studentId'),
      headers: {'Authorization': 'Bearer $token'},
    ).timeout(_timeout);

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return _json(res.body);
    }
    throw Exception('Fetch current failed (${res.statusCode}): ${res.body}');
  }

  static Future<List<dynamic>> parentAlerts(
    String token,
    String studentId,
  ) async {
    final res = await http.get(
      Uri.parse('$baseUrl/parent/alerts?student_id=$studentId'),
      headers: {'Authorization': 'Bearer $token'},
    ).timeout(_timeout);

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return _json(res.body) as List<dynamic>;
    }
    throw Exception('Fetch alerts failed (${res.statusCode}): ${res.body}');
  }

  // -------------------- STAFF --------------------

  static Future<List<dynamic>> staffStudents(String token) async {
    final res = await http.get(
      Uri.parse('$baseUrl/staff/students'),
      headers: {'Authorization': 'Bearer $token'},
    ).timeout(_timeout);

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return _json(res.body) as List<dynamic>;
    }
    throw Exception('Fetch students failed (${res.statusCode}): ${res.body}');
  }

  static Future<List<dynamic>> staffZones(String token) async {
    final res = await http.get(
      Uri.parse('$baseUrl/staff/zones'),
      headers: {'Authorization': 'Bearer $token'},
    ).timeout(_timeout);

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return _json(res.body) as List<dynamic>;
    }
    throw Exception('Fetch zones failed (${res.statusCode}): ${res.body}');
  }

  // -------------------- Helpers --------------------

  static dynamic _json(String body) {
    if (body.isEmpty) return {};
    return jsonDecode(body);
  }
}
