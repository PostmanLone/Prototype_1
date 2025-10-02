import 'package:flutter/material.dart';
import '../api.dart';
import '../theme.dart';
import '../widgets/rounded_card.dart';
import '../widgets/top_header_simple.dart';
import '../utils/datetime.dart';
import '../widgets/student_tile.dart';

class StaffScreen extends StatefulWidget {
  final String token;
  final VoidCallback onSignOut;
  const StaffScreen({super.key, required this.token, required this.onSignOut});

  @override
  State<StaffScreen> createState() => _StaffScreenState();
}

class _StaffScreenState extends State<StaffScreen> {
  List<dynamic> zones = [];
  List<dynamic> students = [];
  bool loading = false;

  Future<void> load() async {
    setState(() => loading = true);
    try {
      final z = await Api.staffZones(widget.token);
      final s = await Api.staffStudents(widget.token);
      setState(() {
        zones = z;
        students = s;
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
    return Scaffold(
      backgroundColor: Palette.sand,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TopHeaderSimple(
                    onSettingsTap: () =>
                        Navigator.pushNamed(context, '/settings'),
                    onLogoutTap: widget.onSignOut,
                  ),
                  const SizedBox(height: 12),

                  // Zones header + refresh
                  RoundedCard(
                    child: Row(
                      children: [
                        const Icon(Icons.meeting_room, color: Palette.forest),
                        const SizedBox(width: 10),
                        const Text('Zones',
                            style: TextStyle(fontWeight: FontWeight.w800)),
                        const Spacer(),
                        FilledButton.icon(
                          onPressed: loading ? null : load,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Refresh'),
                        ),
                      ],
                    ),
                  ),

                  // Zones chips
                  RoundedCard(
                    child: zones.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Text('No zones to show.',
                                style: TextStyle(color: Colors.black54)),
                          )
                        : Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: zones.map((z) {
                              final m = z as Map<String, dynamic>;
                              final name = (m['zone'] ?? '—').toString();
                              final count = (m['count'] ?? 0).toString();
                              return Chip(
                                label: Text('$name: $count'),
                                avatar:
                                    const Icon(Icons.location_city, size: 18),
                                backgroundColor: Colors.white,
                                side: const BorderSide(
                                    color: Palette.forest, width: 1),
                              );
                            }).toList(),
                          ),
                  ),

                  // Students list
                  RoundedCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Students',
                            style: TextStyle(fontWeight: FontWeight.w800)),
                        const SizedBox(height: 8),
                        if (students.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('No students to show.',
                                style: TextStyle(color: Colors.black54)),
                          )
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: students.length,
                            separatorBuilder: (_, __) =>
                                const Divider(height: 1),
                            itemBuilder: (context, i) {
                              final s = students[i] as Map<String, dynamic>;
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6.0),
                                child: StudentTile(
                                    student:
                                        s), // <-- expandable student details
                              );
                            },
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
