import 'dart:ui';

enum PokemonType {
  normal(Color(0xFFC8C8A8)),
  fire(Color(0xFFF5B183)),
  water(Color(0xFFA4BDF5)),
  electric(Color(0xFFF9E38F)),
  grass(Color(0xFFA8D8A0)),
  ice(Color(0xFFC2EAEA)),
  fighting(Color(0xFFD07068)),
  poison(Color(0xFFC080C0)),
  ground(Color(0xFFE8D8A3)),
  flying(Color(0xFFC2B0F5)),
  psychic(Color(0xFFF8A0B3)),
  bug(Color(0xFFC0D060)),
  rock(Color(0xFFD0BF8A)),
  ghost(Color(0xFF9980B8)),
  dragon(Color(0xFF9C70F8)),
  dark(Color(0xFF988070)),
  steel(Color(0xFFD0D0E0)),
  fairy(Color(0xFFF5B7C2));

  final Color color;

  const PokemonType(this.color);
}

PokemonType? getPokemonTypeFromString(String type) {
  try {
    return PokemonType.values.firstWhere(
      (e) => e.toString().split('.').last.toUpperCase() == type.toUpperCase(),
    );
  } catch (e) {
    return null; // Restituisce null se il tipo non è trovato
  }
}
