# 🎓 SLIDE PRESENTASI
## Aplikasi Pemutar Media dengan Flutter
### Mata Kuliah: Pemrograman Mobile

---

---

# SLIDE 1 — COVER

```
╔══════════════════════════════════════════════════╗
║                                                  ║
║          🎵 FLUTTER MEDIA PLAYER                 ║
║                                                  ║
║     Aplikasi Pemutar Musik Berbasis Flutter      ║
║                                                  ║
║  ─────────────────────────────────────────────  ║
║                                                  ║
║  Nama   : [Nama Mahasiswa]                       ║
║  NIM    : [NIM]                                  ║
║  Kelas  : [Kelas]                                ║
║  Dosen  : [Nama Dosen]                           ║
║                                                  ║
║  Mata Kuliah: Pemrograman Mobile                 ║
║  [Tahun Akademik]                                ║
║                                                  ║
╚══════════════════════════════════════════════════╝
```

---

---

# SLIDE 2 — LATAR BELAKANG

## Latar Belakang

**Mengapa membuat aplikasi pemutar musik?**

- 📱 Musik adalah kebutuhan sehari-hari pengguna smartphone
- 🛠️ Flutter memungkinkan pengembangan cross-platform yang efisien
- 📚 Proyek ini mencakup konsep penting: State Management, OOP, dan UI Design
- 🎯 Tujuan pembelajaran: menguasai arsitektur MVC pada Flutter

**Rumusan Masalah:**
> Bagaimana membangun aplikasi pemutar media yang bersih, terstruktur, dan mudah dipelihara menggunakan Flutter?

---

---

# SLIDE 3 — TUJUAN & MANFAAT

## Tujuan Proyek

✅ Mengimplementasikan arsitektur **MVC** pada Flutter  
✅ Menerapkan **Provider** untuk manajemen state  
✅ Menggunakan package **just_audio** untuk pemutaran audio  
✅ Membuat UI yang **responsif** dan **intuitif**  
✅ Menulis **unit test** untuk menjamin kualitas kode

## Manfaat

| Bagi Pengguna | Bagi Developer |
|---------------|----------------|
| Memutar musik lokal | Belajar arsitektur MVC |
| Kontrol lengkap | Belajar Provider pattern |
| Antarmuka modern | Belajar just_audio API |
| Mode shuffle & repeat | Belajar unit testing |

---

---

# SLIDE 4 — ARSITEKTUR APLIKASI

## Arsitektur MVC + Provider

```
┌─────────────────────────────────┐
│             VIEW                │
│  (HomeScreen, PlayerScreen)     │
│  → Menampilkan data ke user     │
│  → Menerima input dari user     │
└──────────────┬──────────────────┘
               │ Consumer<PlayerController>
               │ context.read<PlayerController>()
┌──────────────▼──────────────────┐
│          CONTROLLER             │
│       (PlayerController)        │
│  → Logika bisnis                │
│  → Mengatur AudioPlayer         │
│  → notifyListeners() → UI update│
└──────────────┬──────────────────┘
               │ read/write
┌──────────────▼──────────────────┐
│             MODEL               │
│          (SongModel)            │
│  → Struktur data lagu           │
│  → Validasi data                │
└─────────────────────────────────┘
```

---

---

# SLIDE 5 — STRUKTUR FOLDER

## Struktur Proyek

```
lib/
├── main.dart              ← Entry point
├── models/
│   └── song_model.dart    ← Data lagu (M)
├── controllers/
│   └── player_controller  ← Logika (C)
├── views/
│   ├── splash_screen      ← Halaman loading
│   ├── home_screen        ← Daftar lagu (V)
│   └── player_screen      ← Pemutar (V)
├── widgets/
│   ├── song_tile          ← Item list
│   ├── player_controls    ← Tombol kontrol
│   ├── album_art_widget   ← Cover album
│   ├── progress_bar       ← Slider
│   └── mini_player        ← Mini pemutar
├── theme/
│   └── app_theme          ← Konfigurasi warna
└── utils/
    └── format_utils       ← Helper functions
```

---

---

# SLIDE 6 — FITUR APLIKASI

## Fitur yang Diimplementasikan

| No | Fitur | Status |
|----|-------|--------|
| 1 | Daftar lagu dari storage | ✅ |
| 2 | Play / Pause | ✅ |
| 3 | Next / Previous | ✅ |
| 4 | Progress bar dengan seek | ✅ |
| 5 | Mode Shuffle | ✅ |
| 6 | Mode Repeat (None/One/All) | ✅ |
| 7 | Pencarian lagu | ✅ |
| 8 | Mini Player | ✅ |
| 9 | Animasi album art berputar | ✅ |
| 10 | Animasi equalizer | ✅ |
| 11 | Dark mode | ✅ |
| 12 | Detail lagu | ✅ |

---

---

# SLIDE 7 — TEKNOLOGI

## Stack Teknologi

