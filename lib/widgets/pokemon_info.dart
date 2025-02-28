import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokedex/model/pokemon.dart';
import 'package:pokedex/theme/theme_provider.dart';
import 'package:pokedex/util/get_pokemon_image.dart';
import 'package:pokedex/util/pokemon_type.dart';
import 'package:provider/provider.dart';

import '../util/color_util.dart';

class PokemonInfo extends StatelessWidget {
  const PokemonInfo({super.key, required this.pokemon});

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 40),
      children: [
        TypesDetails(type: pokemon.types),
        const SizedBox(height: 24),
        Details(details: pokemon),
        EvolutionLine(
          evolution: pokemon.evolutionChainIds!,
          colorType: pokemon.primaryType!.color,
        ),
      ],
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
                      fontFamily: GoogleFonts.montserrat().fontFamily,
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
              "${details.height}'",
              style: TextStyle(
                fontFamily: GoogleFonts.montserrat().fontFamily,
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
              "${details.weight} lbs",
              style: TextStyle(
                fontFamily: GoogleFonts.montserrat().fontFamily,
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

  final List<int> evolution;
  final Color colorType;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        Text(
          "Evolution Chain",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: colorType,
            fontFamily: GoogleFonts.montserrat().fontFamily,
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: SingleChildScrollView(
            scrollDirection:
                Axis.horizontal, // Abilita lo scorrimento orizzontale
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < evolution.length; i++) ...[
                  // Pokemon column
                  Column(
                    children: [
                      getPokemonImage(id: evolution[i], dimensione: 60),
                      Text(
                        evolution[i] < 100
                            ? "#0${evolution[i].toString()}"
                            : "#${evolution[i]}",
                        style: TextStyle(
                          fontSize: 15,
                          color: ColorUtil().lightGrey,
                          fontFamily: GoogleFonts.montserrat().fontFamily,
                        ),
                      ),
                    ],
                  ),
                  // Add arrow between Pokemon, but not after the last one
                  if (i < evolution.length - 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(Icons.arrow_forward, color: Colors.grey),
                    ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
