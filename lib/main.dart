// lib/main.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'theme.dart'; // AppTheme.light()
import 'api.dart';

import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/parent_screen.dart';
import 'screens/staff_screen.dart';
// import 'screens/settings_screen.dart'; // add route later if you need it

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
    _loadPersisted();
  }

  Future<void> _loadPersisted() async {
    final sp = await SharedPreferences.getInstance();
    final savedToken = sp.getString('token');
    final savedRole = sp.getString('role') ?? 'parent';
    final savedUrl = sp.getString('api_base_url');
    if (savedUrl != null && savedUrl.isNotEmpty) {
      Api.setBaseUrl(savedUrl);
    }
    setState(() {
      token = savedToken;
      role = savedRole;
    });
  }

  Future<void> _onSignedIn(String t, String r) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString('token', t);
    await sp.setString('role', r);
    setState(() {
      token = t;
      role = r;
    });
  }

  Future<void> _signOutAndGo(BuildContext context) async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove('token');
    await sp.remove('role');
    setState(() {
      token = null;
      role = 'parent';
    });
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(), // <— named arg, not positional
      initialRoute: '/onboarding',
      routes: {
        '/onboarding': (_) => const OnboardingScreen(),

        '/login': (ctx) => LoginScreen(
              onSignedIn: (t, r) async {
                await _onSignedIn(t, r);
                if (!ctx.mounted) return;
                Navigator.pushReplacementNamed(
                  ctx,
                  r == 'parent' ? '/parent' : '/staff',
                  arguments: t,
                );
              },
            ),

        '/signup': (_) => const SignupScreen(),

        '/parent': (ctx) {
          final argToken =
              (ModalRoute.of(ctx)?.settings.arguments as String?) ??
                  token ??
                  '';
          return ParentScreen(
            token: argToken,
            onSignOut: () => _signOutAndGo(ctx),
          );
        },

        '/staff': (ctx) {
          final argToken =
              (ModalRoute.of(ctx)?.settings.arguments as String?) ??
                  token ??
                  '';
          return StaffScreen(
            token: argToken,
            onSignOut: () => _signOutAndGo(ctx),
          );
        },

        // '/settings': (_) => const SettingsScreen(),
      },
    );
  }
}
