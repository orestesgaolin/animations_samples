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
          LogoWrapper(),
          SlackLogo(),
          DotsLoader(),
          AnimatedRadiatingIcon(),
        ],
      ),
    );
  }
}

class LogoWrapper extends StatelessWidget {
  const LogoWrapper({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, size) {
      return ClipRect(
        child: ColoredBox(
          color: Colors.white,
          child: FlutterAnimatedLogo(size: size.biggest.width),
        ),
      );
    });
  }
}
