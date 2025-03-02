import 'package:flutter/material.dart';
import 'package:pokex/widgets/pokemon_details_banner.dart';
import 'package:provider/provider.dart';
import '../data/pokedex_data_source.dart';
import '../model/pokemon.dart';
import '../repo/favourite_repo.dart';
import '../util/color_util.dart';
import '../util/get_pokemon_image.dart';
import '../util/utils.dart';
import '../widgets/fav_selector.dart';

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
      // Controlla se mancano dettagli critici
      if (widget.pokemon.height == null ||
          widget.pokemon.weight == null ||
          widget.pokemon.evolutionChainIds == null) {
        dataSource.fetchPokemonDetails(widget.pokemon.name, context).catchError(
          (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Errore nel caricamento dei dettagli: $e'),
                ),
              );
            }
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<PokedexDataSource, FavouriteRepo>(
      builder: (context, dataSource, favouriteRepo, child) {
        // Trova il Pokémon aggiornato
        final updatedPokemon = dataSource.pokedex.results.firstWhere(
          (p) => p.name == widget.pokemon.name,
          orElse:
              () => favouriteRepo.favourites.firstWhere(
                (p) => p.name == widget.pokemon.name,
                orElse: () => widget.pokemon,
              ),
        );
        final backgroundColor =
            updatedPokemon.primaryType?.color ?? Colors.white;

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Column(
            children: [
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
