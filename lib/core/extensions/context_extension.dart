import 'package:flutter/material.dart';

extension MainNavigator on BuildContext {
  void navigateTo(Widget screen, {bool allowBack = false}) => allowBack
      ? Navigator.push(
          this,
          MaterialPageRoute(builder: (context) => screen),
        )
      : Navigator.pushAndRemoveUntil(
          this,
          MaterialPageRoute(builder: (context) => screen),
          (Route<dynamic> route) => false,
        );
}
