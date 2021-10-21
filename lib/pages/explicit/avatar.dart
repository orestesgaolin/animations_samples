// Copyright 2021 Dominik Roszkowski
import 'package:flutter/material.dart';

class AvatarAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final radius = 100.0;
    return Center(
      child: _AnimatedAvatarDecoration(
        child: CircleAvatar(
          backgroundImage: NetworkImage('https://picsum.photos/id/823/300'),
          backgroundColor: Colors.white,
          radius: radius,
        ),
        radius: radius,
      ),
    );
  }
}

/// Pulse decoration shown around the avatar
///
/// It uses several animation controllers to show sequential
/// radiating circles around the avatar. As they extend from
/// the avatar their opacity decreases to 0.0.
class _AnimatedAvatarDecoration extends StatefulWidget {
  const _AnimatedAvatarDecoration({
    Key? key,
    required this.child,
    required this.radius,
  }) : super(key: key);

  final Widget child;
  final double radius;

  @override
  _AnimatedAvatarDecorationState createState() =>
      _AnimatedAvatarDecorationState();
}

class _AnimatedAvatarDecorationState extends State<_AnimatedAvatarDecoration>
    with TickerProviderStateMixin {
  AnimationController? animationController1;
  AnimationController? animationController2;
  AnimationController? animationController3;

  final radiatingTween = Tween<double>(begin: 1.0, end: 0.0);

  @override
  void initState() {
    super.initState();
    animationController1 = AnimationController(
      vsync: this,
      duration: _kRadiatingAnimationDuration,
      debugLabel: 'animated_avatar_decoration1',
    )
      ..forward()
      ..repeat();
    animationController2 = AnimationController(
      vsync: this,
      duration: _kRadiatingAnimationDuration,
      debugLabel: 'animated_avatar_decoration2',
    )
      ..forward(from: 1 / 3)
      ..repeat();
    animationController3 = AnimationController(
      vsync: this,
      duration: _kRadiatingAnimationDuration,
      debugLabel: 'animated_avatar_decoration3',
    )
      ..forward(from: 2 / 3)
      ..repeat();
  }

  @override
  void dispose() {
    animationController1?.dispose();
    animationController2?.dispose();
    animationController3?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController1!,
      builder: (context, child) {
        final _padding = widget.radius * 0.75;
        final anim1 = radiatingTween.animate(animationController1!);
        final anim2 = radiatingTween.animate(animationController2!);
        final anim3 = radiatingTween.animate(animationController3!);

        return Center(
          child: Stack(
            children: [
              _RadiatingCircle(
                padding: _padding,
                anim1: anim1,
                key: const Key('animated_avatar_decoration1'),
              ),
              _RadiatingCircle(
                padding: _padding,
                anim1: anim2,
                key: const Key('animated_avatar_decoration2'),
              ),
              _RadiatingCircle(
                padding: _padding,
                anim1: anim3,
                key: const Key('animated_avatar_decoration3'),
              ),
              Padding(
                padding: EdgeInsets.all(_padding),
                child: child,
              ),
            ],
          ),
        );
      },
      child: DecoratedBox(
        decoration: const ShapeDecoration(
          shape: CircleBorder(),
          shadows: [
            BoxShadow(
              color: Color(0x8008212D),
              blurRadius: 28,
              offset: Offset(4, 4),
            ),
          ],
        ),
        child: widget.child,
      ),
    );
  }
}

const _kRadiatingAnimationDuration = Duration(milliseconds: 3500);
const _kOpacityFraction = 1 / 5;

class _RadiatingCircle extends StatelessWidget {
  const _RadiatingCircle({
    Key? key,
    required this.padding,
    required this.anim1,
  }) : super(key: key);

  final double padding;
  final Animation<double> anim1;
  final baseColor = Colors.white10;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Padding(
        padding: EdgeInsets.all(padding * anim1.value),
        child: DecoratedBox(
          decoration: ShapeDecoration(
            shape: const CircleBorder(),
            color: baseColor.withOpacity(anim1.value * _kOpacityFraction),
          ),
        ),
      ),
    );
  }
}
