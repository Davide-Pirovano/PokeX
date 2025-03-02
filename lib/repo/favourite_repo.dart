import 'package:flutter/widgets.dart';

import '../data/favourites_data_source.dart';
import '../model/pokemon.dart';

class FavouriteRepo extends ChangeNotifier {
  final FavouritesDataSource _favouritesDataSource = FavouritesDataSource();

  List<Pokemon> favourites = [];

  FavouriteRepo() {
    _init(); // Inizializza il data source
  }

  Future<void> _init() async {
    await _favouritesDataSource.init();
    await reloadFavourites(); // Carica i preferiti inizialmente
  }

  Future<void> addFavourite(Pokemon pokemon) async {
    await _favouritesDataSource.addFavourite(pokemon);
    favourites.add(pokemon); // Aggiungi direttamente nella lista locale
    notifyListeners();
  }

  Future<void> removeFavourite(int pokemonId) async {
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
}
