// ============================================================
// FILE: lib/controllers/player_controller.dart
// DESKRIPSI: Controller utama untuk semua logika pemutar audio
// LAYER: Controller (dalam pola MVC)
// PATTERN: ChangeNotifier (bagian dari Provider pattern)
// ============================================================

import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import '../models/song_model.dart';

/// [PlayerState] enum untuk merepresentasikan status pemutar
enum PlayerState {
  idle,     // Belum ada lagu dipilih
  loading,  // Sedang memuat lagu
  playing,  // Sedang memutar
  paused,   // Di-pause
  stopped,  // Dihentikan
  error,    // Terjadi error
}

/// [RepeatMode] enum untuk mode pengulangan
enum RepeatMode {
  none,   // Tidak mengulang
  one,    // Mengulang satu lagu
  all,    // Mengulang semua lagu
}

/// [PlayerController] adalah otak dari aplikasi pemutar.
///
/// Tugasnya:
/// 1. Mengatur AudioPlayer (just_audio)
/// 2. Menyimpan state: lagu aktif, posisi, status
/// 3. Memberitahu UI untuk rebuild saat state berubah (notifyListeners)
///
/// Widget UI tidak perlu tahu cara kerja AudioPlayer,
/// cukup memanggil method di sini.
class PlayerController extends ChangeNotifier {
  // ──────────────────────────────────────────
  // PRIVATE FIELDS
  // ──────────────────────────────────────────

  /// Instance AudioPlayer dari package just_audio
  final AudioPlayer _audioPlayer = AudioPlayer();

  /// Daftar semua lagu yang tersedia
  List<SongModel> _playlist = [];

  /// Lagu yang sedang aktif/dipilih
  SongModel? _currentSong;

  /// Index lagu yang sedang diputar di dalam _playlist
  int _currentIndex = -1;

  /// Status pemutar saat ini
  PlayerState _playerState = PlayerState.idle;

  /// Posisi pemutaran saat ini
  Duration _currentPosition = Duration.zero;

  /// Mode pengulangan
  RepeatMode _repeatMode = RepeatMode.none;

  /// Mode acak (shuffle)
  bool _isShuffled = false;

  /// Pesan error jika ada
  String? _errorMessage;

  // ──────────────────────────────────────────
  // CONSTRUCTOR
  // ──────────────────────────────────────────

  PlayerController() {
    _initStreams();
    _loadInitialPlaylist();
  }

  // ──────────────────────────────────────────
  // GETTERS (akses state dari luar)
  // ──────────────────────────────────────────

  List<SongModel> get playlist => _playlist;
  SongModel? get currentSong => _currentSong;
  int get currentIndex => _currentIndex;
  PlayerState get playerState => _playerState;
  Duration get currentPosition => _currentPosition;
  RepeatMode get repeatMode => _repeatMode;
  bool get isShuffled => _isShuffled;
  String? get errorMessage => _errorMessage;

  /// true jika sedang memutar lagu
  bool get isPlaying => _playerState == PlayerState.playing;

  /// true jika sedang loading
  bool get isLoading => _playerState == PlayerState.loading;

  /// Durasi total lagu yang sedang diputar
  Duration get totalDuration => _currentSong?.duration ?? Duration.zero;

  /// Persentase kemajuan pemutaran (0.0 - 1.0)
  double get progress {
    if (totalDuration.inMilliseconds == 0) return 0.0;
    final value = _currentPosition.inMilliseconds / totalDuration.inMilliseconds;
    return value.clamp(0.0, 1.0);
  }

  /// true jika ada lagu berikutnya
  bool get hasNext => _currentIndex < _playlist.length - 1;

  /// true jika ada lagu sebelumnya
  bool get hasPrevious => _currentIndex > 0;

  // ──────────────────────────────────────────
  // INISIALISASI
  // ──────────────────────────────────────────

