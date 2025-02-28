import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokedex/model/pokemon.dart';
import 'package:pokedex/util/color_util.dart';
import 'package:pokedex/util/get_pokemon_image.dart';
import 'package:pokedex/util/utils.dart';

import '../widgets/pokemon_details_banner.dart';

class PokemonDetailsPage extends StatefulWidget {
  const PokemonDetailsPage({super.key, required this.pokemon});

  final Pokemon pokemon;

  @override
  State<PokemonDetailsPage> createState() => _PokemonDetailsPageState();
}

class _PokemonDetailsPageState extends State<PokemonDetailsPage> {
  bool isFavourite = false;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.pokemon.primaryType?.color ?? Colors.white;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          /// **AppBar fissa**
          Container(
            padding: EdgeInsets.only(
              top: MediaQueryData.fromView(View.of(context)).padding.top,
            ),
            color: backgroundColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          size: 32,
                          color: Colors.black,
                        ),
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        splashRadius: 24,
                      ),
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
                                  ? ColorUtil().favouriteRed
                                  : Colors.black,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        splashRadius: 24,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Nome e ID Pokémon
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Text(
                          widget.pokemon.name.capitalize(),
                          style: TextStyle(
                            fontSize: 30,
                            fontFamily: GoogleFonts.montserrat().fontFamily,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.pokemon.id! < 100
                              ? "#0${widget.pokemon.id}"
                              : "#${widget.pokemon.id}",
                          style: TextStyle(
                            fontSize: 30,
                            color: ColorUtil().lightGrey,
                            fontFamily: GoogleFonts.montserrat().fontFamily,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// **Tutto il resto scorre**
          Expanded(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Container(
                color: backgroundColor,
                child: Column(
                  children: [
                    const SizedBox(height: 16),

                    // Immagine Pokémon
                    Center(
                      child: getPokemonImage(
                        id: widget.pokemon.id!,
                        dimensione: 220,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Banner con le info
                    PokemonDetailsBanner(pokemon: widget.pokemon),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
