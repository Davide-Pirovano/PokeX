import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:pokex/pages/auth/auth_gate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';

import 'data/local/favourites_local_data_source.dart';
import 'data/remote/pokedex_data_source.dart';
import 'model/pokemon.dart';
import 'repo/favourite_repo.dart';
import 'theme/theme_provider.dart';
import 'util/pokemon_type.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Carica il file .env
  await dotenv.load(fileName: ".env");

  // Inizializza Supabase con le variabili dal file .env
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? 'test_url', // Leggi l'URL da .env
    anonKey:
        dotenv.env['SUPABASE_KEY'] ?? 'test_api_key', // Leggi la chiave da .env
  );
  await Hive.initFlutter();

  Hive.registerAdapter(PokemonAdapter());
  Hive.registerAdapter(TypeEntryAdapter());
  Hive.registerAdapter(TypeInfoAdapter());
  Hive.registerAdapter(PokemonSpeciesAdapter());
  Hive.registerAdapter(AbilityAdapter());
  Hive.registerAdapter(PokemonTypeAdapter());

  FavouritesLocalDataSource favourites = FavouritesLocalDataSource();
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
      home: AuthGate(),
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
