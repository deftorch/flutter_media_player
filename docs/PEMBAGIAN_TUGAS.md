# DOKUMENTASI PEMBAGIAN TUGAS KELOMPOK
## Proyek Flutter Media Player

> **Mata Kuliah:** Pemrograman Mobile  
> **Framework:** Flutter / Dart | **Arsitektur:** MVC + Provider

---

> **Jumlah Anggota:** 3 Orang | **Total File:** 15 File Dart  
> **Prinsip Pembagian:** Sesuai Layer MVC + Pemerataan Beban Kerja

---

## 1. Ringkasan Proyek

Flutter Media Player adalah aplikasi pemutar musik berbasis Flutter yang dibangun dengan arsitektur MVC (Model-View-Controller) dan state management menggunakan Provider. Proyek ini merupakan tugas mata kuliah Pemrograman Mobile.

### 1.1 Struktur Proyek

| Layer / Folder | File | Fungsi |
|---|---|---|
| `models/` | `song_model.dart` | Struktur data lagu |
| `controllers/` | `player_controller.dart` | Logika bisnis & state |
| `views/` | `splash_screen.dart` | Halaman splash/loading |
| `views/` | `home_screen.dart` | Daftar lagu |
| `views/` | `player_screen.dart` | Halaman pemutar |
| `widgets/` | `song_tile.dart` | Item lagu di list |
| `widgets/` | `player_controls.dart` | Tombol play/pause/next |
| `widgets/` | `album_art_widget.dart` | Gambar album berputar |
| `widgets/` | `progress_bar_widget.dart` | Slider durasi & seek |
| `widgets/` | `mini_player.dart` | Mini player di HomeScreen |
| `theme/` | `app_theme.dart` | Konfigurasi tema warna |
| `utils/` | `format_utils.dart` | Fungsi utilitas |
| — | `main.dart` | Entry point aplikasi |
| `test/` | `player_controller_test.dart` | Unit testing |

---

## 2. Prinsip Pembagian Tugas

Pembagian tugas dilakukan berdasarkan tiga prinsip utama:

- **Berbasis Layer MVC** — setiap anggota memiliki layer utama yang menjadi tanggung jawabnya sehingga konflik merge Git dapat diminimalkan.
- **Pemerataan beban kerja** — jumlah file dan tingkat kompleksitas diseimbangkan di antara ketiga anggota.
- **Keterkaitan logis** — file yang saling berhubungan erat dikerjakan oleh anggota yang sama agar kohesi kode terjaga.

---

## 3. Pembagian Tugas Per Anggota

### 👤 ANGGOTA 1 — Backend & Logic (Model, Controller, Utils, Testing)

Anggota 1 bertanggung jawab atas seluruh layer Model dan Controller yang merupakan inti (otak) dari aplikasi. Semua logika bisnis, manajemen state, dan pengujian ada di bagian ini.

**File yang Dikerjakan:**

| File | Lokasi | Deskripsi Tugas |
|---|---|---|
| `song_model.dart` | `lib/models/` | Buat class SongModel: id, title, artist, album, filePath, duration, artworkPath. Tambahkan factory `fromMap()`, `toMap()`, `copyWith()`, dan override `toString()`/`==` |
| `player_controller.dart` | `lib/controllers/` | Implementasi PlayerController (ChangeNotifier): play/pause/stop, next/prev, seek, shuffle, repeat mode, stream listener dari just_audio, `notifyListeners()` |
| `format_utils.dart` | `lib/utils/` | Fungsi utilitas: `formatDuration()`, `formatFileSize()`, `truncateTitle()`. Pastikan tidak ada dependency ke Flutter (pure Dart). |
| `main.dart` | `lib/` | Setup MultiProvider, wrap MyApp, registrasikan PlayerController, konfigurasi `ThemeMode.system` |
| `player_controller_test.dart` | `test/` | Tulis unit test: test play/pause state, test next/prev index, test repeat mode toggle, test shuffle, test seek. Pastikan coverage >= 80%. |

**Fitur Aplikasi yang Dikover:**
- Play / Pause / Stop logic
- Next / Previous song navigation
- Repeat Mode: None → One → All
- Shuffle toggle
- Seek / progress position
- Unit testing semua method controller

> **Estimasi Kompleksitas: Tinggi**  
> `player_controller.dart` adalah file terbesar dan terkompleks (~11 KB, ~300 baris). Anggota ini disarankan memulai pengerjaan lebih awal agar Anggota 2 dan 3 dapat bergantung pada kontrak API-nya.

---

### 👤 ANGGOTA 2 — UI Screens & Theme (Views + Theme)

Anggota 2 bertanggung jawab atas semua halaman (screen) aplikasi dan sistem tema. Ini adalah wajah utama aplikasi yang langsung dilihat pengguna.

**File yang Dikerjakan:**

