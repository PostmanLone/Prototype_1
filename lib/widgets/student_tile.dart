import 'dart:convert';
import 'package:flutter/material.dart';
import '../theme.dart';
import '../utils/datetime.dart';

class StudentTile extends StatefulWidget {
  final Map<String, dynamic> student;
  const StudentTile({super.key, required this.student});

  @override
  State<StudentTile> createState() => _StudentTileState();
}

class _StudentTileState extends State<StudentTile> {
  bool _showRaw = false;

  @override
  Widget build(BuildContext context) {
    final s = widget.student;

    final name = (s['name'] ?? '').toString();
    final id = (s['id'] ?? s['student_id'] ?? '').toString();
    final grade = (s['grade'] ?? s['grade_level'] ?? '').toString();
    final section = (s['section'] ?? '').toString();

    final zone = (s['zone'] ?? '—').toString();
    final updatedIso = (s['updated_at'] ?? s['seen_at'] ?? '').toString();
    final updatedNice = prettyDateTime(updatedIso);

    final guardian = (s['guardian'] ?? s['parent'] ?? '').toString();
    final phone = (s['phone'] ?? s['contact'] ?? '').toString();
    final device = (s['device'] ?? s['mac'] ?? s['device_id'] ?? '').toString();

    final history = (s['history'] is List) ? (s['history'] as List) : const [];

    final infoRows = <Widget>[
      if (id.isNotEmpty) _kv('Student ID', id),
      if (grade.isNotEmpty || section.isNotEmpty)
        _kv('Grade/Section',
            [grade, section].where((e) => e.isNotEmpty).join(' - ')),
      if (guardian.isNotEmpty) _kv('Guardian', guardian),
      if (phone.isNotEmpty) _kv('Contact', phone),
      if (device.isNotEmpty) _kv('Device', device),
      if (updatedNice.isNotEmpty) _kv('Last Seen', updatedNice),
    ];

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 8),
        childrenPadding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
        leading: const CircleAvatar(
          backgroundColor: Palette.sand,
          child: Icon(Icons.account_circle_outlined, color: Palette.forest),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text('$zone   •   $updatedNice',
            maxLines: 1, overflow: TextOverflow.ellipsis),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        collapsedShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        children: [
          ...infoRows,

          if (history.isNotEmpty) ...[
            const SizedBox(height: 8),
            const Text('Recent Zones',
                style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            ...history.take(5).map((h) {
              final m = (h is Map) ? h : <String, dynamic>{};
              final hz = (m['zone'] ?? '—').toString();
              final hts =
                  prettyDateTime((m['ts'] ?? m['time'] ?? '').toString());
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Row(
                  children: [
                    const Icon(Icons.circle, size: 6, color: Palette.forest),
                    const SizedBox(width: 8),
                    Expanded(child: Text(hz)),
                    Text(hts, style: const TextStyle(color: Colors.black54)),
                  ],
                ),
              );
            }),
          ],

          // Toggle raw JSON for debugging
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => setState(() => _showRaw = !_showRaw),
              icon: Icon(_showRaw ? Icons.visibility_off : Icons.visibility),
              label: Text(_showRaw ? 'Hide raw JSON' : 'Show raw JSON'),
              style: TextButton.styleFrom(foregroundColor: Palette.forest),
            ),
          ),
          if (_showRaw) _jsonBlock(s),
        ],
      ),
    );
  }

  static Widget _kv(String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(label,
                style: const TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  static Widget _jsonBlock(Map<String, dynamic> data) {
    final pretty = const JsonEncoder.withIndent('  ').convert(data);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Palette.sand.withOpacity(.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SelectableText(
          pretty,
          style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
        ),
      ),
    );
  }
}
