// ============================================================
// FILE: lib/widgets/player_controls.dart
// DESKRIPSI: Widget kontrol pemutaran (prev, play/pause, next)
// ============================================================

import 'package:flutter/material.dart';
import '../controllers/player_controller.dart' as pc;
import '../theme/app_theme.dart';

/// [PlayerControls] menampilkan tombol-tombol kontrol pemutar:
/// - Shuffle
/// - Previous
/// - Play / Pause (tombol utama, lebih besar)
/// - Next
/// - Repeat
class PlayerControls extends StatelessWidget {
  final pc.PlayerController controller;

  const PlayerControls({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // Baris tombol utama
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Tombol Shuffle
              _buildIconButton(
                icon: Icons.shuffle,
                color: controller.isShuffled
                    ? AppTheme.primaryColor
                    : Colors.grey,
                size: 24,
                onPressed: controller.toggleShuffle,
                tooltip: 'Shuffle',
              ),

              // Tombol Previous
              _buildIconButton(
                icon: Icons.skip_previous,
                color: controller.hasPrevious ? Colors.white : Colors.grey,
                size: 36,
                onPressed: controller.hasPrevious ? controller.previous : null,
                tooltip: 'Sebelumnya',
              ),

              // Tombol Play/Pause (tombol utama, lebih besar)
              _buildPlayPauseButton(),

              // Tombol Next
              _buildIconButton(
                icon: Icons.skip_next,
                color: controller.hasNext ? Colors.white : Colors.grey,
                size: 36,
                onPressed: controller.hasNext ? controller.next : null,
                tooltip: 'Berikutnya',
              ),

              // Tombol Repeat
              _buildRepeatButton(),
            ],
          ),
        ],
      ),
    );
  }

  /// Tombol Play/Pause dengan efek shadow
  Widget _buildPlayPauseButton() {
    return GestureDetector(
      onTap: controller.togglePlayPause,
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.primaryColor,
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withOpacity(0.4),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: controller.isLoading
            // Tampilkan loading indicator jika sedang memuat
            ? const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              )
            : Icon(
                controller.isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 36,
              ),
      ),
    );
  }

  /// Tombol repeat dengan 3 state
  Widget _buildRepeatButton() {
    IconData icon;
    Color color;
    String tooltip;

    switch (controller.repeatMode) {
      case pc.RepeatMode.none:
        icon = Icons.repeat;
        color = Colors.grey;
        tooltip = 'Tidak mengulang';
        break;
      case pc.RepeatMode.one:
        icon = Icons.repeat_one;
        color = AppTheme.primaryColor;
        tooltip = 'Mengulang 1 lagu';
        break;
      case pc.RepeatMode.all:
        icon = Icons.repeat;
        color = AppTheme.primaryColor;
        tooltip = 'Mengulang semua';
        break;
    }

    return _buildIconButton(
      icon: icon,
      color: color,
      size: 24,
      onPressed: controller.cycleRepeatMode,
      tooltip: tooltip,
    );
  }

  /// Helper untuk membuat icon button yang konsisten
  Widget _buildIconButton({
    required IconData icon,
    required Color color,
    required double size,
    VoidCallback? onPressed,
    String? tooltip,
  }) {
    return Tooltip(
      message: tooltip ?? '',
      child: IconButton(
        icon: Icon(icon, color: color, size: size),
        onPressed: onPressed,
      ),
    );
  }
}
