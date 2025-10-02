import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api.dart';

class SettingsScreen extends StatefulWidget {
  final VoidCallback onSaved;
  const SettingsScreen({super.key, required this.onSaved});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final urlCtrl = TextEditingController(text: Api.baseUrl);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'API Base URL',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: urlCtrl,
                  decoration: const InputDecoration(
                    hintText: 'https://your-api-url',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () async {
                    final url = urlCtrl.text.trim();
                    if (url.isEmpty) return;
                    Api.setBaseUrl(url);
                    final sp = await SharedPreferences.getInstance();
                    await sp.setString('api_base_url', Api.baseUrl);
                    widget.onSaved();
                    if (!mounted) return;
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text('Saved')));
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
