import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Tweens extends StatefulWidget {
  @override
  _TweensState createState() => _TweensState();
}

class _TweensState extends State<Tweens> with TickerProviderStateMixin {
  AnimationController? animationController;

  final curves = <String, Curve>{
    'Curves.linear': Curves.linear,
    'Curves.bounceIn': Curves.bounceIn,
    'Curves.decelerate': Curves.decelerate,
    'Curves.ease': Curves.ease,
    'Curves.easeInOut': Curves.easeInOut,
    'Curves.easeOutBack': Curves.easeOutBack,
    'Curves.easeOutExpo': Curves.easeOutExpo,
    'Curves.easeOutSine': Curves.easeOutSine,
    'Curves.easeInOutExpo': Curves.easeInOutExpo,
    'Curves.easeInOutCubicEmphasized': Curves.easeInOutCubicEmphasized,
    'Curves.elasticIn': Curves.elasticIn,
    'Curves.fastLinearToSlowEaseIn': Curves.fastLinearToSlowEaseIn,
    'Curves.slowMiddle': Curves.slowMiddle,
  };

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    )
      ..forward()
      ..repeat();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  Animation<Offset> getTween(AnimationController _controller) {
    return Tween<Offset>(
      begin: const Offset(-2.0, 0.0),
      end: const Offset(2.0, 0.0),
    ).animate(_controller);
  }

  Animation<Offset> getCurvedTween(
      AnimationController _controller, Curve curve) {
    return Tween<Offset>(
      begin: const Offset(-2.0, 0.0),
      end: const Offset(2.0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: curve,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final widget = ListView.separated(
      itemCount: curves.entries.length,
      separatorBuilder: (_, __) => const Gap(16),
      itemBuilder: (context, index) {
        final curve = curves.entries.elementAt(index);
        return Stack(
          children: [
            Center(
              child: AnimatedBuilder(
                animation: animationController!,
                builder: (context, child) {
                  final position =
                      getCurvedTween(animationController!, curve.value);
                  return SlideTransition(
                    position: position,
                    child: child,
                  );
                },
                child: Container(
                  height: 200,
                  width: 200,
                  color: Color.fromARGB(
                    255,
                    160 + 20 * (index % 3),
                    180 + 30 * (index % 2),
                    170 + 20 * (index % 5),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 200,
              width: double.infinity,
              child: CustomPaint(
                painter: CurvePainter(curve.value),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${curve.key}',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ),
          ],
        );
      },
    );

    return ClipRect(
      child: widget,
    );
  }
}

class CurvePainter extends CustomPainter {
  CurvePainter(this.curve);

  final Curve curve;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    for (var i = 0; i < size.width; i++) {
      path.lineTo(i.toDouble(), curve.transform(i / size.width) * size.height);
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.black45
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
