# 📝 CHANGELOG

Semua perubahan penting pada proyek ini akan didokumentasikan di sini.

---

## [1.0.0] — Rilis Pertama

### Ditambahkan
- Halaman SplashScreen dengan animasi fade dan scale
- HomeScreen dengan daftar lagu menggunakan ListView.builder
- PlayerScreen dengan tampilan pemutar lengkap
- Animasi album art berputar saat lagu diputar
- Progress bar interaktif dengan seek
- Kontrol: play/pause, next, previous
- Mode Shuffle (acak lagu)
- Mode Repeat: None, One (satu lagu), All (semua)
- Fitur pencarian lagu berdasarkan judul/artis
- Mini Player di bawah HomeScreen
- Animasi equalizer pada SongTile yang aktif
- Dark mode otomatis mengikuti sistem
- Playlist sheet (lihat semua lagu)
- Detail lagu (dialog)
- Hapus lagu dari playlist
- 10 unit test untuk Model dan Controller

### Teknologi
- Flutter 3.x + Dart 3.x
- just_audio ^0.9.36
- provider ^6.1.1
- Arsitektur MVC + Provider pattern

---

## Rencana Versi Berikutnya [1.1.0]

### Akan Ditambahkan
- [ ] Integrasi on_audio_query untuk membaca lagu dari storage asli
- [ ] Notifikasi media di notification bar
- [ ] Equalizer audio (bass, treble, dll)
- [ ] Playlist buatan pengguna (custom playlist)
- [ ] Fitur favorit/like lagu
- [ ] Timer tidur (sleep timer)
- [ ] Widget lirik lagu
