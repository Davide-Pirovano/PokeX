import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../repo/favourite_repo.dart';
import '../widgets/pokemon_card.dart';

class FavouritesPage extends StatelessWidget {
  const FavouritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favourites")),
      body: Consumer<FavouriteRepo>(
        builder: (context, favouriteRepo, child) {
          return CustomScrollView(
            slivers: [
              SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) =>
                      PokemonCard(pokemon: favouriteRepo.favourites[index]),
                  childCount: favouriteRepo.favourites.length,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
