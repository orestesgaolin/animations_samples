import 'dart:math' as math;
import 'package:animations_sample/pages/implicit/implicit_counter.dart';
import 'package:animations_sample/pages/implicit/implicit_loader.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ImplicitAnimations extends StatefulWidget {
  @override
  _ImplicitAnimationsState createState() => _ImplicitAnimationsState();
}

class _ImplicitAnimationsState extends State<ImplicitAnimations> {
  Alignment alignment = Alignment.center;

  int index = 0;
  final colors = [Colors.red, Colors.orange, Colors.green];
  final bColors = [Colors.transparent, Colors.red, Colors.green[800]];
  final sizes = [150.0, 195.0, 300.0];
  final tSizes = [12.0, 16.0, 20.0];
  final radius = [0.0, 16.0, 90.0];
  final elevations = [0.0, 16.0, 32.0];

  @override
  Widget build(BuildContext context) {
    final text = 'Size: ${sizes[index]}, Radius: ${radius[index]}, '
        'Elevation: ${elevations[index]}';
    return Stack(
      children: [
        Text(text),
        Align(
          alignment: Alignment.topCenter,
          child: LoaderDemo(),
        ),
        Align(
          alignment: Alignment(0, -0.25),
          child: AnimatedContainer(
            width: sizes[index],
            height: sizes[index],
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius[index]),
              color: colors[index],
              boxShadow: [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: radius[index],
                ),
              ],
              border: Border.all(
                color: bColors[index]!,
                width: index * 10.0,
              ),
            ),
            duration: kThemeAnimationDuration,
            curve: Curves.easeInOut,
            child: InkWell(
              onTap: () {
                setState(() {
                  index = (index + 1) % colors.length;
                });
              },
              child: Center(
                child: AnimatedDefaultTextStyle(
                  duration: kThemeAnimationDuration,
                  style: TextStyle(fontSize: tSizes[index]),
                  child: Text(
                    'AnimatedContainer',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ),
        AnimatedAlign(
          child: TextButton(
            onPressed: () {
              setState(() {
                final random1 = (math.Random().nextDouble() - 0.5) * 2;
                final random2 = (math.Random().nextDouble() - 0.5) * 2;
                alignment = Alignment(random1, random2);
              });
            },
            style: TextButton.styleFrom(textStyle: TextStyle(fontSize: 24)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('AnimatedAlign $alignment'),
            ),
          ),
          duration: kThemeAnimationDuration,
          alignment: alignment,
        ),
        Align(
          alignment: Alignment(0, 0.55),
          child: AnimatedPhysicalModel(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text('AnimatedPhysicalModel'),
            ),
            shape: BoxShape.rectangle,
            elevation: elevations[index],
            color: Colors.blue[100]!,
            shadowColor: colors[index],
            duration: kThemeAnimationDuration,
          ),
        )
      ],
    );
  }
}

class LoaderDemo extends StatefulWidget {
  const LoaderDemo({
    Key? key,
  }) : super(key: key);

  @override
  _LoaderDemoState createState() => _LoaderDemoState();
}

class _LoaderDemoState extends State<LoaderDemo> {
  double progress = 0.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    progress = progress + 0.1;
                  });
                  if (progress >= 1.0) {
                    setState(() {
                      progress = 0.0;
                    });
                  }
                },
                child: Text('Progress: ${progress.toStringAsFixed(1)}'),
              ),
              const Gap(16),
              SmoothLoadingIndicator(
                progress: progress,
              ),
            ],
          ),
          const Gap(16),
          SmoothCounter(progress: progress * 100),
        ],
      ),
    );
  }
}
