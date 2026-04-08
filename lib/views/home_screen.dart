// ============================================================
// FILE: lib/views/home_screen.dart
// DESKRIPSI: Halaman utama yang menampilkan daftar lagu
// LAYER: View (dalam pola MVC)
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/player_controller.dart';
import '../models/song_model.dart';
import '../theme/app_theme.dart';
import '../widgets/song_tile.dart';
import '../widgets/mini_player.dart';
import 'player_screen.dart';

/// [HomeScreen] menampilkan:
/// - AppBar dengan judul dan tombol pencarian
/// - Daftar lagu dalam ListView
/// - Mini player di bagian bawah (saat ada lagu yang diputar)
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Controller untuk search field
  final TextEditingController _searchController = TextEditingController();

  // Daftar lagu yang difilter berdasarkan pencarian
  List<SongModel> _filteredSongs = [];

  // Menandakan apakah mode search aktif
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    // Inisialisasi daftar lagu dari controller
    final playerCtrl = context.read<PlayerController>();
    _filteredSongs = playerCtrl.playlist;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Fungsi pencarian lagu berdasarkan judul atau artis
  void _onSearch(String query) {
    final playerCtrl = context.read<PlayerController>();
    setState(() {
      if (query.isEmpty) {
        _filteredSongs = playerCtrl.playlist;
      } else {
        _filteredSongs = playerCtrl.playlist.where((song) {
          final titleMatch =
              song.title.toLowerCase().contains(query.toLowerCase());
          final artistMatch =
              song.artist.toLowerCase().contains(query.toLowerCase());
          return titleMatch || artistMatch;
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Consumer me-rebuild widget ini saat PlayerController berubah
    return Consumer<PlayerController>(
      builder: (context, playerCtrl, _) {
        return Scaffold(
          appBar: _buildAppBar(playerCtrl),
          body: Column(
            children: [
              // Jika mode search aktif, tampilkan search bar
              if (_isSearching) _buildSearchBar(),

              // Header statistik
              _buildHeader(playerCtrl),

              // Daftar lagu
              Expanded(
                child: _buildSongList(playerCtrl),
              ),
            ],
          ),
          // Mini player muncul di bawah jika ada lagu aktif
          bottomSheet: playerCtrl.currentSong != null
              ? MiniPlayer(
                  onTap: () => _openPlayerScreen(context, playerCtrl),
                )
              : null,
        );
      },
    );
  }

  /// Membangun AppBar
  PreferredSizeWidget _buildAppBar(PlayerController playerCtrl) {
    return AppBar(
      title: const Text(
        'My Music',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      actions: [
        // Tombol search
        IconButton(
          icon: Icon(_isSearching ? Icons.close : Icons.search),
          onPressed: () {
            setState(() {
              _isSearching = !_isSearching;
              if (!_isSearching) {
                _searchController.clear();
                _filteredSongs = playerCtrl.playlist;
              }
            });
          },
        ),
        // Tombol menu
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'shuffle') playerCtrl.toggleShuffle();
          },
          itemBuilder: (_) => [
            PopupMenuItem(
              value: 'shuffle',
              child: Row(
                children: [
                  Icon(
                    Icons.shuffle,
                    color: playerCtrl.isShuffled ? AppTheme.primaryColor : null,
                  ),
                  const SizedBox(width: 8),
                  Text(playerCtrl.isShuffled ? 'Matikan Shuffle' : 'Shuffle'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Membangun search bar
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearch,
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'Cari lagu atau artis...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
        ),
      ),
    );
  }

  /// Membangun header dengan info playlist
  Widget _buildHeader(PlayerController playerCtrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${_filteredSongs.length} lagu',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          // Tombol putar semua
          TextButton.icon(
            onPressed: () {
              if (_filteredSongs.isNotEmpty) {
                playerCtrl.playSong(0);
                _openPlayerScreen(context, playerCtrl);
              }
            },
            icon: const Icon(Icons.play_circle_fill, size: 20),
            label: const Text('Putar Semua'),
          ),
        ],
      ),
    );
  }

  /// Membangun daftar lagu
  Widget _buildSongList(PlayerController playerCtrl) {
    if (_filteredSongs.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.music_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Tidak ada lagu ditemukan', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      // Padding bawah agar tidak tertutup mini player
      padding: EdgeInsets.only(
        bottom: playerCtrl.currentSong != null ? 80 : 16,
      ),
      itemCount: _filteredSongs.length,
      itemBuilder: (context, index) {
        final song = _filteredSongs[index];
        final isActive = playerCtrl.currentSong?.id == song.id;

        // SongTile adalah widget custom untuk item lagu
        return SongTile(
          song: song,
          isActive: isActive,
          isPlaying: isActive && playerCtrl.isPlaying,
          onTap: () {
            // Cari index di playlist asli
            final realIndex = playerCtrl.playlist.indexOf(song);
            playerCtrl.playSong(realIndex);
            _openPlayerScreen(context, playerCtrl);
          },
        );
      },
    );
  }

  /// Membuka halaman player
  void _openPlayerScreen(BuildContext context, PlayerController playerCtrl) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const PlayerScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: child,
          );
        },
      ),
    );
  }
}
