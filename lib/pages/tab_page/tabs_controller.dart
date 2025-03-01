import 'package:flutter/cupertino.dart';
import '../../model/nav_page.dart';

class TabsController {
  final tabController = CupertinoTabController();
  final tabKey = GlobalKey();
  final List<NavPage> navPages = [
    NavPage('Home', 'assets/icons/home.png', GlobalKey<NavigatorState>()),
    NavPage(
      'Favourites',
      'assets/icons/heart.png',
      GlobalKey<NavigatorState>(),
    ),
    NavPage(
      'Settings',
      'assets/icons/settings.png',
      GlobalKey<NavigatorState>(),
    ),
  ];

  void init() {
    // Initialization logic if needed
  }

  void goToTab(int? index) {
    if (index != null) {
      tabController.index = index;
    }
  }

  void popTab({required bool didPop}) {
    if (!didPop) {
      final currentTab = navPages[tabController.index];
      final navigatorState = currentTab.key.currentState;
      if (navigatorState != null && navigatorState.canPop()) {
        // Pop solo se ci sono elementi nello stack
        navigatorState.pop();
      }
      // Opzionale: Aggiungi un comportamento fallback se lo stack è vuoto
      // else {
      //   Navigator.of(navigatorState!.context, rootNavigator: true).pop(); // Esce dall'app, se desiderato
      // }
    }
  }

  void dispose() {
    tabController.dispose();
  }
}
