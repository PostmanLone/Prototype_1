import 'package:flutter/material.dart';
import '../theme.dart';
import '../api.dart';
import '../widgets/rounded_card.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _phone = TextEditingController();
  final _studentId = TextEditingController();

  String? _role; // 'parent' or 'staff'
  bool _agree = false;
  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    _phone.dispose();
    _studentId.dispose();
    super.dispose();
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Required' : null;

  String? _emailRule(String? v) {
    if (v == null || v.trim().isEmpty) return 'Required';
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim());
    return ok ? null : 'Enter a valid email';
  }

  String? _passwordRule(String? v) {
    if (v == null || v.isEmpty) return 'Required';
    if (v.length < 6) return 'Use at least 6 characters';
    return null;
  }

  Future<void> _submit() async {
    final formOk = _formKey.currentState?.validate() ?? false;
    if (!formOk) return;

    if (_role == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please choose a role (Parent or Staff).')),
      );
      return;
    }
    if (_password.text != _confirm.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match.')),
      );
      return;
    }
    if (!_agree) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept the Terms to continue.')),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      final payload = {
        'name': _name.text.trim(),
        'email': _email.text.trim(),
        'password': _password.text,
        'role': _role, // 'parent' or 'staff'
        'phone': _phone.text.trim(),
        'student_id': _role == 'parent' ? _studentId.text.trim() : null,
      };

      // Implemented in Api.register (see section 2 below)
      await Api.register(payload);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created. Please log in.')),
      );
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign up failed: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.sand,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: RoundedCard(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Title
                      const Text(
                        'Create account',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Join PWC Student Tracking.',
                        style: TextStyle(color: Colors.black54),
                      ),
                      const SizedBox(height: 16),

                      // Name
                      TextFormField(
                        controller: _name,
                        decoration: const InputDecoration(
                          labelText: 'Full name',
                          hintText: 'e.g., Alex Cruz',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: _required,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 10),

                      // Email
                      TextFormField(
                        controller: _email,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          hintText: 'you@example.com',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        validator: _emailRule,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 10),

                      // Role
                      DropdownButtonFormField<String>(
                        value: _role,
                        items: const [
                          DropdownMenuItem(
                              value: 'parent', child: Text('Parent')),
                          DropdownMenuItem(
                              value: 'staff', child: Text('Staff')),
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Role',
                          prefixIcon: Icon(Icons.account_circle_outlined),
                        ),
                        onChanged: (v) => setState(() => _role = v),
                        validator: (v) => v == null ? 'Required' : null,
                      ),
                      const SizedBox(height: 10),

                      // Student ID (only if parent)
                      if (_role == 'parent') ...[
                        TextFormField(
                          controller: _studentId,
                          decoration: const InputDecoration(
                            labelText: 'Student ID',
                            hintText: 'e.g., S-001',
                            prefixIcon: Icon(Icons.badge_outlined),
                          ),
                          validator: _required,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 10),
                      ],

                      // Phone (optional)
                      TextFormField(
                        controller: _phone,
                        decoration: const InputDecoration(
                          labelText: 'Phone (optional)',
                          hintText: '09xx-xxx-xxxx',
                          prefixIcon: Icon(Icons.phone_outlined),
                        ),
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 10),

                      // Password
                      TextFormField(
                        controller: _password,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(_obscure
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () =>
                                setState(() => _obscure = !_obscure),
                          ),
                        ),
                        obscureText: _obscure,
                        validator: _passwordRule,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 10),

                      // Confirm
                      TextFormField(
                        controller: _confirm,
                        decoration: const InputDecoration(
                          labelText: 'Confirm password',
                          prefixIcon: Icon(Icons.lock_reset),
                        ),
                        obscureText: _obscure,
                        validator: _passwordRule,
                      ),
                      const SizedBox(height: 12),

                      // Terms
                      Row(
                        children: [
                          Checkbox(
                            value: _agree,
                            onChanged: (v) =>
                                setState(() => _agree = v ?? false),
                            activeColor: Palette.forest,
                          ),
                          const Expanded(
                            child: Text(
                              'I agree to the Terms and Privacy Policy.',
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Submit
                      SizedBox(
                        height: 48,
                        child: FilledButton(
                          onPressed: _loading ? null : _submit,
                          style: FilledButton.styleFrom(
                            backgroundColor: Palette.forest,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _loading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2, color: Colors.white),
                                )
                              : const Text('Create account',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w700)),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Already have an account
                      TextButton(
                        onPressed: _loading
                            ? null
                            : () => Navigator.pushReplacementNamed(
                                context, '/login'),
                        child: const Text('Already have an account? Log in'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
