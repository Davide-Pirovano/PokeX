import 'package:flutter/cupertino.dart';
import '../../model/nav_page.dart';

class TabsController {
  final tabController = CupertinoTabController();
  final tabKey = GlobalKey();
  final List<NavPage> navPages = [
    NavPage(
      'Home',
      'assets/icons/home.png', // Path to filled home icon
      'assets/icons/home-outline.png', // Path to outlined home icon
      GlobalKey<NavigatorState>(),
    ),
    NavPage(
      'Favourites',
      'assets/icons/heart.png', // Path to filled favourites icon
      'assets/icons/heart-outline.png', // Path to outlined favourites icon
      GlobalKey<NavigatorState>(),
    ),
    NavPage(
      'Settings',
      'assets/icons/settings.png', // Path to filled settings icon
      'assets/icons/settings-outline.png', // Path to outlined settings icon
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
      currentTab.key.currentState?.pop();
    }
  }

  void dispose() {
    tabController.dispose();
  }
}
