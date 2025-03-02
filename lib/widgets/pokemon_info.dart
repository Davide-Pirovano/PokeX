import 'package:flutter/material.dart';
import '../model/pokemon.dart';
import '../util/get_pokemon_image.dart';
import '../util/pokemon_type.dart';
import '../util/utils.dart';

class PokemonInfo extends StatelessWidget {
  const PokemonInfo({super.key, required this.pokemon});

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    // Se i dati dettagliati non sono ancora caricati, mostra un indicatore di caricamento
    if (pokemon.height == null ||
        pokemon.weight == null ||
        pokemon.evolutionChainIds == null) {
      return const Padding(
        padding: EdgeInsets.all(40),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 40, bottom: 40),
      child: Column(
        children: [
          TypesDetails(type: pokemon.types),
          const SizedBox(height: 24),
          Details(details: pokemon),
          const SizedBox(height: 24),
          EvolutionLine(
            evolution: pokemon.evolutionChainIds!,
            colorType: pokemon.primaryType?.color ?? Colors.grey,
          ),
          const SizedBox(height: 24),
          Abilities(
            abilities: pokemon.abilities,
            colorType: pokemon.primaryType?.color ?? Colors.grey,
          ),
        ],
      ),
    );
  }
}

class TypesDetails extends StatelessWidget {
  const TypesDetails({super.key, required this.type});

  final List<TypeEntry> type;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children:
          type
              .map(
                (e) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    color:
                        getPokemonTypeFromString(e.type.name)?.color ??
                        Colors.white,
                  ),
                  child: Text(
                    e.type.name.toUpperCase(),
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
              .toList(),
    );
  }
}

class Details extends StatelessWidget {
  const Details({super.key, required this.details});

  final Pokemon details;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Text(
              "${formatToMeters(details.height!)} m",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color:
                    getPokemonTypeFromString(
                      details.types.first.type.name,
                    )?.color ??
                    Colors.white,
              ),
            ),
            const Text("Height"),
          ],
        ),
        Column(
          children: [
            Text(
              "${formatToKg(details.weight!)} kg",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color:
                    getPokemonTypeFromString(
                      details.types.first.type.name,
                    )?.color ??
                    Colors.white,
              ),
            ),
            const Text("Weight"),
          ],
        ),
      ],
    );
  }
}

class EvolutionLine extends StatelessWidget {
  const EvolutionLine({
    super.key,
    required this.evolution,
    required this.colorType,
  });

  final List<List<int>> evolution;
  final Color colorType;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          evolution.length > 1 ? "Evolution Chains" : "Evolution Chain",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: colorType,
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < evolution.length; i++) ...[
                  Row(
                    children: [
                      Text(
                        "[${i + 1}]",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 24),
                      for (var j = 0; j < evolution[i].length; j++) ...[
                        getPokemonImage(id: evolution[i][j], dimensione: 55),
                        const SizedBox(width: 8),
                        if (j < evolution[i].length - 1)
                          const Icon(Icons.arrow_forward, color: Colors.grey),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class Abilities extends StatelessWidget {
  const Abilities({
    super.key,
    required this.abilities,
    required this.colorType,
  });

  final Color colorType;
  final List<Ability> abilities;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Abilities",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: colorType,
          ),
        ),
        const SizedBox(height: 8),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (abilities.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "First Ability",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Text(
                    abilities[0].name.capitalize(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
            if (abilities.length > 1) ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Special Ability",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Text(
                    abilities[1].name.capitalize(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ],
    );
  }
}
