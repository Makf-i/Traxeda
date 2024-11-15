import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tradexa/constants/apps_colors.dart';
import 'package:tradexa/models/movie.dart';
import 'package:tradexa/providers/movie_provider.dart';
import 'package:tradexa/widgets/movie_tile.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppsColors.colWhite,
      appBar: AppBar(
        backgroundColor: AppsColors.colWhite,
        title: Text(
          ' Home',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search Movies',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  ref.read(movieProvider.notifier).fetchMovies(value);
                }
              },
            ),
          ),
          Expanded(
            child: _buildMovieList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieList() {
    final movies = ref.watch(movieProvider);

    if (movies.isEmpty) {
      return const Center(
        child: Text('No movies found. Start searching!'),
      );
    }

    return FutureBuilder(
      future: Future.wait(
        movies.map((movie) =>
            ref.read(movieProvider.notifier).fetchMovieDetails(movie.title)),
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No detailed information available.'),
          );
        } else {
          final movieDetailsList = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: movieDetailsList.length,
            itemBuilder: (context, index) {
              final movieDetails = movieDetailsList[index];
              return MovieTile(
                title: movieDetails!.title,
                genre: movieDetails.genre,
                poster: movieDetails.poster,
                imdbRating: movieDetails.imdbRating,
              );
            },
          );
        }
      },
    );
  }
}
