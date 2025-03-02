import 'dart:async';
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
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dataSource = Provider.of<PokedexDataSource>(context, listen: false);
      if (dataSource.pokedex.results.isEmpty) {
        dataSource.fetchPokedex();
      }
    });
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.75) {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 300), () {
        final dataSource = Provider.of<PokedexDataSource>(
          context,
          listen: false,
        );
        if (!dataSource.isLoading && dataSource.hasNext) {
          dataSource.fetchPokedex();
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const AppBarTitle(title: "Pokédex"),
      ),
      body: Consumer<PokedexDataSource>(
        builder: (context, dataSource, child) {
          // Stato iniziale: caricamento o errore
          if (dataSource.pokedex.results.isEmpty) {
            if (dataSource.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return const Center(
                child: Text('Nessun dato disponibile. Riprova più tardi.'),
              );
            }
          }

          // Lista caricata
          return SafeArea(
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) =>
                        PokemonCard(pokemon: dataSource.pokedex.results[index]),
                    childCount: dataSource.pokedex.results.length,
                  ),
                ),
                if (dataSource.isLoading)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
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
