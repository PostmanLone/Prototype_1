import 'dart:convert';
import 'package:flutter/material.dart';
import '../theme.dart';

class AlertTile extends StatefulWidget {
  final Map<String, dynamic> alert;
  const AlertTile({super.key, required this.alert});

  @override
  State<AlertTile> createState() => _AlertTileState();
}

class _AlertTileState extends State<AlertTile> {
  bool _showRaw = false;

  @override
  Widget build(BuildContext context) {
    final a = widget.alert;
    final title = (a['message'] ?? a['type'] ?? 'Alert').toString();
    final ts = (a['ts'] ?? a['time'] ?? '').toString();
    final type = (a['type'] ?? '').toString();

    final zone = _str(a['zone']);
    final source = _str(a['source'] ?? a['device']);
    final severity = _str(a['severity']);
    final note = _str(a['note'] ?? a['details']?['note']);
    final details = (a['details'] is Map) ? (a['details'] as Map) : const {};

    final infoRows = <Widget>[
      if (zone != null) _detailTextRow('Zone', zone),
      if (source != null) _detailTextRow('Source', source),
      if (severity != null) _detailTextRow('Severity', severity),
      if (note != null) _detailTextRow('Note', note),
      ...details.entries
          .where((e) => e.key.toString().toLowerCase() != 'note')
          .map((e) =>
              _detailTextRow(_labelize(e.key.toString()), _str(e.value) ?? '')),
    ];

    final hasExtra = infoRows.isNotEmpty;

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 8),
        childrenPadding: const EdgeInsets.fromLTRB(8, 0, 8, 10),
        leading: const CircleAvatar(
          backgroundColor: Palette.sand,
          child: Icon(Icons.notifications_none, color: Palette.forest),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Row(
          children: [
            if (type.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Chip(
                  label: Text(type),
                  backgroundColor: Palette.sand,
                  labelStyle: const TextStyle(fontSize: 12),
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            if (ts.isNotEmpty)
              Flexible(child: Text(ts, overflow: TextOverflow.ellipsis)),
          ],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        collapsedShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        children: [
          if (hasExtra) ...infoRows,
          if (!hasExtra)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 6.0),
              child: Text('No extra details.',
                  style: TextStyle(color: Colors.black54)),
            ),

          // Toggle raw JSON
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => setState(() => _showRaw = !_showRaw),
              icon: Icon(_showRaw ? Icons.visibility_off : Icons.visibility),
              label: Text(_showRaw ? 'Hide raw JSON' : 'Show raw JSON'),
              style: TextButton.styleFrom(foregroundColor: Palette.forest),
            ),
          ),
          if (_showRaw) _detailBlock(JsonPreview(data: a)),
        ],
      ),
    );
  }

  static String? _str(dynamic v) => v?.toString();

  static String _labelize(String k) {
    return k
        .replaceAll(RegExp(r'[_-]+'), ' ')
        .split(' ')
        .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}')
        .join(' ');
  }

  static Widget _detailTextRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 88,
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

  static Widget _detailBlock(Widget child) {
    return Padding(
      padding: const EdgeInsets.only(top: 6.0),
      child: child,
    );
  }
}

class JsonPreview extends StatelessWidget {
  final Map<String, dynamic> data;
  const JsonPreview({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final pretty = const JsonEncoder.withIndent('  ').convert(data);
    return Container(
      width: double.infinity,
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
