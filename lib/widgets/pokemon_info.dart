import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokedex/model/pokemon.dart';
import 'package:pokedex/theme/theme_provider.dart';
import 'package:pokedex/util/get_pokemon_image.dart';
import 'package:pokedex/util/pokemon_type.dart';
import 'package:provider/provider.dart';
import '../util/utils.dart';

class PokemonInfo extends StatelessWidget {
  const PokemonInfo({super.key, required this.pokemon});

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 50,
        bottom: MediaQueryData.fromView(View.of(context)).padding.bottom,
      ),
      child: Column(
        children: [
          TypesDetails(type: pokemon.types),
          const SizedBox(height: 32),
          Details(details: pokemon),
          const SizedBox(height: 32),
          EvolutionLine(
            evolution: pokemon.evolutionChainIds!,
            colorType: pokemon.primaryType!.color,
          ),
          const SizedBox(height: 32),
          Abilities(
            abilities: pokemon.abilities,
            colorType: pokemon.primaryType!.color,
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
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color:
                          Provider.of<ThemeProvider>(context).isDarkMode
                              ? Colors.white
                              : Colors.black,
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
                      color:
                          Provider.of<ThemeProvider>(context).isDarkMode
                              ? Colors.white
                              : Colors.black,
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
            Text("Height"),
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
            Text("Weight"),
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
            scrollDirection:
                Axis.horizontal, // Abilita lo scorrimento orizzontale
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < evolution.length; i++) ...[
                  // Pokemon column
                  Row(
                    children: [
                      Text(
                        "[${i + 1}]",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                      const SizedBox(width: 24),
                      for (var j = 0; j < evolution[i].length; j++) ...[
                        getPokemonImage(id: evolution[i][j], dimensione: 65),
                        const SizedBox(width: 8),
                        if (j < evolution[i].length - 1)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: Icon(
                              Icons.arrow_forward,
                              color: Colors.grey,
                            ),
                          ),
                      ],
                    ],
                  ),

                  const SizedBox(width: 8),
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
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "First Ability",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  abilities[0].name.capitalize(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),

            if (abilities.length > 1) ...{
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Special Ability",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    abilities[1].name.capitalize(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            },
          ],
        ),
      ],
    );
  }
}
