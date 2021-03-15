import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:funvas/funvas.dart';

class FunvasDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: AspectRatio(
            aspectRatio: 1,
            child: FunvasContainer(
              funvas: OrbsFunvas(),
            ),
          ),
        ),
        Text('https://github.com/creativecreatorormaybenot/funvas'),
      ],
    );
  }
}

class OrbsFunvas extends Funvas {
  @override
  void u(double t) {
    c.scale(x.width / 1920, x.height / 1080);

    final v = t + 400;
    for (var q = 255; q > 0; q--) {
      final paint = Paint()..color = R(q, q, q);
      c.drawCircle(
          Offset(
            1920 / 2 + C(v - q) * (v + q),
            540 + S(v - q) * (v - q),
          ),
          40,
          paint);
    }
  }
}
