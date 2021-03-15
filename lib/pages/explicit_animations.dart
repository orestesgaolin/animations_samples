import 'package:flutter/material.dart';

import 'explicit/explicit.dart';

class ExplicitAnimations extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.blue,
      child: GridView.count(
        crossAxisCount: 2,
        children: [
          AvatarAnimation(),
          FlutterAnimatedLogo(),
          SlackLogo(),
          DotsLoader(),
          AnimatedRadiatingIcon(),
        ],
      ),
    );
  }
}
