# 📐 Dokumentasi Arsitektur — Flutter Media Player

## Pendahuluan

Dokumen ini menjelaskan secara detail arsitektur dan keputusan desain yang digunakan dalam proyek Flutter Media Player.

---

## Pola Arsitektur: MVC + Provider

### Mengapa MVC?

MVC (Model-View-Controller) dipilih karena:

1. **Mudah dipahami** — Pemisahan tanggung jawab yang jelas
2. **Mudah diuji** — Model dan Controller bisa di-test tanpa UI
3. **Mudah dikembangkan** — Perubahan di satu layer tidak mempengaruhi layer lain
4. **Standar industri** — Banyak digunakan di berbagai platform

### Mengapa Provider?

Provider adalah package resmi dari tim Flutter untuk manajemen state. Dipilih karena:
- Sederhana dan mudah dipahami
- Terintegrasi baik dengan ChangeNotifier
- Tidak memerlukan boilerplate code yang banyak
- Cocok untuk proyek berskala kecil-menengah

---

## Diagram Komponen

```
┌───────────────────────────────────────────────┐
│                 PRESENTATION LAYER             │
│                                               │
│  ┌─────────────┐  ┌──────────────┐            │
│  │ SplashScreen│  │  HomeScreen  │            │
│  └─────────────┘  └──────┬───────┘            │
│                          │                    │
│                   ┌──────▼───────┐            │
│                   │ PlayerScreen │            │
│                   └──────┬───────┘            │
│                          │                    │
│    ┌─────────────────────▼──────────────────┐ │
│    │              WIDGETS                   │ │
│    │  SongTile │ PlayerControls │ MiniPlayer │ │
│    │  AlbumArt │ ProgressBar                │ │
│    └───────────────────────────────────────-┘ │
└────────────────────┬──────────────────────────┘
                     │ Provider.watch/read
                     │ Consumer<T>
┌────────────────────▼──────────────────────────┐
│                 BUSINESS LOGIC LAYER           │
│                                               │
│         ┌──────────────────────┐              │
│         │   PlayerController   │              │
│         │  (ChangeNotifier)    │              │
│         │                      │              │
│         │ - playlist: List     │              │
│         │ - currentSong        │              │
│         │ - playerState        │              │
│         │ - currentPosition    │              │
│         │                      │              │
│         │ + playSong()         │              │
│         │ + pause()            │              │
│         │ + next()             │              │
│         │ + seekTo()           │              │
│         └──────────┬───────────┘              │
└────────────────────┼──────────────────────────┘
                     │ uses
┌────────────────────▼──────────────────────────┐
│                   DATA LAYER                   │
│                                               │
│  ┌──────────────┐    ┌─────────────────────┐  │
│  │  SongModel   │    │    just_audio        │  │
│  │              │    │   (AudioPlayer)      │  │
│  │ - id         │    │                     │  │
│  │ - title      │    │ - setAsset()        │  │
│  │ - artist     │    │ - play()            │  │
│  │ - duration   │    │ - pause()           │  │
│  │ - filePath   │    │ - seek()            │  │
│  └──────────────┘    └─────────────────────┘  │
└───────────────────────────────────────────────┘
```

---

## Alur Data (Data Flow)

### Skenario: User Menekan Tombol Play

```
1. User tap tombol ▶️ di PlayerControls widget

2. PlayerControls memanggil:
   controller.togglePlayPause()
   (controller didapat dari Provider)

3. PlayerController.togglePlayPause() dieksekusi:
   - Jika isPlaying → panggil pause()
   - Jika paused   → panggil resume()
   
4. AudioPlayer.play() atau pause() dipanggil
   (package just_audio)

5. _playerState diupdate:
   _playerState = PlayerState.playing;
   
6. notifyListeners() dipanggil
   → Semua widget yang listen akan rebuild

7. Widget rebuild:
   - Ikon tombol berubah (▶️ → ⏸️)
   - AlbumArt mulai berputar
   - Progress bar mulai bergerak
```

### Skenario: Progress Bar Update

```
AudioPlayer.positionStream
    │ (emit setiap detik)
    ▼
PlayerController._initStreams()
    │ listener aktif
    ▼
_currentPosition = position;
notifyListeners();
    │
    ▼
ProgressBarWidget rebuild
    │
    ▼
Slider.value = playerCtrl.progress
```

---

## Manajemen State

### State yang Dikelola PlayerController

| State | Tipe | Deskripsi |
|-------|------|-----------|
| `_playlist` | `List<SongModel>` | Semua lagu |
| `_currentSong` | `SongModel?` | Lagu aktif |
| `_currentIndex` | `int` | Index lagu aktif |
| `_playerState` | `PlayerState` | Status pemutar |
| `_currentPosition` | `Duration` | Posisi saat ini |
| `_repeatMode` | `RepeatMode` | Mode pengulangan |
| `_isShuffled` | `bool` | Mode acak |

### Kapan notifyListeners() Dipanggil?

```dart
// Setiap kali ada perubahan state yang perlu diupdate di UI:
void playSong(int index) async {
  _playerState = PlayerState.loading;
  notifyListeners(); // ← UI tampilkan loading
  
  await _audioPlayer.play();
  
  _playerState = PlayerState.playing;
  notifyListeners(); // ← UI tampilkan play button
}
```

---

## Widget Tree Simplified

```
MaterialApp
└── MultiProvider
    └── HomeScreen (Consumer<PlayerController>)
        ├── AppBar
        ├── ListView
        │   └── SongTile (× n)
        └── MiniPlayer (Consumer<PlayerController>)
            └── [Tap] → PlayerScreen (Consumer<PlayerController>)
                ├── AlbumArtWidget
                ├── SongInfo (Text widgets)
                ├── ProgressBarWidget
                └── PlayerControls
```

---

## Keputusan Teknis

### 1. Menggunakan `ChangeNotifier` bukan `Stream`

ChangeNotifier dipilih karena lebih sederhana untuk use case ini. Stream cocok untuk data yang terus mengalir (seperti posisi audio), tapi untuk state UI seperti isPlaying, ChangeNotifier lebih mudah dimanage.

### 2. Menggunakan `Consumer` bukan `context.watch`

```dart
// Consumer: hanya rebuild child yang relevan
Consumer<PlayerController>(
  builder: (context, ctrl, child) {
    return Text(ctrl.currentSong?.title ?? '');
  }
)

// context.watch: rebuild seluruh build method
// Hindari ini di widget besar!
```

### 3. Immutable SongModel

SongModel menggunakan `final` untuk semua field. Keuntungan:
- Tidak ada bug akibat perubahan data tak terduga
- Lebih aman untuk concurrent operations
- Mudah di-cache dan dibandingkan

---

## Cara Extend (Pengembangan Lanjutan)

### Menambah Fitur Baru

1. **Tambah state** di `PlayerController`:
```dart
bool _isFavorite = false;
bool get isFavorite => _isFavorite;

void toggleFavorite() {
  _isFavorite = !_isFavorite;
  notifyListeners();
}
```

2. **Tambah UI** di widget yang sesuai:
```dart
IconButton(
  icon: Icon(ctrl.isFavorite ? Icons.favorite : Icons.favorite_border),
  onPressed: ctrl.toggleFavorite,
)
```

3. **Tambah test**:
```dart
test('toggleFavorite berfungsi', () {
  expect(ctrl.isFavorite, false);
  ctrl.toggleFavorite();
  expect(ctrl.isFavorite, true);
});
```
