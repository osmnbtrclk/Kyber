import 'dart:math';

String formatBytes(int bytes, int decimals, {bool base1024 = false}) {
  if (bytes <= 0) return '0 B';
  const suffixes = ['B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];

  final base = base1024 ? 1024 : 1000;
  final i = (log(bytes) / log(base)).floor();
  return '${(bytes / pow(base, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
}

String formatKiloBytes(int bytes, int decimals) {
  return formatBytes(bytes * 1024, decimals);
}
