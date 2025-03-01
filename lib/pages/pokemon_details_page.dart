import 'package:flutter/material.dart';
import '../model/pokemon.dart';
import '../util/color_util.dart';
import '../util/get_pokemon_image.dart';
import '../util/utils.dart';
import '../widgets/fav_selector.dart';
import '../widgets/pokemon_details_banner.dart';

class PokemonDetailsPage extends StatefulWidget {
  const PokemonDetailsPage({super.key, required this.pokemon});

  final Pokemon pokemon;

  @override
  State<PokemonDetailsPage> createState() => _PokemonDetailsPageState();
}

class _PokemonDetailsPageState extends State<PokemonDetailsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.pokemon.primaryType?.color ?? Colors.white;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          /// **AppBar fissa**
          Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            color: backgroundColor,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          size: 32,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        splashRadius: 24,
                      ),
                      FavSelector(pokemon: widget.pokemon),
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
                          style: TextStyle(fontSize: 30),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.pokemon.id! < 100
                              ? "#0${widget.pokemon.id}"
                              : "#${widget.pokemon.id}",
                          style: TextStyle(
                            fontSize: 30,
                            color: ColorUtil().lightGrey,
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
                        dimensione: 200,
                      ),
                    ),
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
