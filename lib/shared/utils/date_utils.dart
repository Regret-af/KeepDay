String localDateKey(DateTime date) {
  final local = date.toLocal();
  return '${local.year.toString().padLeft(4, '0')}-'
      '${local.month.toString().padLeft(2, '0')}-'
      '${local.day.toString().padLeft(2, '0')}';
}

String todayDateKey() => localDateKey(DateTime.now());

String humanDateLabel(DateTime date) {
  final local = date.toLocal();
  return '${local.year}年${local.month}月${local.day}日';
}
