import 'package:flutter/material.dart';
import 'package:fps_widget/fps_widget.dart';
import 'package:provider/provider.dart';

class MyFpsWidget extends StatelessWidget {
  const MyFpsWidget({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FpsState>(
      create: (_) => FpsState(),
      child: FpsWrapper(child: child),
    );
  }
}

class FpsWrapper extends StatelessWidget {
  const FpsWrapper({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final value = context.watch<FpsState>().show;
    if (value) {
      return Scaffold(
        body: FPSWidget(
          show: true,
          child: child,
        ),
      );
    } else {
      return child;
    }
  }
}

class FpsState extends ChangeNotifier {
  bool show = false;

  void toggle() {
    show = !show;
    notifyListeners();
  }
}
