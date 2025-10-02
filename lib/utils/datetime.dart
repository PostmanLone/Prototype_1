import 'package:intl/intl.dart';

String prettyDateTime(String? iso, {String? locale}) {
  if (iso == null || iso.isEmpty) return '';
  DateTime? dt;
  try {
    dt = DateTime.parse(iso).toLocal();
  } catch (_) {
    return iso;
  }

  final now = DateTime.now();
  final isSameDay =
      dt.year == now.year && dt.month == now.month && dt.day == now.day;
  final yesterday = now.subtract(const Duration(days: 1));
  final isYesterday = dt.year == yesterday.year &&
      dt.month == yesterday.month &&
      dt.day == yesterday.day;

  final d = DateFormat.yMMMd(locale);
  final t = DateFormat.jm(locale);

  if (isSameDay) {
    return 'Today, ${t.format(dt)}';
  } else if (isYesterday) {
    return 'Yesterday, ${t.format(dt)}';
  } else {
    return '${d.format(dt)} · ${t.format(dt)}';
  }
}
