import 'dart:math' as math;
import 'package:flutter/material.dart';

class SlackLogo extends StatefulWidget {
  SlackLogo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _SlackLogoState createState() => _SlackLogoState();
}

class _SlackLogoState extends State<SlackLogo> with TickerProviderStateMixin {
  AnimationController? animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
      lowerBound: 0.0,
      upperBound: 1.0,
    )
      ..forward()
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.shortestSide / 2;
    return ClipRect(
      child: Scaffold(
        body: Center(
          child: Container(
            height: width,
            width: width,
            child: AnimatedBuilder(
              animation: animationController!,
              builder: (context, anim) {
                final scale = Tween<double>(begin: 1.0, end: 0.5).animate(
                  CurvedAnimation(
                    parent: animationController!,
                    curve: Interval(
                      0.3,
                      0.8,
                      curve: Curves.easeOut,
                    ),
                  ),
                );
                final oneToZero = Tween<double>(begin: 1.0, end: 0.0).animate(
                  CurvedAnimation(
                    parent: animationController!,
                    curve: Interval(
                      0.1,
                      0.6,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
                );
                final oneToZeroTwo =
                    Tween<double>(begin: 1.0, end: 0.19).animate(
                  CurvedAnimation(
                    parent: animationController!,
                    curve: Interval(
                      0.1,
                      0.7,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
                );

                final zeroToOne = Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                    parent: animationController!,
                    curve: Interval(
                      0.1,
                      0.7,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
                );

                final rotation =
                    Tween<double>(begin: 0.0, end: math.pi).animate(
                  CurvedAnimation(
                    parent: animationController!,
                    curve: Interval(
                      0.1,
                      0.7,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
                );

                return LogoStack(
                  width,
                  scale.value,
                  oneToZero.value,
                  zeroToOne.value,
                  oneToZeroTwo.value,
                  rotation.value,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class LogoStack extends StatelessWidget {
  const LogoStack(
    this.size,
    this.scale,
    this.oneToZero,
    this.zeroToOne,
    this.oneToZeroTwo,
    this.rotation, {
    Key? key,
  }) : super(key: key);

  final double size;
  final double scale;
  final double oneToZero;
  final double zeroToOne;
  final double oneToZeroTwo;
  final double rotation;

  @override
  Widget build(BuildContext context) {
    final width = 0.2 * size;
    final elementSpacing = 0.025 * size;
    // green blobs as reference
    final smallXaxis =
        (width / 2 + elementSpacing + width + 0.05 * size) * oneToZero;
    final smallYaxis = (-width / 2 - elementSpacing) * oneToZero;

    final largeXaxis = (width / 2 + elementSpacing) * oneToZero;
    final largeYaxis = -0.25 * size * oneToZero;

    // final clipSize = size / 2 * oneToZeroTwo;
    final yellowRadius = zeroToOne * width / 2;

    return Transform.scale(
      scale: scale,
      child: Transform.rotate(
        angle: rotation,
        child: Stack(
          children: [
            Center(
              child: Transform.translate(
                offset: Offset(
                  largeXaxis,
                  largeYaxis,
                ),
                child: LargeBlob(
                  width: width,
                  color: SColors.green,
                  scale: zeroToOne,
                ),
              ),
            ),
            Center(
              child: Transform.translate(
                offset: Offset(
                  smallXaxis,
                  smallYaxis,
                ),
                child: SmallBlob(
                  width: width,
                  color: SColors.green,
                  turns: 0,
                  radius: yellowRadius,
                ),
              ),
            ),
            Center(
              child: Transform.translate(
                offset: Offset(
                  largeYaxis,
                  -largeXaxis,
                ),
                child: RotatedBox(
                  quarterTurns: 1,
                  child: LargeBlob(
                    width: width,
                    color: SColors.blue,
                    scale: zeroToOne,
                  ),
                ),
              ),
            ),
            Center(
              child: Transform.translate(
                offset: Offset(
                  smallYaxis,
                  -smallXaxis,
                ),
                child: SmallBlob(
                  width: width,
                  color: SColors.blue,
                  turns: 3,
                  radius: yellowRadius,
                ),
              ),
            ),
            Center(
              child: Transform.translate(
                offset: Offset(
                  -largeXaxis,
                  -largeYaxis,
                ),
                child: LargeBlob(
                  width: width,
                  color: SColors.red,
                  scale: zeroToOne,
                ),
              ),
            ),
            Center(
              child: Transform.translate(
                offset: Offset(
                  -smallXaxis,
                  -smallYaxis,
                ),
                child: SmallBlob(
                  width: width,
                  color: SColors.red,
                  turns: 2,
                  radius: yellowRadius,
                ),
              ),
            ),
            Center(
              child: Transform.translate(
                offset: Offset(
                  -largeYaxis,
                  largeXaxis,
                ),
                child: RotatedBox(
                  quarterTurns: 1,
                  child: LargeBlob(
                    width: width,
                    color: SColors.yellow,
                    scale: zeroToOne,
                  ),
                ),
              ),
            ),
            Center(
              child: Transform.translate(
                offset: Offset(
                  -smallYaxis,
                  smallXaxis,
                ),
                child: SmallBlob(
                  width: width,
                  color: SColors.yellow,
                  turns: 1,
                  radius: yellowRadius,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SmallBlob extends StatelessWidget {
  const SmallBlob({
    Key? key,
    required this.width,
    required this.color,
    required this.turns,
    required this.radius,
  }) : super(key: key);

  final double width;
  final Color color;
  final int turns;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: turns,
      child: Container(
        width: width,
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(width / 2),
                topRight: Radius.circular(width / 2),
                bottomRight: Radius.circular(width / 2),
                bottomLeft: Radius.circular(radius),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LargeBlob extends StatelessWidget {
  const LargeBlob({
    Key? key,
    required this.width,
    required this.color,
    required this.scale,
  }) : super(key: key);

  final double width;
  final double scale;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: width / (0.45 + scale * 0.55),
      decoration: ShapeDecoration(
        color: color,
        shape: StadiumBorder(),
      ),
    );
  }
}

class SColors {
  static const Color red = Color(0xFFE01E5A);
  static const Color blue = Color(0xFF36C5F0);
  static const Color yellow = Color(0xFFECB22E);
  static const Color green = Color(0xFF2EB67D);
}

class DecreasingCircleClipper extends CustomClipper<Path> {
  final double radius;

  DecreasingCircleClipper(this.radius);
  @override
  Path getClip(Size size) {
    final path = Path();
    final oval = Rect.fromCircle(
      center: Offset(
        size.width / 2,
        size.height / 2,
      ),
      radius: radius,
    );
    path.addOval(oval);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(DecreasingCircleClipper oldClipper) => true;
}
