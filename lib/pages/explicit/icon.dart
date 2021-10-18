import 'package:flutter/material.dart';

class AnimatedRadiatingIcon extends StatefulWidget {
  @override
  _AnimatedRadiatingIconState createState() => _AnimatedRadiatingIconState();
}

class _AnimatedRadiatingIconState extends State<AnimatedRadiatingIcon>
    with TickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )
      ..forward()
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.blue,
      child: Center(
        child: AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            return Container(
              decoration: ShapeDecoration(
                color: Colors.white.withOpacity(0.5),
                shape: CircleBorder(),
              ),
              child: Padding(
                padding: EdgeInsets.all(8.0 * animationController.value),
                child: child,
              ),
            );
          },
          child: DecoratedBox(
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: CircleBorder(),
            ),
            child: IconButton(
              onPressed: () {},
              color: Colors.blue,
              icon: Icon(Icons.calendar_today, size: 24),
            ),
          ),
        ),
      ),
    );
  }
}
