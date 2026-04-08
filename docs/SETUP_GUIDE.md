# 🛠️ Panduan Setup & Instalasi Lengkap

Dokumen ini menjelaskan langkah-langkah lengkap untuk menyiapkan lingkungan pengembangan dan menjalankan proyek ini.

---

## Prasyarat Sistem

| Kebutuhan | Versi Minimum | Cara Cek |
|-----------|--------------|----------|
| Flutter SDK | 3.0.0+ | `flutter --version` |
| Dart SDK | 3.0.0+ | `dart --version` |
| Android Studio | Electric Eel+ | — |
| Java JDK | 11+ | `java -version` |
| Git | terbaru | `git --version` |

---

## Langkah 1 — Install Flutter SDK

### Windows
1. Download Flutter SDK dari https://flutter.dev/docs/get-started/install/windows
2. Ekstrak ke `C:\flutter`
3. Tambahkan `C:\flutter\bin` ke PATH environment variable
4. Jalankan `flutter doctor` di Command Prompt

### macOS
```bash
brew install flutter
```

### Linux
```bash
sudo snap install flutter --classic
```

---

## Langkah 2 — Setup Android Studio

1. Download dari https://developer.android.com/studio
2. Install **Flutter** dan **Dart** plugins:
   - File → Settings → Plugins → Cari "Flutter" → Install
3. Setup Android Emulator:
   - Tools → AVD Manager → Create Virtual Device
   - Pilih Pixel 6, API 33 (Android 13)

---

## Langkah 3 — Clone / Ekstrak Proyek

```bash
# Jika dari ZIP, ekstrak terlebih dahulu, lalu:
cd flutter_media_player

# Atau jika dari Git:
git clone <url-repo>
cd flutter_media_player
```

---

## Langkah 4 — Install Dependencies

```bash
flutter pub get
```

Output yang diharapkan:
```
Resolving dependencies...
  animations 2.0.8
  just_audio 0.9.36
  on_audio_query 2.9.0
  permission_handler 11.1.0
  provider 6.1.1
Got dependencies!
```

---

## Langkah 5 — Menambahkan File Audio (Untuk Testing)

Karena file audio asli tidak disertakan, tambahkan file MP3 ke folder `assets/audio/`:

```bash
# Struktur yang dibutuhkan:
assets/
└── audio/
    ├── sample1.mp3   ← Ganti dengan file MP3 asli Anda
    ├── sample2.mp3
    ├── sample3.mp3
    ├── sample4.mp3
    └── sample5.mp3
```

**Tips:** Rename file MP3 milik Anda menjadi `sample1.mp3` dst, atau update nama di `lib/models/song_model.dart` pada bagian `dummySongs`.

---

## Langkah 6 — Jalankan Aplikasi

```bash
# Cek perangkat yang terhubung
flutter devices

# Jalankan di emulator/device
flutter run

# Jalankan di emulator spesifik
flutter run -d emulator-5554

# Jalankan dengan hot reload (development)
flutter run --debug
```

### Shortcut saat Running:
| Shortcut | Fungsi |
|----------|--------|
| `r` | Hot reload |
| `R` | Hot restart |
| `q` | Keluar |
| `d` | Detach |

---

## Langkah 7 — Build APK

```bash
# Build APK debug
flutter build apk --debug

# Build APK release (siap distribusi)
flutter build apk --release

# Output file:
# build/app/outputs/flutter-apk/app-release.apk
```

---

## Langkah 8 — Jalankan Tests

```bash
# Jalankan semua test
flutter test

# Jalankan file test tertentu
flutter test test/player_controller_test.dart

# Test dengan coverage report
flutter test --coverage
```

Output yang diharapkan:
```
00:02 +10: All tests passed!
```

---

## Troubleshooting

### ❌ Error: `flutter pub get` gagal

```bash
flutter clean
flutter pub cache repair
flutter pub get
```

### ❌ Error: `ANDROID_SDK_ROOT not set`

Tambahkan ke `.bashrc` / `.zshrc`:
```bash
export ANDROID_SDK_ROOT=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_SDK_ROOT/tools
```

### ❌ Error: `Permission denied` saat akses audio

Pastikan di `AndroidManifest.xml` sudah ada:
```xml
<uses-permission android:name="android.permission.READ_MEDIA_AUDIO" />
```
Dan jalankan `permission_handler` untuk meminta izin di runtime.

### ❌ Error: `just_audio` tidak bisa putar file

Pastikan:
1. File audio ada di folder `assets/audio/`
2. `pubspec.yaml` mencantumkan `assets/audio/`
3. Jalankan `flutter pub get` ulang

### ❌ Gradle build gagal

```bash
cd android
./gradlew clean
cd ..
flutter run
```

---

## Struktur Konfigurasi Android

### `android/app/build.gradle`
```groovy
android {
    compileSdkVersion 34
    
    defaultConfig {
        minSdkVersion 21        // Android 5.0 minimum
        targetSdkVersion 34     // Android 14
    }
}
```

### `android/gradle.properties`
```properties
org.gradle.jvmargs=-Xmx4G
android.useAndroidX=true
android.enableJetifier=true
```

---

## Catatan Penting untuk iOS (Opsional)

Jika ingin menjalankan di iOS, tambahkan ke `ios/Runner/Info.plist`:
```xml
<key>NSMicrophoneUsageDescription</key>
<string>Dibutuhkan untuk memutar audio</string>

<key>UIBackgroundModes</key>
<array>
    <string>audio</string>
</array>
```
