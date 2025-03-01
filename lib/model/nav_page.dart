import 'package:flutter/cupertino.dart';

class NavPage {
  final String name;
  final String icon; // Path to filled icon
  final GlobalKey<NavigatorState> key;

  NavPage(this.name, this.icon, this.key);
}
