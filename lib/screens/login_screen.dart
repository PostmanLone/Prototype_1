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
  final _formKey = GlobalKey<FormState>();

  bool loading = false;
  String? error;

  Future<void> _submit() async {
    if (loading) return;
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      loading = true;
      error = null;
    });
    try {
      final payload = await Api.login(
        emailCtrl.text.trim(),
        passCtrl.text,
      );
      final token = payload['access_token'] as String;
      final user = payload['user'] as Map<String, dynamic>? ?? {};
      final role = (user['role'] ?? 'parent') as String;

      widget.onSignedIn(token, role);
    } catch (e) {
      setState(() => error = '$e');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = Colors.black.withOpacity(.9);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const _BackgroundLayer(),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: const SizedBox.expand(),
          ),
          SafeArea(
            child: Center(
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
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Header row with Close(X)
                          Row(
                            children: [
                              const Spacer(),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    // Always return to onboarding
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      '/onboarding',
                                      (route) => false,
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: borderColor, width: 2),
                                    ),
                                    padding: const EdgeInsets.all(6),
                                    child: const Icon(Icons.close, size: 18),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),
                          const Text(
                            'WELCOME BACK',
                            textAlign: TextAlign.center,
                            style: TextStyle(
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

                          const _FieldLabel('Email *'),
                          const SizedBox(height: 6),
                          _OutlinedField(
                            controller: emailCtrl,
                            hint: 'you@example.com',
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) {
                              final s = (v ?? '').trim();
                              if (s.isEmpty) return 'Email is required';
                              if (!s.contains('@'))
                                return 'Enter a valid email';
                              return null;
                            },
                            onSubmitted: (_) => _submit(),
                          ),

                          const SizedBox(height: 14),

                          const _FieldLabel('Password *'),
                          const SizedBox(height: 6),
                          _OutlinedField(
                            controller: passCtrl,
                            hint: '••••••••',
                            obscure: true,
                            validator: (v) => (v ?? '').isEmpty
                                ? 'Password is required'
                                : null,
                            onSubmitted: (_) => _submit(),
                          ),

                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: Palette.accent,
                                padding: EdgeInsets.zero,
                              ),
                              onPressed: loading ? null : () {},
                              child: const Text('Forgot your password?'),
                            ),
                          ),

                          if (error != null) ...[
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.error_outline,
                                    color: Colors.red, size: 18),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    error!,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          ],

                          const SizedBox(height: 10),
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
                                  side:
                                      BorderSide(color: borderColor, width: 2),
                                ),
                              ),
                              onPressed: loading ? null : _submit,
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
                          // Example “portal” button in your palette
                          SizedBox(
                            width: double.infinity,
                            height: 46,
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.groups_outlined, size: 18),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Palette.accent,
                                side: BorderSide(color: borderColor, width: 2),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                ),
                              ),
                              onPressed: loading ? null : () {},
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
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                ),
                              ),
                              onPressed: loading ? null : () {},
                              label: const Text(
                                'SIGN IN WITH APPLE',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),

                          const SizedBox(height: 18),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Not a member yet? '),
                              GestureDetector(
                                onTap: loading
                                    ? null
                                    : () =>
                                        Navigator.pushNamed(context, '/signup'),
                                child: const Text(
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
            ),
          ),
        ],
      ),
    );
  }
}

/* ---------- Small UI helpers ---------- */

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
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onSubmitted;

  const _OutlinedField({
    required this.controller,
    required this.hint,
    this.obscure = false,
    this.keyboardType,
    this.validator,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = Colors.black.withOpacity(.9);
    return SizedBox(
      height: 46,
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        validator: validator,
        onFieldSubmitted: onSubmitted,
        decoration: InputDecoration(
          isDense: true,
          hintText: hint,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
      children: const [
        // left line
        Expanded(child: Divider(thickness: 2)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'OR',
            style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2),
          ),
        ),
        // right line
        Expanded(child: Divider(thickness: 2)),
      ],
    );
  }
}

class _BackgroundLayer extends StatelessWidget {
  const _BackgroundLayer();

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
