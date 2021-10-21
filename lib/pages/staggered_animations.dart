import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';

part 'helpers/staggered_animations_widgets.dart';

class StaggeredAnimations extends StatefulWidget {
  @override
  _StaggeredAnimationsState createState() => _StaggeredAnimationsState();
}

class _StaggeredAnimationsState extends State<StaggeredAnimations>
    with TickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    )
      ..forward()
      ..repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: GoogleFonts.ralewayTextTheme(Theme.of(context).textTheme),
      ),
      child: PageLayout(controller: animationController),
    );
  }
}

class PageLayout extends StatelessWidget {
  const PageLayout({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          HomePageAnimatedBuilder(
            animation: controller,
            builder: (context, child, animation) {
              return Column(
                children: [
                  Gap(16),
                  Opacity(
                    opacity: animation.headerOpacity.value,
                    child: const _Header(),
                  ),
                  SlideTransition(
                    position: animation.row1Offset,
                    child: const _Row1(),
                  ),
                  SlideTransition(
                    position: animation.row2Offset,
                    child: const _Row2(),
                  ),
                  SlideTransition(
                    position: animation.row3Offset,
                    child: const _Row3(),
                  ),
                ],
              );
            },
          ),
          Positioned(
            right: 20,
            top: 20,
            child: IconButton(
              onPressed: () {
                if (controller.isAnimating) {
                  controller.stop();
                } else {
                  controller
                    ..forward()
                    ..repeat();
                }
              },
              icon: Icon(Icons.pause_circle),
            ),
          )
        ],
      ),
    );
  }
}

class HomePageAnimatedBuilder extends StatelessWidget {
  const HomePageAnimatedBuilder({
    Key? key,
    required this.builder,
    required this.animation,
    this.child,
  }) : super(key: key);

  final MyTransitionBuilder builder;
  final Listenable animation;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return builder(
          context,
          child,
          HomePageEnterAnimation(animation as AnimationController),
        );
      },
      child: child,
    );
  }
}

typedef MyTransitionBuilder = Widget Function(
  BuildContext context,
  Widget? child,
  HomePageEnterAnimation animation,
);

class HomePageEnterAnimation {
  HomePageEnterAnimation(this.controller)
      : headerOpacity = Tween<double>(begin: 0, end: 1.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0, 0.2, curve: Curves.easeIn),
          ),
        ),
        row1Offset =
            Tween<Offset>(begin: Offset(0, 5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.1, 0.25, curve: Curves.easeOut),
          ),
        ),
        row2Offset =
            Tween<Offset>(begin: Offset(0, 5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.15, 0.30, curve: Curves.easeOut),
          ),
        ),
        row3Offset =
            Tween<Offset>(begin: Offset(0, 5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.2, 0.35, curve: Curves.easeOut),
          ),
        );

  final AnimationController controller;
  final Animation<double> headerOpacity;
  final Animation<Offset> row1Offset;
  final Animation<Offset> row2Offset;
  final Animation<Offset> row3Offset;
}