| File | Lokasi | Deskripsi Tugas |
|---|---|---|
| `splash_screen.dart` | `lib/views/` | Animasi logo/nama app, delay 2.5 detik, navigasi ke HomeScreen. Gunakan `AnimationController` atau `Future.delayed`. |
| `home_screen.dart` | `lib/views/` | ListView semua lagu dari `controller.playlist`, search/filter bar, `Consumer<PlayerController>` untuk render ulang, trigger navigasi ke PlayerScreen saat tap |
| `player_screen.dart` | `lib/views/` | Tampilan fullscreen player: AlbumArtWidget, judul/artis lagu, ProgressBarWidget, PlayerControls. Konsumsi state dari PlayerController via Consumer. |
| `app_theme.dart` | `lib/theme/` | Definisikan `lightTheme` dan `darkTheme` menggunakan ThemeData Material 3. Tentukan ColorScheme, typography, dan warna utama (biru/ungu). |

**Fitur Aplikasi yang Dikover:**
- Halaman splash/loading awal
- Daftar lagu di HomeScreen
- Fungsi pencarian/filter lagu
- Tampilan fullscreen PlayerScreen
- Dark mode / Light mode otomatis

> **Estimasi Kompleksitas: Tinggi**  
> `player_screen.dart` adalah file terbesar kedua (~11 KB). Anggota ini perlu berkoordinasi dengan Anggota 1 untuk memahami method yang tersedia di PlayerController, dan dengan Anggota 3 untuk menggunakan widget yang disediakan.

---

### 👤 ANGGOTA 3 — Widgets, Assets & Dokumentasi

Anggota 3 bertanggung jawab atas semua komponen UI reusable (widget), konfigurasi platform Android, setup aset, dan dokumentasi proyek.

**File yang Dikerjakan:**

| File | Lokasi | Deskripsi Tugas |
|---|---|---|
| `song_tile.dart` | `lib/widgets/` | Widget satu item lagu di ListView: tampilkan thumbnail, judul, artis, durasi. Highlight jika sedang diputar. |
| `player_controls.dart` | `lib/widgets/` | Row tombol: shuffle, previous, play/pause, next, repeat. IconButton yang memanggil method PlayerController. |
| `album_art_widget.dart` | `lib/widgets/` | Image bulat dengan AnimationController: berputar saat playing, berhenti saat pause. |
| `progress_bar_widget.dart` | `lib/widgets/` | Slider posisi lagu: tampilkan `currentPosition` & `totalDuration`, `onChanged` memanggil `seekTo()`. |
| `mini_player.dart` | `lib/widgets/` | Bottom bar di HomeScreen: thumbnail kecil, judul, tombol play/pause, tombol next. |
| `AndroidManifest.xml` | `android/app/src/main/` | Tambahkan permission: `READ_EXTERNAL_STORAGE`, `READ_MEDIA_AUDIO`. Pastikan uses-permission sudah lengkap. |
| `pubspec.yaml` | `root/` | Daftarkan semua assets (audio/, images/), pastikan dependencies sudah benar. |
| `docs/` (semua file) | `docs/` | Update/lengkapi `ARCHITECTURE.md`, `API_REFERENCE.md`, `FLOWCHART.md`, `SETUP_GUIDE.md`, `SLIDE_PRESENTASI.md` setelah implementasi selesai. |

**Fitur Aplikasi yang Dikover:**
- Komponen SongTile di daftar lagu
- Kontrol player (tombol play/pause/next)
- Album art berputar (animasi)
- Progress bar interaktif
- Mini player di halaman utama
- Konfigurasi permission Android
- Dokumentasi teknis proyek

---

## 4. Tabel Ringkasan Pembagian

| Anggota | Layer Utama | File Utama | Fitur Utama |
|---|---|---|---|
| Anggota 1 | Model + Controller + Utils + Test | `song_model.dart`, `player_controller.dart`, `format_utils.dart`, `main.dart`, `*_test.dart` | Logic bisnis, state mgmt, unit test |
| Anggota 2 | Views + Theme | `splash_screen.dart`, `home_screen.dart`, `player_screen.dart`, `app_theme.dart` | Semua halaman, dark/light mode |
| Anggota 3 | Widgets + Config + Docs | 5 widget files, `AndroidManifest.xml`, `pubspec.yaml`, `docs/` | Semua komponen UI, konfigurasi, dokumentasi |

| Metrik | Anggota 1 | Anggota 2 | Anggota 3 |
|---|---|---|---|
| Jumlah file Dart | 5 file | 4 file | 5 file + config |
| Estimasi ukuran kode | ~18 KB | ~24 KB | ~19 KB + docs |
| Tingkat kompleksitas | Tinggi | Tinggi | Sedang-Tinggi |
| Bergantung pada | — | Anggota 1 (API) | Anggota 1 (API) |

