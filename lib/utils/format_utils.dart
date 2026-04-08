// ============================================================
// FILE: lib/utils/format_utils.dart
// DESKRIPSI: Kumpulan fungsi utilitas untuk format data
// ============================================================

/// Mengubah Duration menjadi string "mm:ss"
String formatDuration(Duration duration) {
  final minutes = duration.inMinutes;
  final seconds = duration.inSeconds % 60;
  return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
}

/// Mengubah ukuran file (bytes) menjadi string yang readable
/// Contoh: 1048576 → "1.0 MB"
String formatFileSize(int bytes) {
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
  if (bytes < 1024 * 1024 * 1024) {
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
  return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
}

/// Mempersingkat teks jika terlalu panjang
String truncateText(String text, int maxLength) {
  if (text.length <= maxLength) return text;
  return '${text.substring(0, maxLength)}...';
}
