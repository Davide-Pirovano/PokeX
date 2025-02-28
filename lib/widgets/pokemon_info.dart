import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokedex/model/pokemon.dart';
import 'package:pokedex/util/pokemon_type.dart';

class PokemonInfo extends StatelessWidget {
  const PokemonInfo({super.key, required this.pokemon});

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 40),
          TypesDetails(type: pokemon.types),
          const SizedBox(height: 24),
          Details(details: pokemon),
        ],
      ),
    );
  }
}

class TypesDetails extends StatelessWidget {
  const TypesDetails({super.key, required this.type});

  final List<Type> type;

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
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(8),
                    color:
                        getPokemonTypeFromString(e.type!.name!)?.color ??
                        Colors.white,
                  ),
                  child: Text(
                    e.type!.name!.toUpperCase(),
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: GoogleFonts.montserrat().fontFamily,
                      color: Colors.black,
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
                      details.types.first.type!.name!,
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
                      details.types.first.type!.name!,
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
