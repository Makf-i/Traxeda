import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tradexa/constants/apps_colors.dart';

class MovieTile extends StatelessWidget {
  const MovieTile({
    super.key,
    this.title,
    this.genre,
    this.imdbRating,
    this.poster,
  });

  final String? title;
  final String? genre;
  final String? imdbRating;
  final String? poster;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const SizedBox(
              height: 65,
            ),
            SizedBox(
              width: double.infinity,
              height: 170,
              child: Card(
                color: AppsColors.colWhite,
                margin: const EdgeInsets.only(bottom: 20),
                elevation: 15,
                child: Padding(
                  padding: const EdgeInsets.only(left: 150.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title ?? "Title not available",
                        style: title != null
                            ? GoogleFonts.montserrat(
                                fontWeight: FontWeight.bold)
                            : Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        genre!.replaceAll(',', ' | '),
                        style: GoogleFonts.montserrat(color: AppsColors.colLigBlack,fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      IntrinsicWidth(
                        child: Container(
                          width: 100,
                          height: 22,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: imdbRating == 'N/A'
                                ? Colors.grey
                                : double.parse(imdbRating!) > 7.0
                                    ? AppsColors.colGreen
                                    : AppsColors.colBlue,
                          ),
                          child: Center(
                              child: Text(
                            "$imdbRating IMDB",
                            style: GoogleFonts.montserrat(
                              color: AppsColors.colWhite,
                            ),
                          )),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox()
          ],
        ),
        Row(
          children: [
            const SizedBox(width: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: poster != null && poster!.isNotEmpty
                  ? Image.network(
                      poster!,
                      fit: BoxFit.cover,
                      width: 120,
                      height: 200,
                      errorBuilder: (context, error, stackTrace) {
                        return const PlaceholderImage();
                      },
                    )
                  : const PlaceholderImage(),
            ),
          ],
        ),
      ],
    );
  }
}

class PlaceholderImage extends StatelessWidget {
  const PlaceholderImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 200,
      color: Colors.grey[300],
      child: const Center(
        child: Icon(
          Icons.broken_image,
          size: 50,
          color: Colors.grey,
        ),
      ),
    );
  }
}
