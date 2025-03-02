import 'package:supabase_flutter/supabase_flutter.dart';

class FavouritesDataSource {
  final database = Supabase.instance.client.from('favorites');

  // Ottieni la lista dei preferiti dell'utente corrente
  Future<List<int>> getFavourites() async {
    try {
      final response =
          await database
              .select('pokemon_ids')
              .eq('user_id', Supabase.instance.client.auth.currentUser!.id)
              .maybeSingle();

      if (response == null) {
        // Nessuna riga trovata, restituisci lista vuota
        return [];
      }

      // Converte l'array di PostgreSQL (pokemon_ids) in una List<int>
      return (response['pokemon_ids'] as List<dynamic>?)?.cast<int>() ?? [];
    } catch (e) {
      print('Errore durante il recupero dei preferiti: $e');
      return [];
    }
  }

  // Aggiungi un Pokémon ai preferiti
  Future<void> addFavourite(int pokemonId) async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) throw Exception("Utente non autenticato");

      final currentFavourites = await getFavourites();

      if (currentFavourites.contains(pokemonId)) return;

      final updatedFavourites = [...currentFavourites, pokemonId];

      await database
          .update({
            'pokemon_ids': updatedFavourites,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('user_id', userId);
    } catch (e) {
      print('Errore durante l\'aggiunta del preferito: $e');
    }
  }

  // Rimuovi un Pokémon dai preferiti
  Future<void> removeFavourite(int pokemonId) async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) throw Exception("Utente non autenticato");

      final currentFavourites = await getFavourites();

      if (!currentFavourites.contains(pokemonId)) return;

      final updatedFavourites =
          currentFavourites.where((id) => id != pokemonId).toList();

      await database
          .update({
            'pokemon_ids': updatedFavourites,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('user_id', userId);
    } catch (e) {
      print('Errore durante la rimozione del preferito: $e');
    }
  }
}
