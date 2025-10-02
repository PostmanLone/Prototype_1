import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme.dart';
import 'api.dart';
import 'screens/login_screen.dart';
import 'screens/parent_screen.dart';
import 'screens/staff_screen.dart';
import 'screens/settings_screen.dart';

void main() => runApp(const StudentTrackingApp());

class StudentTrackingApp extends StatefulWidget {
  const StudentTrackingApp({super.key});
  @override
  State<StudentTrackingApp> createState() => _StudentTrackingAppState();
}

class _StudentTrackingAppState extends State<StudentTrackingApp> {
  String? token;
  String role = 'parent';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final sp = await SharedPreferences.getInstance();
    setState(() {
      token = sp.getString('token');
      role = sp.getString('role') ?? 'parent';
      final savedUrl = sp.getString('api_base_url');
      if (savedUrl != null && savedUrl.isNotEmpty) Api.setBaseUrl(savedUrl);
    });
  }

  void onSignedIn(String t, String r) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString('token', t);
    await sp.setString('role', r);
    setState(() {
      token = t;
      role = r;
    });
  }

  void onSignOut() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove('token');
    await sp.remove('role');
    setState(() {
      token = null;
      role = 'parent';
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Tracking',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routes: {
        '/settings': (_) => SettingsScreen(onSaved: () => setState(() {})),
      },
      home: token == null
          ? LoginScreen(onSignedIn: onSignedIn)
          : (role == 'staff' || role == 'admin'
                ? StaffScreen(token: token!, onSignOut: onSignOut)
                : ParentScreen(token: token!, onSignOut: onSignOut)),
    );
  }
}
