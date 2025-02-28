import 'package:hive_ce/hive.dart';
import '../model/pokemon.dart';

class FavouritesDataSource {
  static const String _boxName = "favouritesBox";

  /// **Inizializza Hive e apre il box dei preferiti**
  Future<void> init() async {
    await Hive.openBox<Pokemon>(_boxName);
  }

  /// **Aggiunge un Pokémon ai preferiti**
  Future<void> addFavourite(Pokemon pokemon) async {
    final box = Hive.box<Pokemon>(_boxName);

    if (!box.values.any((p) => p.id == pokemon.id)) {
      await box.add(pokemon);
    }
  }

  /// **Rimuove un Pokémon dai preferiti**
  Future<void> removeFavourite(int pokemonId) async {
    final box = Hive.box<Pokemon>(_boxName);

    final key = box.keys.firstWhere(
      (key) => box.get(key)?.id == pokemonId,
      orElse: () => null,
    );

    if (key != null) {
      await box.delete(key);
    }
  }

  /// **Recupera tutti i Pokémon preferiti**
  List<Pokemon> getFavourites() {
    final box = Hive.box<Pokemon>(_boxName);
    return box.values.toList();
  }

  /// **Verifica se un Pokémon è nei preferiti**
  bool isFavourite(int pokemonId) {
    final box = Hive.box<Pokemon>(_boxName);
    return box.values.any((pokemon) => pokemon.id == pokemonId);
  }

  /// **Svuota tutti i preferiti**
  Future<void> clearFavourites() async {
    final box = Hive.box<Pokemon>(_boxName);
    await box.clear();
  }
}
