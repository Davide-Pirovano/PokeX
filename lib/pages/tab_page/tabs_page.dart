import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokex/util/color_util.dart';
import '../../pages/favourites_page.dart';
import '../../pages/home_page.dart';
import '../../pages/settings_page.dart';
import 'package:provider/provider.dart';
import '../../theme/theme_provider.dart';
import 'tabs_controller.dart';

class TabsPage extends StatefulWidget {
  const TabsPage({super.key});

  @override
  State<TabsPage> createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  final TabsController ctrl = TabsController();

  @override
  void initState() {
    super.initState();
    ctrl.tabController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    final activeColor = isDarkMode ? Colors.white : Colors.black;

    return PopScope(
      canPop: false, // Impedisce il pop del root navigator
      onPopInvokedWithResult: (didPop, _) {
        ctrl.popTab(didPop: didPop); // Gestisce il pop della tab corrente
      },
      child: CupertinoTabScaffold(
        controller: ctrl.tabController,
        tabBar: CupertinoTabBar(
          height: 60,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          activeColor: activeColor,
          inactiveColor: Colors.grey,
          key: ctrl.tabKey,
          onTap: ctrl.goToTab,
          border: const Border(top: BorderSide(color: Colors.grey)),
          items:
              ctrl.navPages.map((p) {
                final isActive =
                    ctrl.tabController.index == ctrl.navPages.indexOf(p);
                return BottomNavigationBarItem(
                  icon: SizedBox(
                    child: Center(
                      child: Image.asset(
                        p.icon,
                        height: 24,
                        width: 24,
                        color:
                            isActive
                                ? Provider.of<ThemeProvider>(context).isDarkMode
                                    ? Colors.white
                                    : Colors.black
                                : Colors.grey,
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
        tabBuilder: (context, index) {
          return CupertinoTabView(
            navigatorKey: ctrl.navPages[index].key,
            builder: (context) {
              switch (index) {
                case 0:
                  return const HomePage();
                case 1:
                  return const FavouritesPage();
                case 2:
                  return const SettingsPage();
                default:
                  return const HomePage();
              }
            },
          );
        },
      ),
    );
  }
}
