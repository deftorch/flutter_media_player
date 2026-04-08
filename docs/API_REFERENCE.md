# 📚 API Reference — Flutter Media Player

Dokumen ini berisi referensi lengkap semua kelas, method, dan properti yang tersedia.

---

## PlayerController

**File:** `lib/controllers/player_controller.dart`  
**Extends:** `ChangeNotifier`

Controller utama yang mengelola semua logika pemutaran audio.

---

### Enumerasi

#### `PlayerState`
| Nilai | Deskripsi |
|-------|-----------|
| `idle` | Belum ada lagu dipilih |
| `loading` | Sedang memuat file audio |
| `playing` | Sedang memutar lagu |
| `paused` | Pemutaran di-pause |
| `stopped` | Pemutaran dihentikan |
| `error` | Terjadi kesalahan |

#### `RepeatMode`
| Nilai | Deskripsi |
|-------|-----------|
| `none` | Tidak mengulang |
| `one` | Mengulang satu lagu terus-menerus |
| `all` | Mengulang seluruh playlist |

---

### Properti (Getters)

| Properti | Tipe | Deskripsi |
|----------|------|-----------|
| `playlist` | `List<SongModel>` | Semua lagu dalam playlist |
| `currentSong` | `SongModel?` | Lagu yang sedang aktif (null jika tidak ada) |
| `currentIndex` | `int` | Index lagu aktif (-1 jika tidak ada) |
| `playerState` | `PlayerState` | Status pemutar saat ini |
| `currentPosition` | `Duration` | Posisi pemutaran saat ini |
| `totalDuration` | `Duration` | Total durasi lagu aktif |
| `progress` | `double` | Kemajuan 0.0–1.0 |
| `repeatMode` | `RepeatMode` | Mode pengulangan aktif |
| `isPlaying` | `bool` | true jika sedang memutar |
| `isLoading` | `bool` | true jika sedang loading |
| `isShuffled` | `bool` | true jika mode acak aktif |
| `hasNext` | `bool` | true jika ada lagu berikutnya |
| `hasPrevious` | `bool` | true jika ada lagu sebelumnya |
| `errorMessage` | `String?` | Pesan error terakhir |

---

### Method Pemutaran

#### `playSong(int index) → Future<void>`
Memutar lagu berdasarkan index di playlist.

```dart
// Contoh penggunaan:
await playerCtrl.playSong(0); // Putar lagu pertama
```

**Parameter:**
- `index` — Index lagu di dalam `playlist` (0-based)

**Efek samping:**
- Mengubah `currentSong`, `currentIndex`, `playerState`
- Memanggil `notifyListeners()`

---

#### `pause() → Future<void>`
Menjeda pemutaran yang sedang berjalan.

```dart
await playerCtrl.pause();
```

---

#### `resume() → Future<void>`
Melanjutkan pemutaran yang sedang dijeda.

```dart
await playerCtrl.resume();
```

---

#### `togglePlayPause() → Future<void>`
Toggle antara play dan pause. Jika playing → pause, jika paused → resume.

```dart
// Digunakan di tombol play/pause
await playerCtrl.togglePlayPause();
```

---

#### `stop() → Future<void>`
Menghentikan pemutaran dan mereset posisi ke awal.

```dart
await playerCtrl.stop();
```

---

#### `next() → Future<void>`
Pindah ke lagu berikutnya. Mempertimbangkan mode shuffle dan repeat.

```dart
await playerCtrl.next();
```

---

#### `previous() → Future<void>`
Kembali ke lagu sebelumnya. Jika posisi > 3 detik, akan restart lagu dulu.

```dart
await playerCtrl.previous();
```

---

#### `seekTo(Duration position) → Future<void>`
Loncat ke posisi waktu tertentu.

```dart
// Loncat ke detik ke-60
await playerCtrl.seekTo(const Duration(seconds: 60));
```

---

#### `seekToProgress(double progress) → Future<void>`
Seek berdasarkan persentase (0.0 – 1.0). Digunakan oleh Slider widget.

```dart
// Loncat ke tengah lagu
await playerCtrl.seekToProgress(0.5);
```

---

### Method Pengaturan

#### `toggleShuffle() → void`
Mengaktifkan/menonaktifkan mode acak.

```dart
playerCtrl.toggleShuffle();
print(playerCtrl.isShuffled); // true / false
```

