// ============================================================
// FILE: test/player_controller_test.dart
// DESKRIPSI: Unit test untuk PlayerController
// Jalankan dengan: flutter test
// ============================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_media_player/controllers/player_controller.dart';
import 'package:flutter_media_player/models/song_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SongModel Tests', () {
    // Test 1: Membuat SongModel dengan data valid
    test('SongModel dibuat dengan benar', () {
      final song = SongModel(
        id: 1,
        title: 'Test Song',
        artist: 'Test Artist',
        album: 'Test Album',
        filePath: '/test/path.mp3',
        duration: const Duration(minutes: 3, seconds: 30),
      );

      expect(song.id, 1);
      expect(song.title, 'Test Song');
      expect(song.artist, 'Test Artist');
      expect(song.formattedDuration, '03:30');
    });

    // Test 2: Format durasi
    test('formattedDuration menghasilkan format mm:ss', () {
      final song = SongModel(
        id: 1,
        title: 'Test',
        artist: 'Artist',
        album: 'Album',
        filePath: '/path.mp3',
        duration: const Duration(minutes: 5, seconds: 9),
      );
      expect(song.formattedDuration, '05:09');
    });

    // Test 3: SongModel equality
    test('Dua SongModel dengan id sama dianggap equal', () {
      final song1 = SongModel(
        id: 1,
        title: 'Song A',
        artist: 'Artist',
        album: 'Album',
        filePath: '/path.mp3',
        duration: Duration.zero,
      );
      final song2 = SongModel(
        id: 1,
        title: 'Song B', // Judul berbeda tapi id sama
        artist: 'Artist',
        album: 'Album',
        filePath: '/path.mp3',
        duration: Duration.zero,
      );
      expect(song1, equals(song2));
    });

    // Test 4: Factory fromMap
    test('SongModel.fromMap() bekerja dengan benar', () {
      final map = {
        'id': 5,
        'title': 'Map Song',
        'artist': 'Map Artist',
        'album': 'Map Album',
        'filePath': '/map/path.mp3',
        'duration': 180000, // 3 menit dalam ms
      };

      final song = SongModel.fromMap(map);
      expect(song.id, 5);
      expect(song.duration.inMinutes, 3);
    });

    // Test 5: copyWith
    test('copyWith menghasilkan salinan dengan nilai baru', () {
      final original = SongModel(
        id: 1,
        title: 'Original',
        artist: 'Artist',
        album: 'Album',
        filePath: '/path.mp3',
        duration: Duration.zero,
      );

      final copy = original.copyWith(title: 'Modified');
      expect(copy.title, 'Modified');
      expect(copy.artist, 'Artist'); // Tidak berubah
    });
  });

  group('PlayerController Tests', () {
    late PlayerController controller;

    setUp(() {
      controller = PlayerController();
    });

    tearDown(() {
      controller.dispose();
    });

    // Test 6: State awal
    test('State awal PlayerController benar', () {
      expect(controller.isPlaying, false);
      expect(controller.currentSong, null);
      expect(controller.currentIndex, -1);
      expect(controller.progress, 0.0);
    });

    // Test 7: Playlist terisi data dummy
    test('Playlist awal tidak kosong (data dummy)', () {
      expect(controller.playlist.isNotEmpty, true);
    });

    // Test 8: Toggle shuffle
    test('toggleShuffle mengubah nilai isShuffled', () {
      expect(controller.isShuffled, false);
      controller.toggleShuffle();
      expect(controller.isShuffled, true);
      controller.toggleShuffle();
      expect(controller.isShuffled, false);
    });

    // Test 9: Cycle repeat mode
    test('cycleRepeatMode berjalan none → one → all → none', () {
      expect(controller.repeatMode, RepeatMode.none);
      controller.cycleRepeatMode();
      expect(controller.repeatMode, RepeatMode.one);
      controller.cycleRepeatMode();
      expect(controller.repeatMode, RepeatMode.all);
      controller.cycleRepeatMode();
      expect(controller.repeatMode, RepeatMode.none);
    });

    // Test 10: addSong dan removeSong
    test('addSong menambah lagu ke playlist', () {
      final initialLength = controller.playlist.length;
      final newSong = SongModel(
        id: 999,
        title: 'New Song',
        artist: 'New Artist',
        album: 'New Album',
        filePath: '/new.mp3',
        duration: Duration.zero,
      );
      controller.addSong(newSong);
      expect(controller.playlist.length, initialLength + 1);
    });
  });

  group('FormatUtils Tests', () {
    test('Duration 0 diformat ke 00:00', () {
      final song = SongModel(
        id: 1, title: '', artist: '', album: '',
        filePath: '', duration: Duration.zero,
      );
      expect(song.formattedDuration, '00:00');
    });
  });
}
