import 'package:flutter/material.dart';
import '../auth/login_page.dart';
import '../tab_page/tabs_page.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/remote/pokedex_data_source.dart';
import '../../repo/favourite_repo.dart'; // Importa il repository

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PokedexDataSource>(context, listen: false).fetchPokedex();
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        // Loading iniziale dello StreamBuilder
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final session = snapshot.hasData ? snapshot.data!.session : null;

        if (session != null) {
          // Utente autenticato
          final favRepo = Provider.of<FavouriteRepo>(context, listen: false);
          favRepo.syncFavouriteWithSupabase();

          // Restituisci la schermata principale solo dopo la sincronizzazione
          return const TabsPage();
        } else {
          // Utente non autenticato
          return const LoginPage();
        }
      },
    );
  }
}
