import 'package:flutter/material.dart';

Widget getPokemonImage({String? url, double? dimensione}) {
  if (url == null) return const Icon(Icons.image_not_supported);

  dimensione ??= 50;

  // Estrai l'ID dall'URL in modo più affidabile
  final uri = Uri.parse(url);
  final pathSegments = uri.pathSegments;

  if (pathSegments.length < 2) return const Icon(Icons.image_not_supported);

  final pokemonId = pathSegments[pathSegments.length - 2];

  // URL dell'immagine
  final imageUrl =
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$pokemonId.png';

  return Image.network(
    imageUrl,
    width: dimensione,
    height: dimensione,
    fit: BoxFit.contain,
    loadingBuilder: (context, child, loadingProgress) {
      if (loadingProgress == null) return child;
      return SizedBox(
        width: dimensione,
        height: dimensione,
        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    },
    errorBuilder: (context, error, stackTrace) {
      return const Icon(Icons.image_not_supported);
    },
  );
}
