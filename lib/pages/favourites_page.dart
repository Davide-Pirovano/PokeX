import 'package:flutter/material.dart';
import '../widgets/app_bar_title.dart';
import 'package:provider/provider.dart';

import '../repo/favourite_repo.dart';
import '../widgets/pokemon_card.dart';

class FavouritesPage extends StatelessWidget {
  const FavouritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: AppBarTitle(title: "Favourites")),
      body: Consumer<FavouriteRepo>(
        builder: (context, favouriteRepo, child) {
          if (favouriteRepo.favourites.isEmpty) {
            return const Center(child: Text("No favourites"));
          }
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
