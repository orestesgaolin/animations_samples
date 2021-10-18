import 'package:flutter/material.dart';

class SmoothLoadingIndicator extends ImplicitlyAnimatedWidget {
  SmoothLoadingIndicator({
    Key? key,
    required this.progress,
    Duration duration = const Duration(milliseconds: 100),
    Curve curve = Curves.linear,
    this.color = Colors.blue,
    this.backgroundColor = const Color(0xFFBBDEFB),
  }) : super(duration: duration, curve: curve, key: key);

  final double progress;
  final Color color;
  final Color backgroundColor;

  @override
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() =>
      _SmoothLoadingIndicatorState();
}

class _SmoothLoadingIndicatorState
    extends AnimatedWidgetBaseState<SmoothLoadingIndicator> {
  Tween<double?>? _progress;

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      backgroundColor: widget.backgroundColor,
      color: widget.color,
      value: _progress!.evaluate(animation),
    );
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _progress = visitor(
      _progress,
      (widget.progress).clamp(0.01, 1.0),
      (dynamic value) => Tween<double>(begin: value as double?),
    ) as Tween<double?>?;
  }
}
