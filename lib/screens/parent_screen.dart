import 'package:flutter/material.dart';
import '../api.dart';
import '../theme.dart';
import '../widgets/rounded_card.dart';
import '../widgets/progress_timeline.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../widgets/top_header_simple.dart';
import '../widgets/alert_tile.dart';
import '../utils/datetime.dart';

const pwcDavao = LatLng(7.056682, 125.593167);

class ParentScreen extends StatefulWidget {
  final String token;
  final VoidCallback onSignOut;
  const ParentScreen({super.key, required this.token, required this.onSignOut});

  @override
  State<ParentScreen> createState() => _ParentScreenState();
}

class _ParentScreenState extends State<ParentScreen> {
  final studentCtrl = TextEditingController(text: 'S-001');
  Map<String, dynamic>? current;
  List<dynamic> alerts = [];
  bool loading = false;

  Future<void> load() async {
    setState(() => loading = true);
    try {
      final c = await Api.parentCurrent(widget.token, studentCtrl.text.trim());
      final a = await Api.parentAlerts(widget.token, studentCtrl.text.trim());
      setState(() {
        current = c;
        alerts = a;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  Widget build(BuildContext context) {
    // Nice, readable values for UI
    final zone = (current?['zone'] ?? '—').toString();
    final updatedIso = (current?['updated_at'] ?? '').toString();
    final updatedNice = prettyDateTime(updatedIso);

    return Scaffold(
      backgroundColor: Palette.sand,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header (no AppBar)
                  TopHeaderSimple(
                    onSettingsTap: () =>
                        Navigator.pushNamed(context, '/settings'),
                    onLogoutTap: widget.onSignOut,
                  ),
                  const SizedBox(height: 12),

                  // Top tracking card
                  RoundedCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Map header
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(18)),
                          child: SizedBox(
                            height: 200,
                            child: FlutterMap(
                              options: MapOptions(
                                initialCenter: pwcDavao,
                                initialZoom: 16.5,
                                interactionOptions: const InteractionOptions(
                                  flags: InteractiveFlag.pinchZoom |
                                      InteractiveFlag.drag,
                                ),
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate:
                                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  subdomains: const ['a', 'b', 'c'],
                                  userAgentPackageName:
                                      'com.example.student_tracking_app',
                                ),
                                MarkerLayer(markers: [
                                  Marker(
                                    point: pwcDavao,
                                    width: 44,
                                    height: 44,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(.15),
                                              blurRadius: 6)
                                        ],
                                      ),
                                      child: const Icon(Icons.place,
                                          color: Color(0xFF3F4F44)),
                                    ),
                                  ),
                                ]),
                                RichAttributionWidget(
                                  attributions: [
                                    TextSourceAttribution(
                                        '© OpenStreetMap contributors',
                                        onTap: () {}),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Status content
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('STUDENT ID',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black54)),
                                        const SizedBox(height: 4),
                                        Text(studentCtrl.text,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w800)),
                                      ],
                                    ),
                                  ),
                                  FilledButton.icon(
                                    onPressed: loading ? null : load,
                                    icon: const Icon(Icons.refresh),
                                    label: const Text('Refresh'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              Row(
                                children: [
                                  const Icon(Icons.verified_user,
                                      color: Palette.forest, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Your child is in $zone',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),

                              Text('Updated: $updatedNice',
                                  style:
                                      const TextStyle(color: Colors.black54)),

                              const SizedBox(height: 14),

                              // Simple 3-step timeline (adjust current index with your data)
                              const ProgressTimeline(
                                steps: ['Arrived', 'In Class', 'Dismissal'],
                                current: 1,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Zone details
                  RoundedCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Zone Details',
                            style: TextStyle(fontWeight: FontWeight.w800)),
                        const SizedBox(height: 6),
                        Wrap(spacing: 8, runSpacing: 8, children: [
                          Chip(
                            avatar: const Icon(Icons.place, size: 18),
                            label: Text(zone),
                            backgroundColor: Palette.sand,
                          ),
                          Chip(
                            avatar: const Icon(Icons.schedule, size: 18),
                            label: Text(updatedNice),
                            backgroundColor: Palette.sand,
                          ),
                        ]),
                      ],
                    ),
                  ),

                  // Alerts (expandable)
                  RoundedCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Recent Alerts',
                            style: TextStyle(fontWeight: FontWeight.w800)),
                        const SizedBox(height: 8),
                        if (alerts.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('No alerts.',
                                style: TextStyle(color: Colors.black54)),
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: alerts.length,
                            itemBuilder: (context, i) {
                              final a = alerts[i] as Map<String, dynamic>;
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6.0),
                                child: AlertTile(alert: a),
                              );
                            },
                          ),
                      ],
                    ),
                  ),

                  // Switch student
                  RoundedCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text('Switch Student',
                            style: TextStyle(fontWeight: FontWeight.w800)),
                        const SizedBox(height: 8),
                        TextField(
                          controller: studentCtrl,
                          decoration: const InputDecoration(
                            hintText: 'Enter Student ID (e.g., S-001)',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: OutlinedButton.icon(
                            onPressed: loading ? null : load,
                            icon: const Icon(Icons.swap_horiz),
                            label: const Text('Load'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
