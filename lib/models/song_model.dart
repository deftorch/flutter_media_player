// ============================================================
// FILE: lib/models/song_model.dart
// DESKRIPSI: Model data untuk satu lagu/track audio
// LAYER: Model (dalam pola MVC)
// ============================================================

/// [SongModel] merepresentasikan satu buah lagu.
/// Berisi semua informasi yang dibutuhkan untuk ditampilkan
/// di UI dan diputar oleh AudioPlayer.
class SongModel {
  /// ID unik lagu (dari sistem atau index)
  final int id;

  /// Judul lagu
  final String title;

  /// Nama artis / penyanyi
  final String artist;

  /// Nama album
  final String album;

  /// Path file audio di storage perangkat
  final String filePath;

  /// Durasi total lagu
  final Duration duration;

  /// Path artwork / sampul album (bisa null)
  final String? artworkPath;

  /// Ukuran file dalam bytes
  final int? fileSize;

  // Constructor menggunakan named parameters dengan required
  const SongModel({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.filePath,
    required this.duration,
    this.artworkPath,
    this.fileSize,
  });

  /// Factory constructor: membuat SongModel dari Map (JSON)
  /// Berguna saat mengambil data dari database atau API
  factory SongModel.fromMap(Map<String, dynamic> map) {
    return SongModel(
      id: map['id'] as int,
      title: map['title'] as String? ?? 'Unknown Title',
      artist: map['artist'] as String? ?? 'Unknown Artist',
      album: map['album'] as String? ?? 'Unknown Album',
      filePath: map['filePath'] as String,
      duration: Duration(milliseconds: map['duration'] as int? ?? 0),
      artworkPath: map['artworkPath'] as String?,
      fileSize: map['fileSize'] as int?,
    );
  }

  /// Mengubah SongModel menjadi Map (untuk disimpan ke DB)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'album': album,
      'filePath': filePath,
      'duration': duration.inMilliseconds,
      'artworkPath': artworkPath,
      'fileSize': fileSize,
    };
  }

  /// Helper: format durasi menjadi string "mm:ss"
  String get formattedDuration {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Membuat salinan objek dengan nilai yang diubah (immutable pattern)
  SongModel copyWith({
    int? id,
    String? title,
    String? artist,
    String? album,
    String? filePath,
    Duration? duration,
    String? artworkPath,
    int? fileSize,
  }) {
    return SongModel(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      album: album ?? this.album,
      filePath: filePath ?? this.filePath,
      duration: duration ?? this.duration,
      artworkPath: artworkPath ?? this.artworkPath,
      fileSize: fileSize ?? this.fileSize,
    );
  }

  @override
  String toString() {
    return 'SongModel(id: $id, title: $title, artist: $artist)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SongModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

// ============================================================
// DATA DUMMY untuk pengembangan dan testing
// Data ini digunakan saat tidak ada lagu di perangkat
// ============================================================
List<SongModel> dummySongs = [
  SongModel(
    id: 1,
    title: 'Bohemian Rhapsody',
    artist: 'Queen',
    album: 'A Night at the Opera',
    filePath: 'assets/audio/sample1.mp3',
    duration: const Duration(minutes: 5, seconds: 55),
  ),
  SongModel(
    id: 2,
    title: 'Shape of You',
    artist: 'Ed Sheeran',
    album: '÷ (Divide)',
    filePath: 'assets/audio/sample2.mp3',
    duration: const Duration(minutes: 3, seconds: 53),
  ),
  SongModel(
    id: 3,
    title: 'Blinding Lights',
    artist: 'The Weeknd',
    album: 'After Hours',
    filePath: 'assets/audio/sample3.mp3',
    duration: const Duration(minutes: 3, seconds: 20),
  ),
  SongModel(
    id: 4,
    title: 'Levitating',
    artist: 'Dua Lipa',
    album: 'Future Nostalgia',
    filePath: 'assets/audio/sample4.mp3',
    duration: const Duration(minutes: 3, seconds: 23),
  ),
  SongModel(
    id: 5,
    title: 'Stay',
    artist: 'Justin Bieber ft. The Kid LAROI',
    album: 'F*CK LOVE 3',
    filePath: 'assets/audio/sample5.mp3',
    duration: const Duration(minutes: 2, seconds: 21),
  ),
];
