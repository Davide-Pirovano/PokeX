// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pokemon.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PokemonAdapter extends TypeAdapter<Pokemon> {
  @override
  final int typeId = 0;

  @override
  Pokemon read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Pokemon(
      id: (fields[0] as num?)?.toInt(),
      name: fields[1] as String,
      height: (fields[2] as num?)?.toInt(),
      weight: (fields[3] as num?)?.toInt(),
      types:
          fields[4] == null ? const [] : (fields[4] as List).cast<TypeEntry>(),
      species: fields[5] as PokemonSpecies?,
      url: fields[6] as String,
      primaryType: fields[8] as poketype_util.PokemonType?,
      evolutionChainIds:
          (fields[9] as List?)?.map((e) => (e as List).cast<int>()).toList(),
      abilities:
          fields[7] == null ? const [] : (fields[7] as List).cast<Ability>(),
    );
  }

  @override
  void write(BinaryWriter writer, Pokemon obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.height)
      ..writeByte(3)
      ..write(obj.weight)
      ..writeByte(4)
      ..write(obj.types)
      ..writeByte(5)
      ..write(obj.species)
      ..writeByte(6)
      ..write(obj.url)
      ..writeByte(7)
      ..write(obj.abilities)
      ..writeByte(8)
      ..write(obj.primaryType)
      ..writeByte(9)
      ..write(obj.evolutionChainIds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PokemonAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TypeEntryAdapter extends TypeAdapter<TypeEntry> {
  @override
  final int typeId = 1;

  @override
  TypeEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TypeEntry(
      slot: (fields[0] as num).toInt(),
      type: fields[1] as TypeInfo,
    );
  }

  @override
  void write(BinaryWriter writer, TypeEntry obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.slot)
      ..writeByte(1)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TypeEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TypeInfoAdapter extends TypeAdapter<TypeInfo> {
  @override
  final int typeId = 2;

  @override
  TypeInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TypeInfo(name: fields[0] as String, url: fields[1] as String);
  }

  @override
  void write(BinaryWriter writer, TypeInfo obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.url);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TypeInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PokemonSpeciesAdapter extends TypeAdapter<PokemonSpecies> {
  @override
  final int typeId = 3;

  @override
  PokemonSpecies read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PokemonSpecies(name: fields[0] as String, url: fields[1] as String);
  }

  @override
  void write(BinaryWriter writer, PokemonSpecies obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.url);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PokemonSpeciesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AbilityAdapter extends TypeAdapter<Ability> {
  @override
  final int typeId = 4;

  @override
  Ability read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Ability(name: fields[0] as String, url: fields[1] as String);
  }

  @override
  void write(BinaryWriter writer, Ability obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.url);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AbilityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
