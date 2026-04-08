// ============================================================
// FILE: lib/widgets/mini_player.dart
// DESKRIPSI: Widget mini player yang muncul di HomeScreen
//            saat ada lagu yang sedang diputar
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/player_controller.dart';
import '../theme/app_theme.dart';

/// [MiniPlayer] adalah versi kecil pemutar yang tampil
/// di bawah HomeScreen saat ada lagu aktif.
///
/// Menampilkan:
/// - Judul dan artis lagu
/// - Tombol play/pause
/// - Progress bar tipis
class MiniPlayer extends StatelessWidget {
  final VoidCallback onTap;

  const MiniPlayer({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerController>(
      builder: (context, playerCtrl, _) {
        final song = playerCtrl.currentSong;
        if (song == null) return const SizedBox.shrink();

        return GestureDetector(
          onTap: onTap,
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              color: AppTheme.darkSurface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Progress bar tipis di atas mini player
                LinearProgressIndicator(
                  value: playerCtrl.progress,
                  backgroundColor: Colors.transparent,
                  color: AppTheme.primaryColor,
                  minHeight: 2,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        // Icon lagu
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.primaryColor.withOpacity(0.2),
                          ),
                          child: const Icon(
                            Icons.music_note,
                            color: AppTheme.primaryColor,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Judul dan artis
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                song.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                song.artist,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        // Tombol previous
                        IconButton(
                          icon: const Icon(Icons.skip_previous, color: Colors.white, size: 22),
                          onPressed: playerCtrl.previous,
                        ),
                        // Tombol play/pause
                        IconButton(
                          icon: Icon(
                            playerCtrl.isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                            size: 28,
                          ),
                          onPressed: playerCtrl.togglePlayPause,
                        ),
                        // Tombol next
                        IconButton(
                          icon: const Icon(Icons.skip_next, color: Colors.white, size: 22),
                          onPressed: playerCtrl.next,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
