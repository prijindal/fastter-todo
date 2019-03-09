import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> mainNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class RouteInfo {
  String routeName;
  Object arguments;
  RouteInfo(this.routeName, {this.arguments});
}

final List<RouteInfo> history = <RouteInfo>[];
