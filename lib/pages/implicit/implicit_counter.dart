import 'package:flutter/material.dart';

class SmoothCounter extends ImplicitlyAnimatedWidget {
  SmoothCounter({
    Key? key,
    required this.progress,
    Duration duration = const Duration(milliseconds: 700),
    Curve curve = Curves.easeOutCubic,
    this.style,
  }) : super(duration: duration, curve: curve, key: key);

  final double progress;
  final TextStyle? style;

  @override
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() =>
      _SmoothLoadingIndicatorState();
}

class _SmoothLoadingIndicatorState
    extends AnimatedWidgetBaseState<SmoothCounter> {
  Tween<double?>? _progress;

  @override
  Widget build(BuildContext context) {
    final value = _progress?.evaluate(animation);
    return SizedBox(
      width: 120,
      child: Text(
        (value != null ? value.toStringAsFixed(0) : '0') + '%',
        style: widget.style ??
            TextStyle(
              fontSize: 46,
              fontWeight: FontWeight.bold,
              fontFamily: 'Fira Code',
            ),
      ),
    );
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _progress = visitor(
      _progress,
      widget.progress,
      (dynamic value) => Tween<double>(begin: value as double?),
    ) as Tween<double?>?;
  }
}
