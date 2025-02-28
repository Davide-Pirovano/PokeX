import 'package:pokedex/util/pokemon_type.dart';

import 'pokemon.dart';

class PokemonPreview {
  String? name;
  String? url;
  PokemonType? type;
  Pokemon? pokemon;

  PokemonPreview({this.name, this.url, this.type, this.pokemon});

  PokemonPreview.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    url = json['url'];
    type = null;
    pokemon = null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['url'] = url;
    data['type'] = null;
    data['pokemon'] = null;
    return data;
  }
}
