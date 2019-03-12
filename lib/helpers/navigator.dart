import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> mainNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldState> homeScaffoldKey = GlobalKey<ScaffoldState>();

class RouteInfo {
  RouteInfo(this.routeName, {this.arguments});

  String routeName;
  Object arguments;
}

final List<RouteInfo> history = <RouteInfo>[];
