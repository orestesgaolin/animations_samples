// Copyright (c) 2021 Dominik Roszkowski on the MIT license
import 'dart:async';

import 'package:flutter/material.dart';

const _numberOfElements = 5;
const _duration = Duration(milliseconds: 350);

class DotsLoader extends StatefulWidget {
  const DotsLoader({
    Key? key,
    this.size = 20.0,
  })  : assert(size > 0),
        super(key: key);

  /// Size of the largest dot
  final double size;

  @override
  _DotsLoaderState createState() => _DotsLoaderState();
}

class _DotsLoaderState extends State<DotsLoader> {
  Timer? timer;
  int index = 0;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(
      _duration,
      _incrementIndex,
    );
  }

  void _incrementIndex(timer) {
    setState(() {
      index = (index + 1) % (_numberOfElements + 1);
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final i in List.generate(_numberOfElements, (i) => i))
          _Dot(
            size: widget.size,
            currentIndex: index,
            elementIndex: i,
          )
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({
    Key? key,
    this.size,
    this.currentIndex,
    this.elementIndex,
  }) : super(key: key);

  final double? size;
  final int? currentIndex;
  final int? elementIndex;

  /// Return default size for the main element (index == elementIndex)
  ///
  /// Return 3/4 of the default size for the 2 neighbouring elements
  ///
  /// Return 1/2 of the default size for the other elements
  double getFraction() {
    if (currentIndex == elementIndex) {
      return 1.0;
    }
    final absoluteIndex = (currentIndex! - elementIndex!).abs();
    final isNeighbourToMainPoint = absoluteIndex == 1;
    if (isNeighbourToMainPoint) {
      return 0.75;
    }
    return 0.5;
  }

  @override
  Widget build(BuildContext context) {
    final fraction = getFraction();
    return SizedBox(
      height: size! + 4,
      width: size! + 4,
      child: Center(
        child: AnimatedContainer(
          duration: _duration,
          decoration: ShapeDecoration(
            color: Colors.white.withOpacity(fraction),
            shape: const CircleBorder(),
          ),
          height: fraction * size!,
          width: fraction * size!,
        ),
      ),
    );
  }
}
