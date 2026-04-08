# 🔄 Diagram Alur — Flutter Media Player

Dokumen ini berisi flowchart dan sequence diagram untuk membantu memahami alur kerja aplikasi.

---

## 1. Alur Aplikasi Utama

```
                    ┌─────────────────┐
                    │   App Dibuka    │
                    └────────┬────────┘
                             │
                             ▼
                    ┌─────────────────┐
                    │  SplashScreen   │
                    │  (2.5 detik)    │
                    └────────┬────────┘
                             │ (selesai animasi)
                             ▼
                    ┌─────────────────┐
                    │   HomeScreen    │◄──────────────────┐
                    │  (Daftar Lagu)  │                   │
                    └────────┬────────┘                   │
                             │                            │
              ┌──────────────┴──────────────┐             │
              │                             │             │
    [Tap Lagu]                    [Tap Search/Menu]       │
              │                             │             │
              ▼                             ▼             │
   ┌──────────────────┐        ┌────────────────────┐    │
   │  PlayerScreen    │        │  Filter Hasil Cari  │    │
   │  (Pemutar Penuh) │        └────────────────────┘    │
   └────────┬─────────┘                                  │
            │                                            │
            │ [Tap tombol back]                          │
            └────────────────────────────────────────────┘
```

---

## 2. Alur Pemutaran Lagu

```
User tap lagu di HomeScreen
            │
            ▼
  PlayerController.playSong(index)
            │
            ├─► _playerState = loading
            │   notifyListeners() → UI tampilkan spinner
            │
            ├─► AudioPlayer.setAsset(filePath)
            │   (memuat file audio)
            │
            ├─► AudioPlayer.play()
            │
            ├─► _playerState = playing
            │   notifyListeners() → UI tampilkan play state
            │
            ▼
     Lagu mulai diputar
            │
            │ (positionStream emit tiap detik)
            ▼
  _currentPosition update
  notifyListeners()
            │
            ▼
  ProgressBarWidget rebuild
  (slider bergerak)
```

---

## 3. Alur Logika Saat Lagu Selesai

```
AudioPlayer.processingState = completed
            │
            ▼
  _onSongCompleted() dipanggil
            │
   ┌────────┴────────┐
   │                 │
   ▼                 ▼
RepeatMode?      RepeatMode?
= one            = all
   │                 │
   ▼                 ▼
playSong(       hasNext?
currentIndex)    │     │
(ulang lagu)    Ya    Tidak
                │     │
                ▼     ▼
             next() playSong(0)
                      (kembali ke awal)

RepeatMode = none
   │
   ▼
hasNext?
   │         │
  Ya        Tidak
   │         │
   ▼         ▼
 next()  playerState = stopped
         (playlist selesai)
```

---

## 4. Alur Provider/State Management

```
┌──────────────────────────────────────────────────┐
│                   main.dart                      │
│                                                  │
│  MultiProvider                                   │
│  └── ChangeNotifierProvider(PlayerController)    │
│       └── MaterialApp                            │
│            └── HomeScreen                        │
└──────────────────────────────────────────────────┘
                        │
                        │ Provider.of / Consumer / context.read
                        │
┌──────────────────────▼───────────────────────────┐
│               PlayerController                   │
│                                                  │
│  State:                                          │
│  - _playlist, _currentSong, _playerState, etc    │
│                                                  │
│  Saat state berubah:                             │
│  notifyListeners()                               │
│       │                                          │
│       ├──► HomeScreen rebuild                    │
│       ├──► PlayerScreen rebuild                  │
│       └──► MiniPlayer rebuild                    │
└──────────────────────────────────────────────────┘
```

---

## 5. Sequence Diagram: Tap Play di PlayerControls

```
User          PlayerControls    PlayerController    AudioPlayer
  │                │                  │                 │
  │──[tap]────────►│                  │                 │
  │                │──togglePlayPause►│                 │
  │                │                  │──pause()/play()►│
  │                │                  │                 │──[audio]
  │                │                  │◄────────────────│
  │                │                  │                 │
  │                │                  ├─ _playerState = playing/paused
  │                │                  ├─ notifyListeners()
  │                │                  │                 │
  │                │◄─── rebuild ─────┤                 │
  │◄── UI update ──│                  │                 │
  │                │                  │                 │
```

---

## 6. Alur Seek / Drag Progress Bar

```
User drag Slider
      │
      ▼
ProgressBarWidget.onSeek(value) dipanggil
      │
      ▼
PlayerController.seekToProgress(value)
      │
      ▼
position = totalDuration * value
      │
      ▼
AudioPlayer.seek(position)
      │
      ▼
_currentPosition = position
notifyListeners()
      │
      ▼
ProgressBarWidget rebuild dengan posisi baru
```

---

## 7. Diagram State Machine PlayerState

```
                 ┌─────────┐
     ┌──────────►│  idle   │◄──────────┐
     │           └────┬────┘           │
     │                │ playSong()     │
     │ stop()         ▼                │
     │           ┌─────────┐           │
     │      ┌───►│ loading │           │
     │      │    └────┬────┘           │
     │      │         │ berhasil       │ stop()
     │      │         ▼                │
     │      │    ┌─────────┐           │
     │      │    │ playing │───────────┤
     │      │    └────┬────┘           │
     │      │         │ pause()        │
     │      │         ▼                │
     │      │    ┌─────────┐           │
     │      │    │ paused  │           │
     │      │    └────┬────┘           │
     │      │         │ resume()       │
     │      │         └────────────────┘ (kembali ke playing)
     │      │
     │      │ playSong()
     │    ┌─┴───────┐
     └────┤ stopped │
          └─────────┘

     ┌─────────┐
     │  error  │  (dari kondisi manapun jika terjadi exception)
     └─────────┘
```