### Framework & Bahasa
- **Flutter** 3.x — UI Framework cross-platform
- **Dart** 3.x — Bahasa pemrograman

### Package Utama
```yaml
dependencies:
  just_audio: ^0.9.36     # Engine audio
  provider: ^6.1.1        # State management
  on_audio_query: ^2.9.0  # Baca lagu dari storage
  permission_handler: ^11  # Izin storage
  animations: ^2.0.8      # Animasi Material
```

---

---

# SLIDE 8 — DEMO KODE: MODEL

## SongModel — Layer Data

```dart
class SongModel {
  final int id;
  final String title;
  final String artist;
  final String album;
  final String filePath;
  final Duration duration;

  // Format durasi ke "mm:ss"
  String get formattedDuration {
    final m = duration.inMinutes;
    final s = duration.inSeconds % 60;
    return '${m.padLeft(2,'0')}:${s.padLeft(2,'0')}';
  }
}
```

**Konsep yang digunakan:**
- Immutable object (semua field `final`)
- Getter computed property
- Factory constructor (fromMap)
- Operator overloading (==)

---

---

# SLIDE 9 — DEMO KODE: CONTROLLER

## PlayerController — Layer Logika

```dart
class PlayerController extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  SongModel? _currentSong;
  bool _isPlaying = false;

  // Method untuk memutar lagu
  Future<void> playSong(int index) async {
    _currentSong = _playlist[index];
    
    await _audioPlayer.setAsset(song.filePath);
    await _audioPlayer.play();
    
    _isPlaying = true;
    notifyListeners(); // ← Kasih tahu UI untuk update!
  }
}
```

**Konsep yang digunakan:**
- ChangeNotifier pattern
- Async/await
- Enkapsulasi (private field)
- notifyListeners()

---

---

# SLIDE 10 — DEMO KODE: VIEW

## HomeScreen — Layer Tampilan

```dart
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerController>(
      builder: (context, playerCtrl, _) {
        return Scaffold(
          body: ListView.builder(
            itemCount: playerCtrl.playlist.length,
            itemBuilder: (_, index) => SongTile(
              song: playerCtrl.playlist[index],
              onTap: () => playerCtrl.playSong(index),
            ),
          ),
        );
      },
    );
  }
}
```

**Konsep yang digunakan:**
- Consumer (mendengarkan perubahan state)
- ListView.builder (efisien untuk list panjang)
- Widget composition

---

---

# SLIDE 11 — ALUR KERJA

## Flowchart Pemutaran Lagu

```
App Dibuka
    │
    ▼
SplashScreen (2.5 detik)
    │
    ▼
HomeScreen
(Tampilkan daftar lagu)
    │
    │ [User tap lagu]
    ▼
PlayerController.playSong()
    │
    ├── setAsset(filePath)
    ├── play()
    └── notifyListeners()
         │
         ▼
    UI Rebuild:
    ├── PlayerScreen muncul
    ├── Album art berputar
    ├── Progress bar bergerak
    └── Tombol berubah ke pause
```

---

---

# SLIDE 12 — HASIL & KESIMPULAN

## Hasil Akhir

✅ Aplikasi berhasil dibuat dengan **12 fitur utama**  
✅ Arsitektur MVC **terpisah** dengan jelas  
✅ **10 unit test** berhasil dijalankan  
✅ UI menggunakan Material Design 3  
✅ Support dark mode otomatis  

## Kesimpulan

1. **Flutter** sangat cocok untuk pengembangan aplikasi mobile lintas platform
2. **Arsitektur MVC** memudahkan pemeliharaan dan pengembangan kode
3. **Provider** adalah solusi state management yang sederhana dan efektif
4. **just_audio** menyediakan API yang lengkap dan mudah digunakan

## Saran Pengembangan

- Tambah fitur equalizer audio
- Integrasi streaming musik online
- Fitur playlist buatan pengguna
- Sinkronisasi lirik lagu

---

---

# SLIDE 13 — REFERENSI

## Daftar Referensi

1. Flutter Team. (2024). *Flutter Documentation*. https://flutter.dev/docs

2. Hieu, N. (2024). *just_audio Package*. https://pub.dev/packages/just_audio

3. Rousselet, R. (2024). *Provider Package*. https://pub.dev/packages/provider

4. Luciani, S. (2024). *on_audio_query Package*. https://pub.dev/packages/on_audio_query

5. Google. (2024). *Material Design 3 Guidelines*. https://m3.material.io

6. Dart Team. (2024). *Dart Language Tour*. https://dart.dev/guides/language/language-tour

---

---

# SLIDE 14 — TANYA JAWAB

```
╔══════════════════════════════════════════════════╗
║                                                  ║
║                                                  ║
║            ❓ TANYA JAWAB ❓                     ║
║                                                  ║
║                                                  ║
║        Terima kasih atas perhatiannya!           ║
║                                                  ║
║    Silakan ajukan pertanyaan Anda 🙏             ║
║                                                  ║
║                                                  ║
╚══════════════════════════════════════════════════╝
```
