import 'package:flutter/material.dart';

import '../model/pokemon.dart';
import 'pokemon_info.dart';

class PokemonDetailsBanner extends StatelessWidget {
  const PokemonDetailsBanner({super.key, required this.pokemon});

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: InwardCurveClipper(),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: PokemonInfo(pokemon: pokemon),
      ),
    );
  }
}

class InwardCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // Inizio dall'angolo in alto a sinistra
    path.moveTo(0, 0);

    // Creazione della curva concava verso l'interno
    path.quadraticBezierTo(
      size.width / 2,
      40, // Punto di controllo (spinge la curva in giù)
      size.width,
      0, // Punto finale in alto a destra
    );

    // Chiude il rettangolo sotto la curva
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
