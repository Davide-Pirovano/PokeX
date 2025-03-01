import 'package:flutter/material.dart';

Widget getPokemonImage({double? dimensione, required int id}) {
  dimensione ??= 40;
  final imageUrl =
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';
  //'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';

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
