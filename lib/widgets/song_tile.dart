// ============================================================
// FILE: lib/widgets/song_tile.dart
// DESKRIPSI: Widget item lagu untuk ListView di HomeScreen
// ============================================================

import 'package:flutter/material.dart';
import '../models/song_model.dart';
import '../theme/app_theme.dart';

/// [SongTile] adalah widget yang merepresentasikan satu baris lagu
/// di dalam daftar lagu (HomeScreen).
///
/// Parameter:
/// - [song]: Data lagu yang ditampilkan
/// - [isActive]: Apakah ini lagu yang sedang diputar
/// - [isPlaying]: Apakah lagu ini sedang dalam status play
/// - [onTap]: Callback saat item ditekan
class SongTile extends StatelessWidget {
  final SongModel song;
  final bool isActive;
  final bool isPlaying;
  final VoidCallback onTap;

  const SongTile({
    super.key,
    required this.song,
    required this.isActive,
    required this.isPlaying,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // Highlight background jika lagu ini sedang aktif
      tileColor: isActive
          ? AppTheme.primaryColor.withOpacity(0.1)
          : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),

      // Leading: nomor lagu atau animasi equalizer
      leading: _buildLeading(),

      // Title: judul lagu
      title: Text(
        song.title,
        style: TextStyle(
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          color: isActive ? AppTheme.primaryColor : null,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),

      // Subtitle: nama artis
      subtitle: Text(
        song.artist,
        style: const TextStyle(fontSize: 13),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),

      // Trailing: durasi lagu
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            song.formattedDuration,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          // Tampilkan ikon play jika aktif
          if (isActive)
            Icon(
              isPlaying ? Icons.volume_up : Icons.pause,
              size: 14,
              color: AppTheme.primaryColor,
            ),
        ],
      ),

      onTap: onTap,
    );
  }

  /// Membangun bagian leading (kiri) dari tile
  Widget _buildLeading() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive
            ? AppTheme.primaryColor
            : Colors.grey.withOpacity(0.2),
      ),
      child: isActive && isPlaying
          // Animasi equalizer saat sedang diputar
          ? _EqualizerAnimation()
          : Icon(
              Icons.music_note,
              color: isActive ? Colors.white : Colors.grey,
              size: 24,
            ),
    );
  }
}

/// Widget animasi equalizer (batang-batang yang bergerak)
class _EqualizerAnimation extends StatefulWidget {
  @override
  State<_EqualizerAnimation> createState() => __EqualizerAnimationState();
}

class __EqualizerAnimationState extends State<_EqualizerAnimation>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;

  @override
  void initState() {
    super.initState();
    // Buat 3 controller animasi dengan kecepatan berbeda
    _controllers = List.generate(3, (i) {
      final ctrl = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 400 + (i * 100)),
      );
      ctrl.repeat(reverse: true);
      return ctrl;
    });
  }

  @override
  void dispose() {
    for (final ctrl in _controllers) {
      ctrl.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(3, (i) {
        return AnimatedBuilder(
          animation: _controllers[i],
          builder: (_, __) {
            return Container(
              width: 4,
              height: 8 + (_controllers[i].value * 16),
              margin: const EdgeInsets.symmetric(horizontal: 1),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2),
              ),
            );
          },
        );
      }),
    );
  }
}
