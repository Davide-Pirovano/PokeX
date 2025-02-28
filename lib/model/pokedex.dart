import 'pokemon.dart';

class Pokedex {
  final int? count;
  final String? next;
  final String? previous;
  final List<Pokemon> results;

  Pokedex({this.count, this.next, this.previous, this.results = const []});

  factory Pokedex.fromJson(Map<String, dynamic> json) {
    return Pokedex(
      count: json["count"],
      next: json["next"],
      previous: json["previous"],
      results:
          json["results"] != null
              ? List<Pokemon>.from(
                json["results"].map((x) => Pokemon.fromListResult(x)),
              )
              : [],
    );
  }

  // Create a copy with new results
  Pokedex copyWith({
    int? count,
    String? next,
    String? previous,
    List<Pokemon>? results,
  }) {
    return Pokedex(
      count: count ?? this.count,
      next: next ?? this.next,
      previous: previous ?? this.previous,
      results: results ?? this.results,
    );
  }
}