---

## 5. Alur Kerja & Koordinasi Tim

### 5.1 Urutan Pengerjaan yang Direkomendasikan

| Fase | Waktu | Aktivitas | PIC |
|---|---|---|---|
| Fase 1 | Hari 1-2 | Anggota 1 membuat SongModel dan kontrak API PlayerController (method signatures). Anggota 3 setup pubspec.yaml dan assets. | A1 + A3 |
| Fase 2 | Hari 3-5 | Anggota 1 implementasi penuh PlayerController. Anggota 2 mulai SplashScreen dan AppTheme. Anggota 3 mulai widget statis. | Semua |
| Fase 3 | Hari 6-8 | Anggota 2 implementasi HomeScreen dan PlayerScreen. Anggota 3 implementasi widget interaktif. Anggota 1 mulai unit test. | Semua |
| Fase 4 | Hari 9-10 | Integrasi semua komponen, bug fixing, lengkapi dokumentasi (Anggota 3). | Semua |
| Fase 5 | Hari 11 | Final review, build APK, persiapan presentasi. | Semua |

### 5.2 Aturan Git & Kolaborasi

- Gunakan branch terpisah: `feature/anggota1-backend`, `feature/anggota2-views`, `feature/anggota3-widgets`
- Merge ke `main` hanya via Pull Request yang di-review minimal 1 anggota lain
- Commit message menggunakan format: `[A1] feat: tambahkan method playSong()`
- Hindari mengedit file milik anggota lain tanpa koordinasi terlebih dahulu
- Adakan sinkronisasi singkat setiap hari (5-10 menit) untuk memastikan tidak ada konflik

### 5.3 Titik Koordinasi Kritis

| Topik Koordinasi | Pihak yang Terlibat | Kapan |
|---|---|---|
| Daftar method & signature PlayerController | A1 → A2, A3 | Akhir Fase 1 |
| Ukuran & format artworkPath di SongModel | A1 ↔ A3 (AlbumArt) | Fase 2 |
| Cara konsumsi provider di PlayerScreen | A1 ↔ A2 | Awal Fase 3 |
| Integrasi MiniPlayer ke HomeScreen | A2 ↔ A3 | Fase 3 |
| Final review dokumentasi & slide presentasi | Semua → A3 | Fase 5 |

---

## 6. Matriks Fitur vs Anggota

| Fitur | Anggota 1 | Anggota 2 | Anggota 3 |
|---|---|---|---|
| Play / Pause logic | Implementasi | Tampilkan UI | Buat tombol |
| Next / Previous song | Implementasi | Tampilkan UI | Buat tombol |
| Repeat mode (None/One/All) | Implementasi | Tampilkan UI | Buat tombol |
| Shuffle toggle | Implementasi | Tampilkan UI | Buat tombol |
| Progress bar & seek | Implementasi | Tampilkan UI | Buat widget |
| Pencarian / filter lagu | Data source | Implementasi UI | — |
| Mini Player | Data source | Integrasi | Implementasi |
| Album Art berputar | — | Integrasi | Implementasi |
| Dark Mode / Light Mode | — | Implementasi | — |
| Izin storage Android | — | — | Implementasi |
| Unit Testing | Implementasi | — | — |
| Dokumentasi teknis | Kontribusi | Kontribusi | Tanggung jawab utama |

---

## 7. Tips Pengerjaan

### 7.1 Untuk Semua Anggota

- Baca `README.md` dan `docs/ARCHITECTURE.md` terlebih dahulu sebelum mulai coding
- Jalankan `flutter pub get` setelah mengisi `pubspec.yaml`
- Gunakan `flutter analyze` secara berkala untuk mendeteksi error

### 7.2 Untuk Anggota 1 (Backend)

- Prioritaskan pembuatan `SongModel.dart` terlebih dahulu karena Anggota 2 dan 3 bergantung padanya
- Gunakan enum `PlayerState` dan `RepeatMode` yang sudah ada di kode sebagai panduan
- Pastikan method PlayerController sudah di-test sebelum diserahkan ke anggota lain

### 7.3 Untuk Anggota 2 (Views)

- Mulai dari SplashScreen karena paling independen (tidak butuh controller)
- Gunakan `Consumer<PlayerController>` di widget yang perlu rebuild otomatis
- Gunakan `context.read<PlayerController>()` untuk action yang tidak perlu rebuild

### 7.4 Untuk Anggota 3 (Widgets)

- Mulai dari widget yang paling sederhana: PlayerControls dan SongTile
- AlbumArtWidget membutuhkan `AnimationController` — pelajari `StatefulWidget` + `TickerProviderStateMixin`
- Update dokumentasi SETELAH implementasi selesai, bukan sebelumnya

---

*Dokumen Pembagian Tugas — Flutter Media Player | Pemrograman Mobile*
