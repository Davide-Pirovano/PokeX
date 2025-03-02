import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/pokedex_data_source.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dataSource = Provider.of<PokedexDataSource>(context, listen: false);
      // Carica i dettagli solo se non sono già completi
      if (widget.pokemon.height == null || widget.pokemon.weight == null) {
        dataSource.fetchPokemonDetails(widget.pokemon.name);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PokedexDataSource>(
      builder: (context, dataSource, child) {
        // Trova il Pokémon aggiornato nella lista
        final updatedPokemon = dataSource.pokedex.results.firstWhere(
          (p) => p.name == widget.pokemon.name,
        );
        final backgroundColor =
            updatedPokemon.primaryType?.color ?? Colors.white;

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Column(
            children: [
              /// **AppBar fissa**
              Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top,
                ),
                color: backgroundColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 16,
                  ),
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
                          FavSelector(pokemon: updatedPokemon),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Text(
                              updatedPokemon.name.capitalize(),
                              style: const TextStyle(fontSize: 30),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              updatedPokemon.id! < 100
                                  ? "#0${updatedPokemon.id}"
                                  : "#${updatedPokemon.id}",
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
                        Center(
                          child: getPokemonImage(
                            id: updatedPokemon.id!,
                            dimensione: 200,
                          ),
                        ),
                        PokemonDetailsBanner(pokemon: updatedPokemon),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
