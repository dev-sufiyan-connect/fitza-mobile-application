/// Date helpers shared across features.
library;

/// Formats [date] as `yyyy-MM-dd`, the format Supabase `date` columns and
/// RPC parameters expect.
String toIsoDate(DateTime date) {
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '${date.year.toString().padLeft(4, '0')}-$month-$day';
}
