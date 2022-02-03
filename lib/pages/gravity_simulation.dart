import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class GravitySimulationWidget extends StatefulWidget {
  _GravitySimulationWidget createState() => _GravitySimulationWidget();
}

class _GravitySimulationWidget extends State<GravitySimulationWidget>
    with TickerProviderStateMixin {
  late BallGame game;
  @override
  void initState() {
    super.initState();
    game = BallGame(
      this,
      bounceFactor: 0.7,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 16.0,
        top: 64.0,
      ),
      child: AnimatedBuilder(
        animation: game,
        builder: (context, child) {
          return CustomPaint(
            painter: BallPainter(game.yPosition),
            child: SizedBox.expand(
              child: Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () => game.start(),
                  child: Text('Drop The Ball'),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    game.dispose();
    super.dispose();
  }
}

const acc = 9.81;
const scaleFactor = 10;

class BallGame extends ChangeNotifier {
  BallGame(
    this.vsync, {
    this.bounceFactor = 0.7,
  });

  AnimationController? controller;
  late GravitySimulation simulation;

  double get yPosition => controller?.value ?? _position;
  double _position = 0.0;
  double _velocity = 0.0;
  final TickerProvider vsync;
  final double bounceFactor;

  void onTick() {
    final currentVelocity = simulation.dx(controller!.velocity);
    _position = controller!.value;
    if (controller!.isCompleted) {
      simulation = GravitySimulation(
        acc,
        9.999, // must be different than the target value
        10,
        -_velocity * bounceFactor / scaleFactor,
      );
      stop();
      if (_velocity.abs() > 1) {
        bounce();
      }
    }
    _velocity = currentVelocity;
    notifyListeners();
  }

  void bounce() {
    controller = AnimationController(
      vsync: vsync,
      upperBound: 1500,
    );
    controller!.addListener(onTick);
    controller!.animateWith(simulation);
  }

  void start() {
    controller = AnimationController(
      vsync: vsync,
      upperBound: 1500,
    );
    simulation = GravitySimulation(
      acc,
      0,
      10,
      0,
    );
    bounce();
  }

  void stop() {
    controller?.dispose();
    controller = null;
  }

  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
  }
}

class BallPainter extends CustomPainter {
  BallPainter(this.yPosition);

  final double yPosition;

  @override
  void paint(Canvas canvas, Size size) {
    final verticalUnit = size.height / scaleFactor;

    drawTicks(size, verticalUnit, canvas);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(
          size.center(Offset.zero).dx,
          yPosition * verticalUnit - 25,
        ),
        width: 50,
        height: 50,
      ),
      Paint(),
    );
  }

  void drawTicks(Size size, double verticalUnit, Canvas canvas) {
    for (final i in [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]) {
      final yPos = size.height - i * verticalUnit;
      canvas.drawLine(
        Offset(0, yPos),
        Offset(20, yPos),
        Paint()..color = Colors.black,
      );
      final TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: i.toString(),
          style: TextStyle(
            color: Colors.black,
            fontSize: 12,
          ),
        ),
        textAlign: TextAlign.end,
        textDirection: TextDirection.ltr,
      )..layout(minWidth: 20);
      textPainter.paint(canvas, Offset(0, yPos - 16));
    }
    canvas.drawLine(
      Offset(0, size.height),
      Offset(size.width, size.height),
      Paint()..color = Colors.black,
    );
  }

  @override
  bool shouldRepaint(covariant BallPainter oldDelegate) {
    return yPosition != oldDelegate.yPosition;
  }
}