---

#### `cycleRepeatMode() → void`
Mengganti mode repeat secara berurutan: none → one → all → none.

```dart
playerCtrl.cycleRepeatMode();
print(playerCtrl.repeatMode); // RepeatMode.one
```

---

### Method Playlist

#### `addSong(SongModel song) → void`
Menambahkan lagu ke akhir playlist.

```dart
playerCtrl.addSong(newSong);
```

---

#### `removeSong(int index) → void`
Menghapus lagu berdasarkan index. Jika lagu yang dihapus sedang diputar, pemutaran dihentikan.

```dart
playerCtrl.removeSong(2); // Hapus lagu index ke-2
```

---

#### `setPlaylist(List<SongModel> songs) → void`
Mengganti seluruh playlist dengan daftar baru.

```dart
playerCtrl.setPlaylist(newSongList);
```

---

## SongModel

**File:** `lib/models/song_model.dart`

Model data yang merepresentasikan satu lagu.

---

### Konstruktor

```dart
SongModel({
  required int id,
  required String title,
  required String artist,
  required String album,
  required String filePath,
  required Duration duration,
  String? artworkPath,
  int? fileSize,
})
```

---

### Properti

| Properti | Tipe | Wajib | Deskripsi |
|----------|------|-------|-----------|
| `id` | `int` | ✅ | ID unik lagu |
| `title` | `String` | ✅ | Judul lagu |
| `artist` | `String` | ✅ | Nama artis |
| `album` | `String` | ✅ | Nama album |
| `filePath` | `String` | ✅ | Path file audio |
| `duration` | `Duration` | ✅ | Durasi total |
| `artworkPath` | `String?` | ❌ | Path gambar cover |
| `fileSize` | `int?` | ❌ | Ukuran file (bytes) |
| `formattedDuration` | `String` | (getter) | Format "mm:ss" |

---

### Factory & Method

#### `SongModel.fromMap(Map<String, dynamic> map)`
Membuat SongModel dari Map/JSON.

```dart
final song = SongModel.fromMap({
  'id': 1,
  'title': 'Judul',
  'artist': 'Artis',
  'album': 'Album',
  'filePath': '/path.mp3',
  'duration': 210000, // ms
});
```

---

#### `toMap() → Map<String, dynamic>`
Mengubah SongModel ke Map untuk disimpan ke database.

```dart
final map = song.toMap();
// {'id': 1, 'title': 'Judul', ...}
```

---

#### `copyWith({...}) → SongModel`
Membuat salinan dengan nilai yang diubah.

```dart
final updated = song.copyWith(title: 'Judul Baru');
```

---

## Widget Reference

### `SongTile`

Widget item lagu untuk `ListView`.

**Parameter:**
| Parameter | Tipe | Deskripsi |
|-----------|------|-----------|
| `song` | `SongModel` | Data lagu |
| `isActive` | `bool` | Apakah lagu ini sedang aktif |
| `isPlaying` | `bool` | Apakah sedang diputar |
| `onTap` | `VoidCallback` | Callback saat ditekan |

---

### `PlayerControls`

Widget kontrol pemutaran (prev/play/pause/next/shuffle/repeat).

**Parameter:**
| Parameter | Tipe | Deskripsi |
|-----------|------|-----------|
| `controller` | `PlayerController` | Instance controller |

---

### `ProgressBarWidget`

Slider progress dengan label waktu.

**Parameter:**
| Parameter | Tipe | Deskripsi |
|-----------|------|-----------|
| `currentPosition` | `Duration` | Posisi saat ini |
| `totalDuration` | `Duration` | Total durasi |
| `progress` | `double` | Nilai 0.0–1.0 |
| `onSeek` | `ValueChanged<double>` | Callback saat drag slider |

---

### `AlbumArtWidget`

Gambar album dengan animasi berputar.

**Parameter:**
| Parameter | Tipe | Deskripsi |
|-----------|------|-----------|
| `artworkPath` | `String?` | Path gambar (null = placeholder) |
| `isPlaying` | `bool` | Kontrol animasi rotasi |

---

### `MiniPlayer`

Mini player yang muncul di HomeScreen.

**Parameter:**
| Parameter | Tipe | Deskripsi |
|-----------|------|-----------|
| `onTap` | `VoidCallback` | Callback saat player ditekan |
