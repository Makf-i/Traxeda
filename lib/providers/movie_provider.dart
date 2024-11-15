import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer show log;

import 'package:tradexa/models/movie.dart';

extension Log on Object {
  void log() => developer.log(toString());
}

const String apiKey = '62aa65b9';

class MovieProvider extends StateNotifier<List<MovieModel>> {
  MovieProvider() : super([]);

  /// Fetch a list of movies based on a search query
  Future<void> fetchMovies(String query) async {
    final url = Uri.parse('http://www.omdbapi.com/?apikey=$apiKey&s=$query');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['Search'] != null) {
          state = (data['Search'] as List)
              .map((movie) => MovieModel.fromJson(movie))
              .toList();
        } else {
          state = [];
        }
      } else {
        throw Exception('Failed to fetch movies');
      }
    } catch (e) {
      state = [];
      rethrow;
    }
  }

  /// Fetch details of a specific movie by title
  Future<MovieModel?> fetchMovieDetails(String title) async {
    final url = Uri.parse('http://www.omdbapi.com/?apikey=$apiKey&t=$title');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['Response'] == 'True') {
          return MovieModel.fromJson(data);
        } else {
          throw Exception('Movie not found');
        }
      } else {
        throw Exception('Failed to fetch movie details');
      }
    } catch (e) {
      e.log();
      return null;
    }
  }
}

// Define the provider
final movieProvider = StateNotifierProvider<MovieProvider, List<MovieModel>>(
  (ref) {
    return MovieProvider();
  },
);
