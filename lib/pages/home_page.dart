import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../data/pokedex_data_source.dart';
import '../widgets/pokemon_card.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PokedexDataSource>(context, listen: false).fetchPokedex();
    });

    // Aggiungi il listener per il ScrollController
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      Provider.of<PokedexDataSource>(context, listen: false).fetchPokedex();
    }
  }

  @override
  void dispose() {
    // Rimuovi il listener e disponi dello ScrollController quando il widget viene distrutto
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Center(
          child: Text(
            "Pokedex",
            style: TextStyle(
              fontFamily: GoogleFonts.montserrat().fontFamily,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ],
        titleSpacing: 0,
        toolbarHeight: 80,
      ),
      body: Consumer<PokedexDataSource>(
        builder: (context, dataSource, child) {
          // Verifica se i dati sono stati caricati
          if (dataSource.pokedex.results == null ||
              dataSource.pokedex.results!.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          // Mostra la lista dei Pokemon
          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    controller: _scrollController,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1,
                        ),
                    itemCount: dataSource.pokedex.results!.length,
                    itemBuilder:
                        (context, index) => PokemonCard(
                          pokemon: dataSource.pokedex.results![index],
                        ),
                  ),
                ),

                // Mostra un indicatore di caricamento se stiamo caricando più Pokemon
                if (dataSource.isLoading)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
