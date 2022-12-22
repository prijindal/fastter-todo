import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../helpers/theme.dart';

class SlidingPageScreen extends StatefulWidget {
  const SlidingPageScreen({
    required this.children,
    required this.onPageChanged,
  });
  final List<Widget> children;
  final ValueChanged<int> onPageChanged;

  @override
  _SlidingPageScreenState createState() => _SlidingPageScreenState();
}

class _SlidingPageScreenState extends State<SlidingPageScreen> {
  int _pageIndex = 0;
  final PageController _pageController = PageController();
  static const Duration duration = Duration(milliseconds: 300);
  static const Curve curve = Curves.easeIn;

  int get _length => widget.children.length;
  ThemeData get _theme =>
      (_pageIndex == _length - 1) ? primaryTheme : darkTheme;
  bool get _shouldDisplayIcons => MediaQuery.of(context).size.width > 600;

  Widget _buildPageDot(int pageIndex) => GestureDetector(
        onTap: () {
          _pageController.animateToPage(
            pageIndex,
            duration: duration,
            curve: curve,
          );
        },
        child: AnimatedContainer(
          duration: duration,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 16,
          width: 16,
          decoration: BoxDecoration(
            border: Border.all(color: _theme.primaryColor),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            color: _pageIndex == pageIndex
                ? _theme.primaryColor
                : Colors.transparent,
          ),
        ),
      );

  Widget _buildSlidingIcon({
    required Icon icon,
    required int nextPage,
    required bool disabled,
    double? left,
    double? right,
  }) =>
      Positioned(
        left: left,
        right: right,
        top: MediaQuery.of(context).size.height * 0.5,
        child: Container(
          child: IconButton(
            iconSize: 32,
            icon: icon,
            color: _theme.primaryColor,
            onPressed: disabled == true
                ? null
                : () {
                    _pageController.animateToPage(
                      nextPage,
                      duration: duration,
                      curve: curve,
                    );
                  },
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (pageIndex) {
              setState(() {
                _pageIndex = pageIndex;
              });
              if (widget.onPageChanged != null) {
                widget.onPageChanged(pageIndex);
              }
            },
            scrollDirection: Axis.horizontal,
            children: widget.children,
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.1,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List<int>.generate(_length, (index) => index)
                    .map(_buildPageDot)
                    .toList(),
              ),
            ),
          ),
          if (_shouldDisplayIcons)
            _buildSlidingIcon(
              left: math.min(MediaQuery.of(context).size.width * 0.1, 20),
              icon: const Icon(Icons.arrow_left),
              nextPage: _pageIndex - 1,
              disabled: _pageIndex == 0,
            ),
          if (_shouldDisplayIcons)
            _buildSlidingIcon(
              right: math.min(MediaQuery.of(context).size.width * 0.1, 20),
              icon: const Icon(Icons.arrow_right),
              nextPage: _pageIndex + 1,
              disabled: _pageIndex == _length - 1,
            ),
          if (_pageIndex != _length - 1)
            Positioned(
              bottom: 20,
              right: 20,
              child: AnimatedTheme(
                data: _theme,
                child: TextButton(
                  child: const Text('Skip'),
                  onPressed: () {
                    _pageController.animateToPage(
                      _length - 1,
                      duration: duration,
                      curve: curve,
                    );
                  },
                ),
              ),
            ),
        ],
      );
}
