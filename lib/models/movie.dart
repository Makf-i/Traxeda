class MovieModel {
  final String title;
  final String genre;
  final String poster;
  final String imdbRating;

  const MovieModel({
    required this.title,
    required this.genre,
    required this.poster,
    required this.imdbRating,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      title: json['Title'] ?? 'N/A',
      genre: json['Genre'] ?? 'N/A',
      poster: json['Poster'] ?? 'N/A',
      imdbRating: json['imdbRating'] ?? 'N/A',
    );
  }
}
