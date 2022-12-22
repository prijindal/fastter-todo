import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class RouteInfo {
  RouteInfo(this.routeName, {this.arguments});

  String routeName;
  Map<String, dynamic>? arguments;
}

final List<RouteInfo> history = <RouteInfo>[];
