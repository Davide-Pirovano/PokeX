import 'dart:convert';
import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import '../model/pokedex.dart';
import '../model/pokemon.dart';

class PokedexDataSource extends ChangeNotifier {
  static final PokedexDataSource _instance = PokedexDataSource._internal();

  factory PokedexDataSource() {
    return _instance;
  }

  PokedexDataSource._internal();

  static const int limit = 20; // Ridotto da 40 a 20 come suggerito
  int offset = 0;

  static const String _baseUrl = 'https://pokeapi.co/api/v2/pokemon/';

  Pokedex _pokedex = Pokedex();
  Pokedex get pokedex => _pokedex;

  bool isLoading = false;
  bool hasNext = true;

  Future<void> fetchPokedex() async {
    if (isLoading || !hasNext) {
      return; // Avoid multiple calls during loading
    }

    isLoading = true;
    notifyListeners(); // Notify loading state

    final uri = Uri.parse('$_baseUrl?limit=$limit&offset=$offset');

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        // Parse the basic list response
        final json = jsonDecode(response.body);
        final basicPokedex = Pokedex.fromJson(json);

        // Update pagination data
        _pokedex = Pokedex(
          count: basicPokedex.count,
          next: basicPokedex.next,
          previous: basicPokedex.previous,
          results: [..._pokedex.results], // Keep existing results
        );

        // Fetch detailed data for each Pokemon in parallel
        final detailedResults = await Future.wait(
          basicPokedex.results.map(
            (basicPokemon) => _fetchPokemonDetails(basicPokemon),
          ),
        );

        // Add new results to existing results
        _pokedex = Pokedex(
          count: _pokedex.count,
          next: _pokedex.next,
          previous: _pokedex.previous,
          results: [..._pokedex.results, ...detailedResults],
        );

        // Update for next page
        offset += limit;
        hasNext = _pokedex.next != null;
      } else {
        throw Exception('Error loading Pokédex: ${response.statusCode}');
      }
    } catch (e) {
      log('Error during fetch: $e');
    } finally {
      isLoading = false;
      notifyListeners(); // Notify that data is ready or there was an error
    }
  }

  Future<Pokemon> _fetchPokemonDetails(Pokemon basicPokemon) async {
    try {
      // Parallelize fetching Pokémon data and species/evolution chain data
      final pokemonDataFuture = _getPokemonData(Uri.parse(basicPokemon.url));
      final detailedPokemon = await pokemonDataFuture;

      // Fetch evolution chain only if species exists
      if (detailedPokemon.species != null) {
        final evolutionChainsFuture = _getPokemonEvolutionChain(
          detailedPokemon.species!.url,
        );
        detailedPokemon.evolutionChainIds = await evolutionChainsFuture;
      }

      return detailedPokemon;
    } catch (e) {
      log('Error fetching details for ${basicPokemon.name}: $e');
      return basicPokemon; // Return basic data if detailed fetch fails
    }
  }

  Future<Pokemon> _getPokemonData(Uri url) async {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Pokemon.fromJson(json);
    } else {
      throw Exception('Error loading Pokémon data');
    }
  }

  Future<List<List<int>>> _getPokemonEvolutionChain(String speciesUrl) async {
    try {
      // Parallelize species and evolution chain requests
      final speciesResponseFuture = http.get(Uri.parse(speciesUrl));
      final speciesResponse = await speciesResponseFuture;

      if (speciesResponse.statusCode != 200) {
        throw Exception('Error loading Pokémon species data');
      }

      final speciesJson = jsonDecode(speciesResponse.body);
      final evolutionChainUrl = speciesJson['evolution_chain']['url'];

      final evolutionResponseFuture = http.get(Uri.parse(evolutionChainUrl));
      final evolutionResponse = await evolutionResponseFuture;

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

    // Helper function to extract ID from URL
    int extractId(String url) {
      final parts = url.split('/');
      return int.parse(parts[parts.length - 2]);
    }

    // Function to recursively build evolution chains
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
