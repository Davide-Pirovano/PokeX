import 'package:flutter/material.dart';
import 'package:pokedex/widgets/app_bar_title.dart';
import 'package:provider/provider.dart';

import '../theme/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: AppBarTitle(title: "Settings")),
      body: Center(
        child: Expanded(
          child: Switch(
            value: Provider.of<ThemeProvider>(context).isDarkMode,
            onChanged:
                (value) =>
                    Provider.of<ThemeProvider>(
                      context,
                      listen: false,
                    ).toggleTheme(),
          ),
        ),
      ),
    );
  }
}
