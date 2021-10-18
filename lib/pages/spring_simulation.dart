import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class PhysicsAnimation extends StatefulWidget {
  _PhysicsAnimation createState() => _PhysicsAnimation();
}

class _PhysicsAnimation extends State<PhysicsAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  late SpringSimulation simulation;

  @override
  void initState() {
    super.initState();

    simulation = SpringSimulation(
      SpringDescription(
        mass: 2,
        stiffness: 100,
        damping: 1,
      ),
      0.0,
      600.0,
      10,
    );

    controller = AnimationController(
      vsync: this,
      upperBound: 1500,
    );

    controller.animateWith(simulation);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Stack(
          children: [
            Positioned(
              top: controller.value,
              height: 100,
              width: 1000,
              child: Container(
                color: Colors.redAccent,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
