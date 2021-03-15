import 'package:flutter/material.dart';

class TweenPageController extends StatefulWidget {
  @override
  _TweenPageControllerState createState() => _TweenPageControllerState();
}

class _TweenPageControllerState extends State<TweenPageController> {
  double scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Stack(
        children: [
          TweenAnimationDemo(
            scale: scale,
          ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      scale = 1.0;
                    });
                  },
                  child: Text('x1.0'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      scale = 10.0;
                    });
                  },
                  child: Text('x10.0'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      scale = 30.0;
                    });
                  },
                  child: Text('x30.0'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TweenAnimationDemo extends StatelessWidget {
  const TweenAnimationDemo({Key key, this.scale}) : super(key: key);

  final double scale;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TweenAnimationBuilder(
        duration: Duration(seconds: 2),
        tween: Tween<double>(begin: 0.0, end: scale ?? 1.0),
        curve: Curves.easeInOut,
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: child,
          );
        },
        child: Text('I\'m child'),
      ),
    );
  }
}
