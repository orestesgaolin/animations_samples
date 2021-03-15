import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Tweens extends StatefulWidget {
  @override
  _TweensState createState() => _TweensState();
}

class _TweensState extends State<Tweens> with TickerProviderStateMixin {
  AnimationController animationController;
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
    final widget = ListView(
      children: [
        Text(
          'Tweens and Curves',
          style: Theme.of(context).textTheme.headline3,
        ),
        const Gap(32.0),
        Stack(
          children: [
            Center(
              child: AnimatedBuilder(
                animation: animationController,
                builder: (context, child) {
                  final position = getTween(animationController);
                  return SlideTransition(
                    position: position,
                    child: child,
                  );
                },
                child: Container(
                  height: 200,
                  width: 200,
                  color: Colors.blue,
                ),
              ),
            ),
            SizedBox(
              height: 200,
              width: double.infinity,
              child: CustomPaint(
                painter: CurvePainter(Curves.linear),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Curves.linear',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ),
          ],
        ),
        Stack(
          children: [
            Center(
              child: AnimatedBuilder(
                animation: animationController,
                builder: (context, child) {
                  final position =
                      getCurvedTween(animationController, Curves.decelerate);
                  return SlideTransition(
                    position: position,
                    child: child,
                  );
                },
                child: Container(
                  height: 200,
                  width: 200,
                  color: Colors.red,
                ),
              ),
            ),
            SizedBox(
              height: 200,
              width: double.infinity,
              child: CustomPaint(
                painter: CurvePainter(Curves.decelerate),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Curves.decelerate',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ),
          ],
        ),
        Stack(
          children: [
            Center(
              child: AnimatedBuilder(
                animation: animationController,
                builder: (context, child) {
                  final position = getCurvedTween(
                    animationController,
                    Curves.elasticInOut,
                  );
                  return SlideTransition(
                    position: position,
                    child: child,
                  );
                },
                child: Container(
                  height: 200,
                  width: 200,
                  color: Colors.green,
                ),
              ),
            ),
            SizedBox(
              height: 200,
              width: double.infinity,
              child: CustomPaint(
                painter: CurvePainter(Curves.elasticInOut),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Curves.elasticInOut',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ),
          ],
        ),
        Stack(
          children: [
            Center(
              child: AnimatedBuilder(
                animation: animationController,
                builder: (context, child) {
                  final position = getCurvedTween(
                    animationController,
                    Curves.bounceOut,
                  );
                  return SlideTransition(
                    position: position,
                    child: child,
                  );
                },
                child: Container(
                  height: 200,
                  width: 200,
                  color: Colors.orange,
                ),
              ),
            ),
            SizedBox(
              height: 200,
              width: double.infinity,
              child: CustomPaint(
                painter: CurvePainter(Curves.bounceOut),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Curves.bounceOut',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ),
          ],
        ),
      ],
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
