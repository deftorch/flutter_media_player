// ============================================================
// FILE: lib/main.dart
// DESKRIPSI: Entry point utama aplikasi Flutter Media Player
// AUTHOR: [Nama Mahasiswa]
// NIM: [NIM]
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/player_controller.dart';
import 'theme/app_theme.dart';
import 'views/splash_screen.dart';

/// Fungsi main() adalah titik awal eksekusi program Flutter.
/// MultiProvider digunakan agar PlayerController bisa diakses
/// dari seluruh widget tree tanpa perlu diteruskan manual.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // Mendaftarkan semua provider (state manager) di sini
      providers: [
        ChangeNotifierProvider(create: (_) => PlayerController()),
      ],
      child: MaterialApp(
        title: 'Flutter Media Player',
        debugShowCheckedModeBanner: false,
        // Tema aplikasi didefinisikan terpisah di app_theme.dart
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const SplashScreen(),
      ),
    );
  }
}
