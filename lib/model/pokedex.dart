import 'pokemon_preview.dart';

class Pokedex {
  int? count;
  String? next;
  String? previous;
  List<PokemonPreview>? results;

  Pokedex({this.count, this.next, this.previous, this.results});

  Pokedex.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <PokemonPreview>[];
      json['results'].forEach((v) {
        results!.add(PokemonPreview.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['next'] = next;
    data['previous'] = previous;
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
