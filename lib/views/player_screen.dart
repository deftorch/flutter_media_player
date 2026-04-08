// ============================================================
// FILE: lib/views/player_screen.dart
// DESKRIPSI: Halaman pemutar musik lengkap dengan kontrol
// LAYER: View (dalam pola MVC)
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/player_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/player_controls.dart';
import '../widgets/album_art_widget.dart';
import '../widgets/progress_bar_widget.dart';

/// [PlayerScreen] adalah halaman inti pemutar musik.
///
/// Komponen yang ditampilkan:
/// 1. AppBar (tombol kembali, judul, tombol opsi)
/// 2. Album art (animasi berputar)
/// 3. Info lagu (judul, artis)
/// 4. Progress bar dengan posisi waktu
/// 5. Kontrol (prev, play/pause, next, repeat, shuffle)
class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerController>(
      builder: (context, playerCtrl, _) {
        // Jika tidak ada lagu, tampilkan placeholder
        if (playerCtrl.currentSong == null) {
          return const Scaffold(
            body: Center(child: Text('Tidak ada lagu yang diputar')),
          );
        }

        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.darkBackground, AppTheme.darkSurface],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // ── 1. AppBar ──────────────────────────────────
                  _buildAppBar(context, playerCtrl),

                  const Spacer(),

                  // ── 2. Album Art ───────────────────────────────
                  AlbumArtWidget(
                    artworkPath: playerCtrl.currentSong?.artworkPath,
                    isPlaying: playerCtrl.isPlaying,
                  ),

                  const SizedBox(height: 32),

                  // ── 3. Info Lagu ───────────────────────────────
                  _buildSongInfo(playerCtrl),

                  const SizedBox(height: 24),

                  // ── 4. Progress Bar ────────────────────────────
                  ProgressBarWidget(
                    currentPosition: playerCtrl.currentPosition,
                    totalDuration: playerCtrl.totalDuration,
                    progress: playerCtrl.progress,
                    onSeek: playerCtrl.seekToProgress,
                  ),

                  const SizedBox(height: 16),

                  // ── 5. Kontrol Pemutaran ───────────────────────
                  PlayerControls(controller: playerCtrl),

                  const Spacer(),

                  // ── 6. Playlist Queue ──────────────────────────
                  _buildPlaylistInfo(context, playerCtrl),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// AppBar dengan tombol back dan info posisi di playlist
  Widget _buildAppBar(BuildContext context, PlayerController playerCtrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Tombol kembali
          IconButton(
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 32),
            onPressed: () => Navigator.of(context).pop(),
          ),
          // Info playlist
          Column(
            children: [
              const Text(
                'SEDANG DIPUTAR',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 11,
                  letterSpacing: 1.5,
                ),
              ),
              Text(
                '${playerCtrl.currentIndex + 1} / ${playerCtrl.playlist.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          // Tombol opsi tambahan
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () => _showOptions(context, playerCtrl),
          ),
        ],
      ),
    );
  }

  /// Info judul dan artis lagu
  Widget _buildSongInfo(PlayerController playerCtrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          // Judul lagu dengan animasi marquee jika terlalu panjang
          Text(
            playerCtrl.currentSong!.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          // Nama artis
          Text(
            playerCtrl.currentSong!.artist,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          // Nama album
          Text(
            playerCtrl.currentSong!.album,
            style: TextStyle(
              color: Colors.grey.withOpacity(0.6),
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Informasi playlist di bagian bawah
  Widget _buildPlaylistInfo(BuildContext context, PlayerController playerCtrl) {
    return GestureDetector(
      onTap: () => _showPlaylistSheet(context, playerCtrl),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.queue_music, color: Colors.grey, size: 18),
            const SizedBox(width: 8),
            Text(
              'Lihat Playlist (${playerCtrl.playlist.length} lagu)',
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  /// Bottom sheet untuk opsi lagu
  void _showOptions(BuildContext context, PlayerController playerCtrl) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Detail Lagu'),
            onTap: () {
              Navigator.pop(context);
              _showSongDetails(context, playerCtrl);
            },
          ),
          ListTile(
            leading: const Icon(Icons.playlist_remove),
            title: const Text('Hapus dari Playlist'),
            onTap: () {
              playerCtrl.removeSong(playerCtrl.currentIndex);
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  /// Dialog detail lagu
  void _showSongDetails(BuildContext context, PlayerController playerCtrl) {
    final song = playerCtrl.currentSong!;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Detail Lagu'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailRow('Judul', song.title),
            _detailRow('Artis', song.artist),
            _detailRow('Album', song.album),
            _detailRow('Durasi', song.formattedDuration),
            _detailRow('File', song.filePath),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70,
            child: Text('$label:', style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  /// Bottom sheet untuk melihat dan memilih lagu di playlist
  void _showPlaylistSheet(BuildContext context, PlayerController playerCtrl) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        maxChildSize: 0.7,
        initialChildSize: 0.5,
        builder: (_, scrollController) => Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Playlist',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: playerCtrl.playlist.length,
                itemBuilder: (_, index) {
                  final song = playerCtrl.playlist[index];
                  final isActive = index == playerCtrl.currentIndex;
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isActive
                          ? AppTheme.primaryColor
                          : Colors.grey.withOpacity(0.2),
                      child: Icon(
                        isActive ? Icons.music_note : Icons.music_note_outlined,
                        color: isActive ? Colors.white : Colors.grey,
                      ),
                    ),
                    title: Text(
                      song.title,
                      style: TextStyle(
                        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                        color: isActive ? AppTheme.primaryColor : null,
                      ),
                    ),
                    subtitle: Text(song.artist),
                    trailing: Text(song.formattedDuration),
                    onTap: () {
                      playerCtrl.playSong(index);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
