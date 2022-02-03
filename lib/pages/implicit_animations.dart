import 'dart:math' as math;
import 'package:animations_sample/pages/implicit/implicit_counter.dart';
import 'package:animations_sample/pages/implicit/implicit_loader.dart';
import 'package:flutter/material.dart';

class ImplicitAnimations extends StatefulWidget {
  @override
  _ImplicitAnimationsState createState() => _ImplicitAnimationsState();
}

class _ImplicitAnimationsState extends State<ImplicitAnimations> {
  Alignment alignment = Alignment.center;

  int index = 0;
  final colors = [Colors.blue, Colors.deepPurple, Colors.green];
  final bColors = [Colors.transparent, Colors.purple, Colors.green[800]];
  final sizes = [150.0, 195.0, 300.0];
  final tSizes = [12.0, 16.0, 20.0];
  final radius = [0.0, 16.0, 90.0];
  final elevations = [0.0, 16.0, 32.0];
  final opacity = [1.0, 0.3, 0.01];

  @override
  Widget build(BuildContext context) {
    final text = 'Size: ${sizes[index]}, Radius: ${radius[index]}, '
        'Elevation: ${elevations[index]}';
    return ListView(
      children: [
        Text(text),
        Center(child: LoaderDemo()),
        OverflowBar(
          alignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  index = (index + 1) % colors.length;
                });
              },
              child: AnimatedPhysicalModel(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Text('AnimatedPhysicalModel'),
                ),
                duration: kThemeAnimationDuration,
                shape: BoxShape.rectangle,
                elevation: elevations[index],
                color: Colors.blue[100]!,
                shadowColor: colors[index],
              ),
            ),
            AnimatedContainer(
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
            AnimatedOpacity(
              opacity: opacity[index],
              duration: kThemeAnimationDuration,
              child: InkWell(
                onTap: () {
                  setState(() {
                    index = (index + 1) % colors.length;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Text('AnimatedOpacity ${opacity[index]}'),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 400,
          child: Stack(
            children: [
              AnimatedAlign(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      final random1 = (math.Random().nextDouble() - 0.5);
                      final random2 = (math.Random().nextDouble() - 0.5);
                      alignment = Alignment(random1, random2);
                    });
                  },
                  style:
                      TextButton.styleFrom(textStyle: TextStyle(fontSize: 24)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('AnimatedAlign $alignment'),
                  ),
                ),
                duration: kThemeAnimationDuration,
                alignment: alignment,
              ),
            ],
          ),
        ),
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
      child: OverflowBar(
        spacing: 16,
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
            child: Text('Progress: ${progress.toStringAsFixed(2)}'),
          ),
          SmoothCounter(progress: progress * 100),
          SizedBox(
            width: 50,
            height: 50,
            child: SmoothLoadingIndicator(
              progress: progress,
            ),
          ),
        ],
      ),
    );
  }
}
