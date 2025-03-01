import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:pokedex/pages/tab_page/tabs_page.dart';
import 'package:provider/provider.dart';

import 'data/favourites_data_source.dart';
import 'data/pokedex_data_source.dart';
import 'model/pokemon.dart';
import 'repo/favourite_repo.dart';
import 'theme/theme_provider.dart';
import 'util/pokemon_type.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(PokemonAdapter());
  Hive.registerAdapter(TypeEntryAdapter());
  Hive.registerAdapter(TypeInfoAdapter());
  Hive.registerAdapter(PokemonSpeciesAdapter());
  Hive.registerAdapter(AbilityAdapter());
  Hive.registerAdapter(PokemonTypeAdapter());

  FavouritesDataSource favourites = FavouritesDataSource();
  await favourites.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<PokedexDataSource>(
          create: (_) => PokedexDataSource(),
        ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider<FavouriteRepo>(create: (_) => FavouriteRepo()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TabsPage(),
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
