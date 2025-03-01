import 'package:hive_ce/hive.dart';
import '../util/pokemon_type.dart' as poketype_util;

part 'pokemon.g.dart'; // flutter pub run build_runner build

@HiveType(typeId: 0)
class Pokemon extends HiveObject {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int? height;

  @HiveField(3)
  final int? weight;

  @HiveField(4)
  final List<TypeEntry> types;

  @HiveField(5)
  final PokemonSpecies? species;

  @HiveField(6)
  final String url;

  @HiveField(7)
  final List<Ability> abilities;

  @HiveField(8)
  poketype_util.PokemonType? primaryType;

  @HiveField(9)
  List<List<int>>? evolutionChainIds; // Cambiato in List<List<int>>

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
    List<TypeEntry> typesList = [];
    if (json.containsKey("types") && json["types"] != null) {
      typesList = List<TypeEntry>.from(
        json["types"].map((x) => TypeEntry.fromJson(x)),
      );
    }

    PokemonSpecies? speciesData;
    if (json.containsKey("species") && json["species"] != null) {
      speciesData = PokemonSpecies.fromJson(json["species"]);
    }

    List<Ability> abilitiesList = [];
    if (json.containsKey("abilities") && json["abilities"] is List) {
      abilitiesList = List<Ability>.from(
        json["abilities"].map((x) => Ability.fromJson(x["ability"])),
      );
    }

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

    if (typesList.isNotEmpty) {
      pokemon.primaryType = poketype_util.getPokemonTypeFromString(
        typesList.first.type.name.toUpperCase(),
      );
    }

    return pokemon;
  }

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

@HiveType(typeId: 1)
class TypeEntry {
  @HiveField(0)
  final int slot;

  @HiveField(1)
  final TypeInfo type;

  TypeEntry({required this.slot, required this.type});

  factory TypeEntry.fromJson(Map<String, dynamic> json) {
    return TypeEntry(slot: json["slot"], type: TypeInfo.fromJson(json["type"]));
  }

  Map<String, dynamic> toJson() => {"slot": slot, "type": type.toJson()};
}

@HiveType(typeId: 2)
class TypeInfo {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String url;

  TypeInfo({required this.name, required this.url});

  factory TypeInfo.fromJson(Map<String, dynamic> json) {
    return TypeInfo(name: json["name"], url: json["url"]);
  }

  Map<String, dynamic> toJson() => {"name": name, "url": url};
}

@HiveType(typeId: 3)
class PokemonSpecies {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String url;

  PokemonSpecies({required this.name, required this.url});

  factory PokemonSpecies.fromJson(Map<String, dynamic> json) {
    return PokemonSpecies(name: json["name"], url: json["url"]);
  }

  Map<String, dynamic> toJson() => {"name": name, "url": url};
}

@HiveType(typeId: 4)
class Ability {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String url;

  Ability({required this.name, required this.url});

  factory Ability.fromJson(Map<String, dynamic> json) {
    return Ability(name: json["name"], url: json["url"]);
  }

  Map<String, dynamic> toJson() => {"name": name, "url": url};
}
