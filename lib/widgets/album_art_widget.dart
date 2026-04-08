// ============================================================
// FILE: lib/widgets/album_art_widget.dart
// DESKRIPSI: Widget album art dengan animasi berputar
// ============================================================

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// [AlbumArtWidget] menampilkan gambar album dengan animasi berputar
/// saat lagu sedang diputar.
class AlbumArtWidget extends StatefulWidget {
  final String? artworkPath;
  final bool isPlaying;

  const AlbumArtWidget({
    super.key,
    this.artworkPath,
    required this.isPlaying,
  });

  @override
  State<AlbumArtWidget> createState() => _AlbumArtWidgetState();
}

class _AlbumArtWidgetState extends State<AlbumArtWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    if (widget.isPlaying) {
      _rotationController.repeat();
    }
  }

  @override
  void didUpdateWidget(AlbumArtWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Pause/resume rotasi sesuai status play
    if (widget.isPlaying && !_rotationController.isAnimating) {
      _rotationController.repeat();
    } else if (!widget.isPlaying && _rotationController.isAnimating) {
      _rotationController.stop();
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RotationTransition(
        turns: _rotationController,
        child: Container(
          width: 260,
          height: 260,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.darkCard,
            border: Border.all(
              color: AppTheme.primaryColor.withOpacity(0.3),
              width: 4,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryColor.withOpacity(0.2),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: ClipOval(
            child: widget.artworkPath != null
                ? Image.asset(
                    widget.artworkPath!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildPlaceholder(),
                  )
                : _buildPlaceholder(),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppTheme.darkCard,
      child: const Icon(
        Icons.music_note,
        size: 100,
        color: AppTheme.primaryColor,
      ),
    );
  }
}
