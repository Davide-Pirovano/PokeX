import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../pages/favourites_page.dart';
import '../../pages/home_page.dart';
import '../../pages/settings_page.dart';
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
          activeColor: Theme.of(context).colorScheme.primary,
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
                                ? Theme.of(context).colorScheme.primary
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
                  return SettingsPage();
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
