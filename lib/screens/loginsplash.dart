import 'package:flutter/material.dart';

import '../components/slidingpage.dart';
import '../helpers/theme.dart';
import 'login.dart';

class LoginSplashScreen extends StatefulWidget {
  @override
  _LoginSplashScreenState createState() => _LoginSplashScreenState();
}

class _LoginSplashScreenState extends State<LoginSplashScreen> {
  int _pageIndex = 0;
  static const Duration duration = Duration(milliseconds: 300);
  static const Curve curve = Curves.easeIn;

  ThemeData get _theme => (_pageIndex == 2) ? primaryTheme : darkTheme;

  Widget _buildFirstPage() => AnimatedTheme(
        duration: duration,
        data: _theme,
        child: AnimatedContainer(
          duration: duration,
          color: _theme.scaffoldBackgroundColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                width: 112,
                child: Image.asset(
                  'assets/icon/ic_launcher.png',
                  fit: BoxFit.contain,
                ),
              ),
              Text(
                'Welcome To Fastter',
                style: _theme.textTheme.titleLarge?.copyWith(
                  fontSize: 36,
                ),
              ),
              Text(
                'Todo App',
                style: _theme.textTheme.titleLarge?.copyWith(
                  fontSize: 36,
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildSecondPage() => AnimatedTheme(
        duration: duration,
        data: _theme,
        child: AnimatedContainer(
          duration: duration,
          color: _theme.scaffoldBackgroundColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'You can create',
                style: _theme.textTheme.titleMedium?.copyWith(
                  fontSize: 24,
                ),
              ),
              Text(
                'Tasks, Projects',
                style: _theme.textTheme.titleMedium?.copyWith(
                  fontSize: 24,
                ),
              ),
              Text(
                'Labels, Comments',
                style: _theme.textTheme.titleMedium?.copyWith(
                  fontSize: 24,
                ),
              ),
              Text(
                'And much more',
                style: _theme.textTheme.titleMedium?.copyWith(
                  fontSize: 24,
                ),
              ),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SlidingPageScreen(
          onPageChanged: (pageIndex) {
            setState(() {
              _pageIndex = pageIndex;
            });
          },
          children: [
            _buildFirstPage(),
            _buildSecondPage(),
            LoginScreen(),
          ],
        ),
      );
}
