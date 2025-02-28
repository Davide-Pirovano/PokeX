import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokedex/model/pokemon.dart';
import 'package:pokedex/util/color_util.dart';
import 'package:pokedex/util/utils.dart';
import '../pages/pokemon_details_page.dart';
import '../util/get_pokemon_image.dart';

class PokemonCard extends StatelessWidget {
  const PokemonCard({super.key, required this.pokemon});

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PokemonDetailsPage(pokemon: pokemon),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: pokemon.primaryType?.color ?? Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 8,
                left: 8,
                child: Text(
                  pokemon.id! < 100
                      ? "#0${pokemon.id.toString()}"
                      : "#${pokemon.id}",
                  style: TextStyle(
                    fontSize: 25,
                    color: ColorUtil().lightGrey,
                    fontFamily: GoogleFonts.montserrat().fontFamily,
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    getPokemonImage(id: pokemon.id!, dimensione: 100),
                    Text(
                      pokemon.name.capitalize(),
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: GoogleFonts.montserrat().fontFamily,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
