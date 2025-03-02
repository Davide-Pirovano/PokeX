import 'package:flutter/widgets.dart';
import 'package:pokex/data/remote/favourites_data_source.dart';
import 'package:pokex/data/remote/pokedex_data_source.dart';

import '../data/local/favourites_local_data_source.dart';
import '../model/pokemon.dart';

class FavouriteRepo extends ChangeNotifier {
  final FavouritesLocalDataSource _favouritesDataSource =
      FavouritesLocalDataSource();

  final FavouritesDataSource _favouritesCloudDataSource =
      FavouritesDataSource();

  final PokedexDataSource _pokedexDataSource = PokedexDataSource();

  List<Pokemon> favourites = [];

  FavouriteRepo() {
    _init(); // Inizializza il data source
  }

  Future<void> _init() async {
    await _favouritesDataSource.init();
    await reloadFavourites(); // Carica i preferiti inizialmente
  }

  Future<void> addFavourite(Pokemon pokemon) async {
    await _favouritesCloudDataSource.addFavourite(pokemon.id!);
    await _favouritesDataSource.addFavourite(pokemon);
    favourites.add(pokemon); // Aggiungi direttamente nella lista locale
    notifyListeners();
  }

  Future<void> removeFavourite(int pokemonId) async {
    await _favouritesCloudDataSource.removeFavourite(pokemonId);
    await _favouritesDataSource.removeFavourite(pokemonId);
    favourites.removeWhere(
      (pokemon) => pokemon.id == pokemonId,
    ); // Rimuovi dalla lista locale
    notifyListeners();
  }

  Future<void> reloadFavourites() async {
    favourites = _favouritesDataSource.getFavourites(); // Aggiungi await
    notifyListeners();
  }

  bool isFavourite(int id) {
    // Controlla direttamente nella lista preferiti locale
    return favourites.any((pokemon) => pokemon.id == id);
  }

  Future<void> updateFavourite(Pokemon updatedPokemon) async {
    final index = favourites.indexWhere((p) => p.id == updatedPokemon.id);
    if (index != -1) {
      // Aggiorna nella lista locale
      favourites[index] = updatedPokemon;
      // Sincronizza con il database
      await _favouritesDataSource.addFavourite(
        updatedPokemon,
      ); // Usa addFavourite che sovrascrive
      notifyListeners();
    }
  }

  /// Sincronizza i preferiti tra cloud e locale, dando priorità al cloud
  /// Scarica solo le informazioni base dei Pokémon "in più" usando PokedexDataSource
  Future<void> syncFavouriteWithSupabase() async {
    try {
      // Recupera gli ID dei preferiti dal cloud
      final cloudIds = await _favouritesCloudDataSource.getFavourites();

      // Recupera i Pokémon locali e mappa i loro ID
      final localPokemons = _favouritesDataSource.getFavourites();
      final localIds = localPokemons.map((p) => p.id).toList();

      // Identifica gli ID "in più" presenti solo nel cloud
      final cloudOnlyIds =
          cloudIds.where((id) => !localIds.contains(id)).toList();

      // Identifica gli ID "da rimuovere", presenti solo nel locale
      final localOnlyIds =
          localIds.where((id) => !cloudIds.contains(id)).toList();

      if (cloudOnlyIds.isNotEmpty) {
        // Scarica le info base dei Pokémon "in più"
        final basicPokemons = await Future.wait(
          cloudOnlyIds.map((id) async {
            final basicPokemon = await _pokedexDataSource.getBasicPokemonById(
              id,
            );
            return basicPokemon;
          }),
        );

        // Aggiungi i Pokémon al database locale
        for (final pokemon in basicPokemons) {
          await _favouritesDataSource.addFavourite(pokemon);
          print('Aggiunto Pokémon ${pokemon.id} - ${pokemon.name} al locale');
        }
      }

      if (localOnlyIds.isNotEmpty) {
        // Rimuovi i Pokémon che non sono più preferiti nel cloud
        for (final id in localOnlyIds) {
          await _favouritesDataSource.removeFavourite(id!);
          print('Rimosso Pokémon con ID $id dal locale');
        }
      }

      // Aggiorna la lista locale notificando i listener
      await reloadFavourites();

      print('Sincronizzazione completata.');
    } catch (e) {
      print('Errore durante la sincronizzazione: $e');
    }
  }
}
