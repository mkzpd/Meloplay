import 'package:flutter/material.dart';
import 'package:meloplay/src/data/repositories/player_repository.dart';
import 'package:meloplay/src/presentation/widgets/player_bottom_app_bar.dart';
import 'package:meloplay/src/presentation/widgets/song_list_tile.dart';
import 'package:meloplay/src/presentation/utils/theme/themes.dart';
import 'package:meloplay/src/service_locator.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AlbumPage extends StatefulWidget {
  final AlbumModel album;

  const AlbumPage({Key? key, required this.album}) : super(key: key);

  @override
  State<AlbumPage> createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  late List<SongModel> _songs;
  final PlayerRepository playerRepository = sl<PlayerRepository>();

  @override
  void initState() {
    super.initState();
    _songs = [];
    _getSongs();
  }

  Future<void> _getSongs() async {
    final OnAudioQuery audioQuery = sl<OnAudioQuery>();

    List<SongModel> songs = await audioQuery.queryAudiosFrom(
      AudiosFromType.ALBUM_ID,
      widget.album.id,
    );

    // Sort songs by name
    songs.sort((a, b) {
      // Extract the numeric part from the song title
      int numA = int.parse(a.title.split(RegExp(r'\D+'))[0]);
      int numB = int.parse(b.title.split(RegExp(r'\D+'))[0]);
      // Compare the numeric parts first
      if (numA != numB) {
        return numA.compareTo(numB);
      }
      // If numeric parts are equal, compare the alphabetic parts
      return a.title.replaceAll(RegExp(r'\d+'), '').compareTo(b.title.replaceAll(RegExp(r'\d+'), ''));
    });

    setState(() {
      _songs = songs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const PlayerBottomAppBar(),
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Themes.getTheme().primaryColor,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
          ),
        ),
        title: Text(
          widget.album.album,
        ),
      ),
      body: Ink(
        decoration: BoxDecoration(
          gradient: Themes.getTheme().linearGradient,
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: _songs.length,
                itemBuilder: (context, index) {
                  final SongModel song = _songs[index];

                  return SongListTile(
                    song: song,
                    songs: _songs,
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




//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // current song, play/pause button, song progress bar, song queue button
//       bottomNavigationBar: const PlayerBottomAppBar(),
//       extendBody: true,
//       body: Ink(
//         padding: EdgeInsets.fromLTRB(
//           24,
//           MediaQuery.of(context).padding.top + 16,
//           24,
//           16,
//         ),
//         decoration: BoxDecoration(
//           gradient: Themes.getTheme().linearGradient,
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // back button
//             Row(
//               children: [
//                 IconButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   icon: const Icon(Icons.arrow_back_ios),
//                 ),
//               ],
//             ),
//             // // album artwork
//             // Expanded(
//             //   child: QueryArtworkWidget(
//             //     id: widget.album.id,
//             //     type: ArtworkType.ALBUM,
//             //     artworkQuality: FilterQuality.high,
//             //     artworkWidth: double.infinity,
//             //     artworkBorder: BorderRadius.circular(50),
//             //     nullArtworkWidget: Container(
//             //       width: double.infinity,
//             //       decoration: BoxDecoration(
//             //         color: Colors.grey.withOpacity(0.1),
//             //         borderRadius: BorderRadius.circular(50),
//             //       ),
//             //       child: const Icon(
//             //         Icons.music_note_outlined,
//             //         size: 100,
//             //       ),
//             //     ),
//             //   ),
//             // ),
//             // const SizedBox(height: 16),
//             // // album name
//             // Padding(
//             //   padding: const EdgeInsets.symmetric(horizontal: 16),
//             //   child: Text(
//             //     widget.album.album,
//             //     style: const TextStyle(
//             //       fontSize: 24,
//             //       fontWeight: FontWeight.bold,
//             //     ),
//             //   ),
//             // ),
//             // // artist name
//             // Padding(
//             //   padding: const EdgeInsets.symmetric(horizontal: 16),
//             //   child: Text(
//             //     widget.album.artist ?? 'Unknown',
//             //     style: const TextStyle(
//             //       fontSize: 18,
//             //       color: Colors.grey,
//             //     ),
//             //   ),
//             // ),
//             // const SizedBox(height: 16),
//             // songs
//             Expanded(
//               child: ListView.builder(
//                 padding: EdgeInsets.zero,
//                 itemCount: _songs.length,
//                 itemBuilder: (context, index) {
//                   final SongModel song = _songs[index];

//                   return SongListTile(
//                     song: song,
//                     songs: _songs,
//                     showAlbumArt: false,
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
