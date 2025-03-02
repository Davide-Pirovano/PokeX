import 'dart:convert';
import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:pokex/repo/favourite_repo.dart';
import 'package:provider/provider.dart';
import '../model/pokedex.dart';
import '../model/pokemon.dart';
import '../util/pokemon_type.dart';

class PokedexDataSource extends ChangeNotifier {
  static final PokedexDataSource _instance = PokedexDataSource._internal();

  factory PokedexDataSource() => _instance;

  PokedexDataSource._internal();

  static const int limit = 20;
  int offset = 0;

  static const String _baseUrl = 'https://pokeapi.co/api/v2/pokemon/';

  Pokedex _pokedex = Pokedex();
  Pokedex get pokedex => _pokedex;

  bool isLoading = false;
  bool hasNext = true;

  Future<void> fetchPokedex() async {
    if (isLoading || !hasNext) return;

    isLoading = true;
    notifyListeners();

    final uri = Uri.parse('$_baseUrl?limit=$limit&offset=$offset');

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final basicPokedex = Pokedex.fromJson(json);

        // Fetch basic details in parallel
        final basicResults = await Future.wait(
          basicPokedex.results.map(
            (basicPokemon) => _fetchBasicPokemonDetails(basicPokemon),
          ),
        );

        _pokedex = Pokedex(
          count: basicPokedex.count,
          next: basicPokedex.next,
          previous: basicPokedex.previous,
          results: [..._pokedex.results, ...basicResults],
        );

        offset += limit;
        hasNext = _pokedex.next != null;
      } else {
        throw Exception('Error loading Pokédex: ${response.statusCode}');
      }
    } catch (e) {
      log('Error during fetch: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<Pokemon> _fetchBasicPokemonDetails(Pokemon basicPokemon) async {
    try {
      final response = await http.get(Uri.parse(basicPokemon.url));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final typesList = List<TypeEntry>.from(
          json['types'].map((x) => TypeEntry.fromJson(x)),
        );
        final pokemon = Pokemon(
          id: json['id'],
          name: json['name'].split("-").first, // Split qui per i dati base
          url: basicPokemon.url,
          types: typesList,
        );
        if (typesList.isNotEmpty) {
          pokemon.primaryType = getPokemonTypeFromString(
            typesList.first.type.name.toUpperCase(),
          );
        }
        return pokemon;
      }
      return basicPokemon;
    } catch (e) {
      log('Error fetching basic details for ${basicPokemon.name}: $e');
      return basicPokemon;
    }
  }

  Future<void> fetchPokemonDetails(
    String pokemonName,
    BuildContext context,
  ) async {
    final pokedexDataSource = Provider.of<PokedexDataSource>(
      context,
      listen: false,
    );
    final favouriteRepo = Provider.of<FavouriteRepo>(context, listen: false);

    int pokedexIndex = pokedexDataSource.pokedex.results.indexWhere(
      (p) => p.name == pokemonName,
    );
    int favouriteIndex = favouriteRepo.favourites.indexWhere(
      (p) => p.name == pokemonName,
    );

    Pokemon pokemon;
    bool isFromPokedex = false;

    if (pokedexIndex != -1) {
      pokemon = pokedexDataSource.pokedex.results[pokedexIndex];
      isFromPokedex = true;
    } else if (favouriteIndex != -1) {
      pokemon = favouriteRepo.favourites[favouriteIndex];
    } else {
      log('Pokémon $pokemonName non trovato né nel Pokédex né nei preferiti');
      return;
    }

    try {
      final response = await http.get(Uri.parse(pokemon.url));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        Pokemon updatedPokemon = Pokemon.fromJson(json);

        if (updatedPokemon.species != null &&
            updatedPokemon.species!.url.isNotEmpty) {
          final evolutionChains = await _getPokemonEvolutionChain(
            updatedPokemon.species!.url,
          );
          updatedPokemon.evolutionChainIds = evolutionChains;
          log('Evolution chain caricata per $pokemonName: $evolutionChains');
        } else {
          log('Nessuna specie trovata per $pokemonName');
        }

        if (isFromPokedex) {
          pokedexDataSource.pokedex.results[pokedexIndex] = updatedPokemon;
          pokedexDataSource.notifyListeners();
          log(
            'Dettagli aggiornati nel Pokédex per $pokemonName: ${updatedPokemon.toJson()}',
          );
        }
        if (favouriteIndex != -1) {
          await favouriteRepo.updateFavourite(
            updatedPokemon,
          ); // Aggiorna invece di aggiungere
          log(
            'Dettagli aggiornati nei preferiti per $pokemonName: ${updatedPokemon.toJson()}',
          );
        }
      } else {
        throw Exception(
          'Error fetching details for $pokemonName: ${response.statusCode}',
        );
      }
    } catch (e) {
      log('Error fetching details for $pokemonName: $e');
    }
  }

  Future<List<List<int>>> _getPokemonEvolutionChain(String speciesUrl) async {
    try {
      final speciesResponse = await http.get(Uri.parse(speciesUrl));
      if (speciesResponse.statusCode != 200) {
        throw Exception('Error loading Pokémon species data');
      }

      final speciesJson = jsonDecode(speciesResponse.body);
      final evolutionChainUrl = speciesJson['evolution_chain']['url'];

      final evolutionResponse = await http.get(Uri.parse(evolutionChainUrl));
      if (evolutionResponse.statusCode != 200) {
        throw Exception('Error loading evolution chain data');
      }

      final evolutionJson = jsonDecode(evolutionResponse.body);
      return _extractEvolutionChain(evolutionJson['chain']);
    } catch (e) {
      log('Error getting evolution chain: $e');
      return [];
    }
  }

  List<List<int>> _extractEvolutionChain(Map<String, dynamic> chain) {
    List<List<int>> evolutionChains = [];

    int extractId(String url) {
      final parts = url.split('/');
      return int.parse(parts[parts.length - 2]);
    }

    void buildChains(Map<String, dynamic> currentChain, List<int> currentPath) {
      currentPath.add(extractId(currentChain['species']['url']));

      if (currentChain['evolves_to'] == null ||
          currentChain['evolves_to'].isEmpty) {
        evolutionChains.add(List.from(currentPath));
      } else {
        for (var evolution in currentChain['evolves_to']) {
          buildChains(evolution, List.from(currentPath));
        }
      }
    }

    buildChains(chain, []);
    return evolutionChains;
  }
}
