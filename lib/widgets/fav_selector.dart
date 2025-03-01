import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/pokemon.dart';
import '../repo/favourite_repo.dart';

class FavSelector extends StatelessWidget {
  const FavSelector({super.key, required this.pokemon});

  final Pokemon pokemon;

  static const String heartIcon = 'assets/icons/heart.png';
  static const String heartFullIcon = 'assets/icons/heart-full.png';

  @override
  Widget build(BuildContext context) {
    return Consumer<FavouriteRepo>(
      builder: (context, favouriteRepo, child) {
        final isFav = favouriteRepo.isFavourite(pokemon.id!);
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.1),
          ),
          child: IconButton(
            onPressed:
                () =>
                    isFav
                        ? favouriteRepo.removeFavourite(pokemon.id!)
                        : favouriteRepo.addFavourite(pokemon),
            icon: Image.asset(
              isFav ? heartFullIcon : heartIcon,
              height: 24, // Dimensione coerente con il tuo design
              width: 24,
            ),
            splashRadius: 24,
          ),
        );
      },
    );
  }
}
