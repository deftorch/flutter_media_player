// ============================================================
// FILE: lib/widgets/progress_bar_widget.dart
// DESKRIPSI: Widget progress bar dengan label waktu
// ============================================================

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// [ProgressBarWidget] menampilkan slider progress pemutaran
/// beserta label waktu saat ini dan total durasi.
class ProgressBarWidget extends StatelessWidget {
  final Duration currentPosition;
  final Duration totalDuration;
  final double progress;
  final ValueChanged<double> onSeek;

  const ProgressBarWidget({
    super.key,
    required this.currentPosition,
    required this.totalDuration,
    required this.progress,
    required this.onSeek,
  });

  /// Format Duration ke string "mm:ss"
  String _formatDuration(Duration d) {
    final minutes = d.inMinutes;
    final seconds = d.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // Slider progress
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
              activeTrackColor: AppTheme.primaryColor,
              inactiveTrackColor: Colors.grey.withOpacity(0.3),
              thumbColor: Colors.white,
              overlayColor: AppTheme.primaryColor.withOpacity(0.2),
            ),
            child: Slider(
              value: progress.clamp(0.0, 1.0),
              onChanged: onSeek,
            ),
          ),
          // Label waktu
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Waktu saat ini
                Text(
                  _formatDuration(currentPosition),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
                // Total durasi
                Text(
                  _formatDuration(totalDuration),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
