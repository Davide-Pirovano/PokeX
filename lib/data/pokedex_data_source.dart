import 'dart:convert';
import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:pokedex/model/pokedex.dart';
import 'package:http/http.dart' as http;
import 'package:pokedex/util/pokemon_type.dart';

import '../model/pokemon.dart';

class PokedexDataSource extends ChangeNotifier {
  static const int limit = 20;
  int offset = 0;

  static const String _baseUrl = 'https://pokeapi.co/api/v2/pokemon/';

  final Pokedex pokedex = Pokedex();
  bool isLoading = false;
  bool hasNext = true;

  Future<void> fetchPokedex() async {
    if (isLoading || !hasNext) {
      return; // Evita chiamate multiple durante il caricamento
    }

    isLoading = true;
    notifyListeners(); // Notifica lo stato di caricamento

    final uri = Uri.parse('$_baseUrl?limit=$limit&offset=$offset');

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        Pokedex fetchedPokedex = Pokedex.fromJson(json.decode(response.body));

        // Assegna i valori di base
        pokedex.count = fetchedPokedex.count;
        pokedex.next = fetchedPokedex.next;
        pokedex.previous = fetchedPokedex.previous;

        // Assicurati che `results` non sia null prima di aggiungere
        if (fetchedPokedex.results != null) {
          pokedex.results ??= [];
          for (var i = 0; i < fetchedPokedex.results!.length; i++) {
            // fetch pokemon type
            fetchedPokedex.results![i].pokemon = await getPokemon(
              Uri.parse(fetchedPokedex.results![i].url.toString()),
            );

            var type =
                fetchedPokedex.results![i].pokemon?.types.first.type!.name!
                    .toUpperCase();

            // ottengo il colore del tipo da dall'util pokemon_type
            final pokemonType = getPokemonTypeFromString(type!);
            fetchedPokedex.results![i].type = pokemonType;

            // add to pokedex
            pokedex.results!.add(fetchedPokedex.results![i]);
          }
        }

        // Aggiorna l'offset per la prossima chiamata
        offset += limit;
        hasNext = fetchedPokedex.next != null;
      } else {
        throw Exception(
          'Errore nel caricamento del Pokédex: ${response.statusCode}',
        );
      }
    } catch (e) {
      log('Errore durante il fetch: $e');
    } finally {
      isLoading = false;
      notifyListeners(); // Notifica che i dati sono pronti o che c'è stato un errore
    }
  }

  Future<Pokemon> getPokemon(Uri url) async {
    // chiamo fetchPokemon e recupero il tipo
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      var pokemon = Pokemon.fromJson(json);
      return pokemon;
    } else {
      throw Exception('Errore nel caricamento del Pokémon');
    }
  }
}
