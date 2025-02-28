import 'dart:convert';
import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import '../model/pokedex.dart';
import '../model/pokemon.dart';

class PokedexDataSource extends ChangeNotifier {
  static const int limit = 20;
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

        // Fetch detailed data for each Pokemon
        final List<Pokemon> detailedResults = [];
        for (var basicPokemon in basicPokedex.results) {
          final detailedPokemon = await _fetchPokemonDetails(basicPokemon);
          detailedResults.add(detailedPokemon);
        }

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
      // Get detailed Pokemon data
      final detailedPokemon = await _getPokemonData(
        Uri.parse(basicPokemon.url),
      );

      // Get evolution chain data
      if (detailedPokemon.species != null) {
        final evolutionIds = await _getPokemonEvolutionChain(
          detailedPokemon.species!.url,
        );
        detailedPokemon.evolutionChainIds = evolutionIds;
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

  Future<List<int>> _getPokemonEvolutionChain(String speciesUrl) async {
    try {
      // First get the species data to find the evolution chain URL
      final speciesResponse = await http.get(Uri.parse(speciesUrl));
      if (speciesResponse.statusCode != 200) {
        throw Exception('Error loading Pokémon species data');
      }

      final speciesJson = jsonDecode(speciesResponse.body);
      final evolutionChainUrl = speciesJson['evolution_chain']['url'];

      // Now get the evolution chain
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

  List<int> _extractEvolutionChain(Map<String, dynamic> chain) {
    List<int> evolutionIds = [];

    // Helper function to extract ID from URL
    int extractId(String url) {
      final parts = url.split('/');
      return int.parse(parts[parts.length - 2]);
    }

    // Add the first Pokemon
    evolutionIds.add(extractId(chain['species']['url']));

    // Process evolution chain recursively
    void processChain(Map<String, dynamic> currentChain) {
      final evolvesTo = currentChain['evolves_to'];
      if (evolvesTo != null && evolvesTo.isNotEmpty) {
        for (var evolution in evolvesTo) {
          evolutionIds.add(extractId(evolution['species']['url']));
          processChain(evolution);
        }
      }
    }

    processChain(chain);
    return evolutionIds;
  }
}