  /// Menginisialisasi stream listener dari AudioPlayer
  void _initStreams() {
    // Stream untuk posisi pemutaran (update setiap detik)
    _audioPlayer.positionStream.listen((position) {
      _currentPosition = position;
      notifyListeners(); // Memberitahu UI untuk update progress bar
    });

    // Stream untuk status pemutar
    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        // Lagu selesai diputar, jalankan logika next
        _onSongCompleted();
      }
    });

    // Stream untuk error
    _audioPlayer.playbackEventStream.listen(
      (_) {},
      onError: (error) {
        _playerState = PlayerState.error;
        _errorMessage = error.toString();
        notifyListeners();
      },
    );
  }

  /// Memuat playlist awal (dari data dummy untuk demo)
  void _loadInitialPlaylist() {
    _playlist = List.from(dummySongs);
    notifyListeners();
  }

  // ──────────────────────────────────────────
  // KONTROL PEMUTARAN (PUBLIC METHODS)
  // ──────────────────────────────────────────

  /// Memutar lagu berdasarkan index di playlist
  Future<void> playSong(int index) async {
    if (index < 0 || index >= _playlist.length) return;

    try {
      _playerState = PlayerState.loading;
      _currentIndex = index;
      _currentSong = _playlist[index];
      _currentPosition = Duration.zero;
      notifyListeners();

      // Set sumber audio
      // Untuk file dari assets, gunakan setAsset()
      // Untuk file dari storage, gunakan setFilePath()
      await _audioPlayer.setAsset(_currentSong!.filePath);
      await _audioPlayer.play();

      _playerState = PlayerState.playing;
      notifyListeners();
    } catch (e) {
      _playerState = PlayerState.error;
      _errorMessage = 'Gagal memutar lagu: ${e.toString()}';
      notifyListeners();
    }
  }

  /// Pause pemutaran
  Future<void> pause() async {
    await _audioPlayer.pause();
    _playerState = PlayerState.paused;
    notifyListeners();
  }

  /// Resume (lanjutkan) pemutaran
  Future<void> resume() async {
    await _audioPlayer.play();
    _playerState = PlayerState.playing;
    notifyListeners();
  }

  /// Toggle play/pause
  Future<void> togglePlayPause() async {
    if (isPlaying) {
      await pause();
    } else if (_playerState == PlayerState.paused) {
      await resume();
    } else if (_currentIndex >= 0) {
      await playSong(_currentIndex);
    }
  }

  /// Stop pemutaran
  Future<void> stop() async {
    await _audioPlayer.stop();
    _playerState = PlayerState.stopped;
    _currentPosition = Duration.zero;
    notifyListeners();
  }

  /// Pindah ke lagu berikutnya
  Future<void> next() async {
    if (_isShuffled) {
      // Mode shuffle: pilih index acak
      final randomIndex = (DateTime.now().millisecondsSinceEpoch % _playlist.length).toInt();
      await playSong(randomIndex);
    } else if (hasNext) {
      await playSong(_currentIndex + 1);
    } else if (_repeatMode == RepeatMode.all) {
      // Kembali ke lagu pertama
      await playSong(0);
    }
  }

  /// Kembali ke lagu sebelumnya
  Future<void> previous() async {
    // Jika sudah > 3 detik diputar, restart lagu ini dulu
    if (_currentPosition.inSeconds > 3) {
      await seekTo(Duration.zero);
    } else if (hasPrevious) {
      await playSong(_currentIndex - 1);
    }
  }

  /// Seek ke posisi tertentu
  Future<void> seekTo(Duration position) async {
    await _audioPlayer.seek(position);
    _currentPosition = position;
    notifyListeners();
  }

  /// Seek berdasarkan nilai slider (0.0 - 1.0)
  Future<void> seekToProgress(double progress) async {
    final position = Duration(
      milliseconds: (totalDuration.inMilliseconds * progress).round(),
    );
    await seekTo(position);
  }

  // ──────────────────────────────────────────
  // PENGATURAN MODE
  // ──────────────────────────────────────────

  /// Toggle mode shuffle
  void toggleShuffle() {
    _isShuffled = !_isShuffled;
    notifyListeners();
  }

  /// Ganti mode repeat (none → one → all → none)
  void cycleRepeatMode() {
    switch (_repeatMode) {
      case RepeatMode.none:
        _repeatMode = RepeatMode.one;
        _audioPlayer.setLoopMode(LoopMode.one);
        break;
      case RepeatMode.one:
        _repeatMode = RepeatMode.all;
        _audioPlayer.setLoopMode(LoopMode.all);
        break;
      case RepeatMode.all:
        _repeatMode = RepeatMode.none;
        _audioPlayer.setLoopMode(LoopMode.off);
        break;
    }
    notifyListeners();
  }

  // ──────────────────────────────────────────
  // PLAYLIST MANAGEMENT
  // ──────────────────────────────────────────

  /// Tambah lagu ke playlist
  void addSong(SongModel song) {
    _playlist.add(song);
    notifyListeners();
  }

  /// Hapus lagu dari playlist berdasarkan index
  void removeSong(int index) {
    if (index < 0 || index >= _playlist.length) return;
    _playlist.removeAt(index);
    // Jika lagu yang dihapus adalah yang sedang diputar
    if (index == _currentIndex) {
      stop();
      _currentSong = null;
      _currentIndex = -1;
    }
    notifyListeners();
  }

  /// Set playlist baru
  void setPlaylist(List<SongModel> songs) {
    _playlist = List.from(songs);
    notifyListeners();
  }

  // ──────────────────────────────────────────
  // PRIVATE HELPERS
  // ──────────────────────────────────────────

  /// Dipanggil saat lagu selesai diputar
  void _onSongCompleted() {
    switch (_repeatMode) {
      case RepeatMode.one:
        // Putar ulang lagu yang sama
        playSong(_currentIndex);
        break;
      case RepeatMode.all:
        next();
        break;
      case RepeatMode.none:
        if (hasNext) {
          next();
        } else {
          // Playlist selesai
          _playerState = PlayerState.stopped;
          _currentPosition = Duration.zero;
          notifyListeners();
        }
        break;
    }
  }

  // ──────────────────────────────────────────
  // DISPOSE
  // ──────────────────────────────────────────

  /// Membersihkan resource saat controller tidak digunakan lagi
  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
