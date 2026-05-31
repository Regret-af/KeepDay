String localDateKey(DateTime date) {
  final local = date.toLocal();
  return '${local.year.toString().padLeft(4, '0')}-'
      '${local.month.toString().padLeft(2, '0')}-'
      '${local.day.toString().padLeft(2, '0')}';
}

String todayDateKey() => localDateKey(DateTime.now());

DateTime localDateOnly(DateTime date) {
  final local = date.toLocal();
  return DateTime(local.year, local.month, local.day);
}

DateTime parseLocalDateKey(String value) {
  final parts = value.split('-');
  if (parts.length != 3) {
    throw FormatException('Invalid local date key', value);
  }
  return DateTime(
    int.parse(parts[0]),
    int.parse(parts[1]),
    int.parse(parts[2]),
  );
}

bool isSameLocalDate(DateTime a, DateTime b) {
  return localDateKey(a) == localDateKey(b);
}

String humanDateLabel(DateTime date) {
  final local = date.toLocal();
  return '${local.year}年${local.month}月${local.day}日';
}
