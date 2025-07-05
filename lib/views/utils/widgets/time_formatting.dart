import 'package:intl/intl.dart';

String prettyTimestamp(String isoString) {
  // Clean up the timestamp
  isoString = isoString.trim();

  // If it has microseconds, limit to 6 digits (Dart max)
  final sanitized = isoString.replaceFirstMapped(
    RegExp(r'\.\d{6,}'),
    (match) => '.${match.group(0)!.substring(1, 7)}',
  );

  final dt = DateTime.parse(sanitized).toLocal();
  final fmt = DateFormat('dd/MM/yyyy - hh : mm a');

  return fmt.format(dt);
}
