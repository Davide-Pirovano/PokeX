import 'package:pokedex/util/pokemon_type.dart' as poketype_util;

class Pokemon {
  final int? id;
  final String name;
  final int? height;
  final int? weight;
  final List<TypeEntry> types;
  final PokemonSpecies? species;
  final String url;
  final List<Ability> abilities;
  poketype_util.PokemonType? primaryType;
  List<int>? evolutionChainIds;

  Pokemon({
    this.id,
    required this.name,
    this.height,
    this.weight,
    this.types = const [],
    this.species,
    required this.url,
    this.primaryType,
    this.evolutionChainIds,
    this.abilities = const [],
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    // Parse types if available
    List<TypeEntry> typesList = [];
    if (json.containsKey("types") && json["types"] != null) {
      typesList = List<TypeEntry>.from(
        json["types"].map((x) => TypeEntry.fromJson(x)),
      );
    }

    // Parse species if available
    PokemonSpecies? speciesData;
    if (json.containsKey("species") && json["species"] != null) {
      speciesData = PokemonSpecies.fromJson(json["species"]);
    }

    // Parse abilities if available
    List<Ability> abilitiesList = [];
    if (json.containsKey("abilities") && json["abilities"] is List) {
      abilitiesList = List<Ability>.from(
        json["abilities"].map((x) => Ability.fromJson(x["ability"])),
      );
    }

    // Create the Pokemon object
    Pokemon pokemon = Pokemon(
      id: json["id"],
      name: json["name"],
      height: json["height"],
      weight: json["weight"],
      types: typesList,
      species: speciesData,
      url: json["url"] ?? "",
      abilities: abilitiesList,
    );

    // Set the primary type if types are available
    if (typesList.isNotEmpty) {
      pokemon.primaryType = poketype_util.getPokemonTypeFromString(
        typesList.first.type.name.toUpperCase(),
      );
    }

    return pokemon;
  }

  // For creating Pokemon from list results
  factory Pokemon.fromListResult(Map<String, dynamic> json) {
    return Pokemon(name: json["name"], url: json["url"]);
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "height": height,
    "weight": weight,
    "types": types.map((type) => type.toJson()).toList(),
    "species": species?.toJson(),
    "url": url,
    "evolutionChainIds": evolutionChainIds,
    "abilities": abilities.map((ability) => ability.toJson()).toList(),
  };
}

// Renamed from PokemonType to TypeEntry to avoid conflict
class TypeEntry {
  final int slot;
  final TypeInfo type;

  TypeEntry({required this.slot, required this.type});

  factory TypeEntry.fromJson(Map<String, dynamic> json) {
    return TypeEntry(slot: json["slot"], type: TypeInfo.fromJson(json["type"]));
  }

  Map<String, dynamic> toJson() => {"slot": slot, "type": type.toJson()};
}

class TypeInfo {
  final String name;
  final String url;

  TypeInfo({required this.name, required this.url});

  factory TypeInfo.fromJson(Map<String, dynamic> json) {
    return TypeInfo(name: json["name"], url: json["url"]);
  }

  Map<String, dynamic> toJson() => {"name": name, "url": url};
}

class PokemonSpecies {
  final String name;
  final String url;

  PokemonSpecies({required this.name, required this.url});

  factory PokemonSpecies.fromJson(Map<String, dynamic> json) {
    return PokemonSpecies(name: json["name"], url: json["url"]);
  }

  Map<String, dynamic> toJson() => {"name": name, "url": url};
}

class Ability {
  final String name;
  final String url;

  Ability({required this.name, required this.url});

  factory Ability.fromJson(Map<String, dynamic> json) {
    return Ability(name: json["name"], url: json["url"]);
  }

  Map<String, dynamic> toJson() => {"name": name, "url": url};
}
