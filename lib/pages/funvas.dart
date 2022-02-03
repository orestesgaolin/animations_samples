import 'package:flutter/material.dart';
import 'package:funvas/funvas.dart';
import 'package:url_launcher/url_launcher.dart';

class FunvasDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final funvas = 'https://github.com/creativecreatorormaybenot/funvas';
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
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: InkWell(
            onTap: () async {
              if (await canLaunch(funvas)) {
                launch(funvas);
              }
            },
            child: Text(funvas),
          ),
        ),
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
