import 'package:flutter/material.dart';
import '../widgets/app_bar_title.dart';
import 'package:provider/provider.dart';

import '../data/pokedex_data_source.dart';
import '../widgets/pokemon_card.dart';

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
        _scrollController.position.maxScrollExtent * 0.6) {
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
        title: AppBarTitle(title: "Pokédex"),
      ),
      body: Consumer<PokedexDataSource>(
        builder: (context, dataSource, child) {
          // Verifica se i dati sono stati caricati
          if (dataSource.pokedex.results.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          // Mostra la lista dei Pokemon
          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1,
                            ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => PokemonCard(
                            pokemon: dataSource.pokedex.results[index],
                          ),
                          childCount: dataSource.pokedex.results.length,
                        ),
                      ),
                      if (dataSource.isLoading)
                        SliverToBoxAdapter(
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            alignment: Alignment.center,
                            child: const CircularProgressIndicator(),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
