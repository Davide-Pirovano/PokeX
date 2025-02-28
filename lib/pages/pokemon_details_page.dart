import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokedex/util/get_pokemon_image.dart';
import 'package:pokedex/util/string_capitalize.dart';

import '../model/pokemon_preview.dart';
import '../widgets/pokemon_details_banner.dart';

class PokemonDetailsPage extends StatefulWidget {
  const PokemonDetailsPage({super.key, required this.pokemon});

  final PokemonPreview pokemon;

  @override
  State<PokemonDetailsPage> createState() => _PokemonDetailsPageState();
}

class _PokemonDetailsPageState extends State<PokemonDetailsPage> {
  bool isFavourite = false;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.pokemon.type?.color ?? Colors.white;

    return Scaffold(
      appBar: null,
      backgroundColor: backgroundColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Pulsante indietro
                  IconButton(
                    icon: const Icon(Icons.arrow_back, size: 32),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    splashRadius: 24,
                  ),

                  // Pulsante preferiti
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isFavourite = !isFavourite;
                      });
                    },
                    icon: Icon(
                      isFavourite ? Icons.favorite : Icons.favorite_border,
                      size: 32,
                      color:
                          isFavourite
                              ? const Color.fromARGB(255, 206, 96, 88)
                              : Colors.black,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    splashRadius: 24,
                  ),
                ],
              ),
            ),
            Expanded(child: PokemonDetailsContent(pokemon: widget.pokemon)),
          ],
        ),
      ),
    );
  }
}

class PokemonDetailsContent extends StatelessWidget {
  const PokemonDetailsContent({super.key, required this.pokemon});

  final PokemonPreview pokemon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Row(
            children: [
              Text(
                pokemon.name!.capitalize(),
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: GoogleFonts.montserrat().fontFamily,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                pokemon.pokemon!.id! < 100
                    ? "#0${pokemon.pokemon!.id.toString()}"
                    : "#${pokemon.pokemon!.id}",
                style: TextStyle(
                  fontSize: 30,
                  color: const Color.fromARGB(78, 0, 0, 0),
                  fontFamily: GoogleFonts.montserrat().fontFamily,
                ),
              ),
            ],
          ),
        ),
        getPokemonImage(url: pokemon.url, dimensione: 220),
        Expanded(child: PokemonDetailsBanner(pokemon: pokemon.pokemon!)),
      ],
    );
  }
}
