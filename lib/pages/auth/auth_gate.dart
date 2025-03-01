import 'package:flutter/material.dart';
import 'package:pokex/pages/auth/login_page.dart';
import 'package:pokex/pages/tab_page/tabs_page.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/pokedex_data_source.dart';

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
        // loading...
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final session = snapshot.hasData ? snapshot.data!.session : null;

        if (session != null) {
          return const TabsPage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
