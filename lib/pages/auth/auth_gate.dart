import 'package:flutter/material.dart';
import 'package:pokex/pages/auth/login_page.dart';
import 'package:pokex/pages/tab_page/tabs_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

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
