import 'dart:ui';
import 'package:flutter/material.dart';
import '../api.dart';
import '../theme.dart';

class LoginScreen extends StatefulWidget {
  final void Function(String token, String role) onSignedIn;
  const LoginScreen({super.key, required this.onSignedIn});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailCtrl = TextEditingController(text: 'parent@example.com');
  final passCtrl = TextEditingController(text: 'parent123');
  bool loading = false;
  String? error;

  @override
  Widget build(BuildContext context) {
    final borderColor = Colors.black.withOpacity(
      .9,
    );
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          _BackgroundLayer(),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
            child: Container(color: Colors.transparent),
          ),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: borderColor, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.08),
                      blurRadius: 12,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(36, 28, 36, 28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Container()),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: borderColor, width: 2),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(6.0),
                              child: Icon(Icons.close, size: 18),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'WELCOME BACK',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                          fontSize: 28,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Sign into your account',
                        style: TextStyle(
                          letterSpacing: .6,
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 22),

                      _FieldLabel('Email *'),
                      const SizedBox(height: 6),
                      _OutlinedField(
                        controller: emailCtrl,
                        hint: 'you@example.com',
                      ),

                      const SizedBox(height: 14),

                      _FieldLabel('Password *'),
                      const SizedBox(height: 6),
                      _OutlinedField(
                        controller: passCtrl,
                        hint: '••••••••',
                        obscure: true,
                      ),

                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Palette.accent,
                            padding: EdgeInsets.zero,
                          ),
                          onPressed: () {},
                          child: const Text('Forgot your password?'),
                        ),
                      ),

                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Palette.forest,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                              side: BorderSide(color: borderColor, width: 2),
                            ),
                          ),
                          onPressed: loading
                              ? null
                              : () async {
                                  setState(() {
                                    loading = true;
                                    error = null;
                                  });
                                  try {
                                    final payload = await Api.login(
                                      emailCtrl.text.trim(),
                                      passCtrl.text,
                                    );
                                    final token =
                                        payload['access_token'] as String;
                                    final user =
                                        payload['user'] as Map<String, dynamic>;
                                    final role =
                                        (user['role'] ?? 'parent') as String;

                                    widget.onSignedIn(token, role);
                                  } catch (e) {
                                    setState(() => error = '$e');
                                  } finally {
                                    setState(() => loading = false);
                                  }
                                },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (loading)
                                const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              else
                                const Text(
                                  'SIGN IN',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              const SizedBox(width: 8),
                              const Icon(Icons.chevron_right, size: 18),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),
                      const _DividerLabel(),

                      const SizedBox(height: 10),
                      // “Social” buttons styled in your palette (not FB blue)
                      SizedBox(
                        width: double.infinity,
                        height: 46,
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.groups_outlined, size: 18),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Palette.accent,
                            side: BorderSide(color: borderColor, width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          onPressed: () {},
                          label: const Text(
                            'SIGN IN WITH FAMILY PORTAL',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        height: 46,
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.apple, size: 18),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.white,
                            side: BorderSide(color: borderColor, width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          onPressed: () {},
                          label: const Text(
                            'SIGN IN WITH APPLE',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),

                      if (error != null) ...[
                        const SizedBox(height: 12),
                        Text(error!, style: const TextStyle(color: Colors.red)),
                      ],

                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Not a member yet? '),
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                color: Palette.accent,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        fontWeight: FontWeight.w800,
        letterSpacing: 1,
        fontSize: 12,
      ),
    );
  }
}

class _OutlinedField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscure;
  const _OutlinedField({
    required this.controller,
    required this.hint,
    this.obscure = false,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = Colors.black.withOpacity(.9);
    return SizedBox(
      height: 46,
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          isDense: true,
          hintText: hint,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor, width: 2),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Palette.accent, width: 2),
          ),
        ),
      ),
    );
  }
}

class _DividerLabel extends StatelessWidget {
  const _DividerLabel();

  @override
  Widget build(BuildContext context) {
    final line = Expanded(
      child: Container(height: 2, color: Colors.black.withOpacity(.9)),
    );
    return Row(
      children: [
        line,
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'OR',
            style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2),
          ),
        ),
        line,
      ],
    );
  }
}

class _BackgroundLayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/login_bg.jpg',
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) {
            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Palette.deepGreen, Palette.forest],
                ),
              ),
            );
          },
        ),
        Container(color: Palette.deepGreen.withOpacity(.35)),
      ],
    );
  }
}
