import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new DecoratedBox(
      decoration: new BoxDecoration(
        color: Colors.white,
        image: new DecorationImage(
          image: new AssetImage('images/logo.png'),
        ),
      ),
    );
  }
}