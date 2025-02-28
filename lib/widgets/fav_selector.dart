import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:provider/provider.dart';

import '../model/pokemon.dart';
import '../repo/favourite_repo.dart';
import '../util/color_util.dart';

class FavSelector extends StatelessWidget {
  const FavSelector({super.key, required this.pokemon});

  final Pokemon pokemon;

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
            icon:
                isFav
                    ? Icon(
                      Icons.favorite,
                      color: ColorUtil().favouriteRed,
                      size: 32,
                    )
                    : const Icon(
                      Icons.favorite_outline,
                      color: Colors.black,
                      size: 32,
                    ),
            splashRadius: 24,
          ),
        );
      },
    );
  }
}
