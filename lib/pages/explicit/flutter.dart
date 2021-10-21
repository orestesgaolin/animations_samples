import 'dart:ui' as ui show Gradient;
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'dart:typed_data';

class FlutterAnimatedLogo extends StatefulWidget {
  const FlutterAnimatedLogo({Key? key, this.size = 300}) : super(key: key);
  final double size;

  @override
  _FlutterAnimatedLogoState createState() => _FlutterAnimatedLogoState();
}

class _FlutterAnimatedLogoState extends State<FlutterAnimatedLogo>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  int _currentDuration = 4;
  // bool _showSettings = false;
  bool _showClippingPaths = false;
  bool _showOriginal = false;

  late Animation<double> beamRotation;
  late Animation<double> shadowOpacity;
  late Animation<double> middleBeamTopClip;
  late Animation<double> middleBeamTopBounce;
  late Animation<double> bottomBeamBottomClip;
  late Animation<double> bottomBeamTranslation;
  late Animation<double> topBeamClip;
  late Animation<double> topBeamBounceUp;
  late Animation<double> topBeamBounceDown;
  late Animation<double> scaleTween;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: _currentDuration),
    );
    _initializeTweens();
    _startAnimation();
  }

  void _initializeTweens() {
    //anim last until 0.6
    final animLimit = 0.6;
    final tf = 140.0; //total frames

    //frames 63-102, modified
    beamRotation = Tween<double>(begin: math.pi, end: 0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(
          63 / tf * animLimit,
          110 / tf * animLimit,
          curve: Curves.easeInOutQuad,
        ),
      ),
    );

    shadowOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController, curve: Interval(0.5, 0.8)));

    //frames 40-67/140
    middleBeamTopClip = Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
            parent: animationController,
            curve: Interval(40 / tf * animLimit, 67 / tf * animLimit)));

    //frames 80-102, modified
    middleBeamTopBounce =
        Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(
            parent: animationController,
            curve: Interval(
              80 / tf * animLimit,
              120 / tf * animLimit,
              curve: Curves.easeInOutSine,
            )));

    //frames 54-78
    bottomBeamBottomClip =
        Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(
            parent: animationController,
            curve: Interval(
              54 / tf * animLimit,
              74 / tf * animLimit,
              curve: Curves.decelerate,
            )));

    //frames 78-100
    bottomBeamTranslation =
        Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(
            parent: animationController,
            curve: Interval(
              78 / tf * animLimit,
              100 / tf * animLimit,
              curve: Curves.decelerate,
            )));

    //frames 100-140
    topBeamClip = Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(
      parent: animationController,
      curve: Interval(
        100 / tf * animLimit,
        140 / tf * animLimit,
        curve: Curves.easeOutCubic,
      ),
    ));

    //frames 130-170
    topBeamBounceUp =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: animationController,
      curve: Interval(
        100 / tf * animLimit,
        145 / tf * animLimit,
        curve: Curves.easeInOutSine,
      ),
    ));
    topBeamBounceDown =
        Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(
      parent: animationController,
      curve: Interval(
        145 / tf * animLimit,
        170 / tf * animLimit,
        curve: Curves.easeInOutSine,
      ),
    ));

    scaleTween = Tween<double>(begin: 1.03, end: 1.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(
          100 / tf * animLimit,
          170 / tf * animLimit,
          curve: Curves.easeInOut,
        )));
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (_showOriginal)
                  FlutterLogo(
                    size: widget.size,
                    style: FlutterLogoStyle.markOnly,
                  ),
                AnimatedBuilder(
                  animation: animationController,
                  builder: (context, child) {
                    //workaround for small screens
                    var scale = 1.0;
                    if (MediaQuery.of(context).size.width < 600) {
                      scale = 0.7;
                    }
                    return Transform.scale(
                      scale: scaleTween.value * scale,
                      child: CustomPaint(
                        painter: AnimatedLogoPainter(
                            beamRotation: beamRotation.value,
                            middleBeamTopClip: middleBeamTopClip.value,
                            middleBeamTopBounce: middleBeamTopBounce.value,
                            shadowOpacity: shadowOpacity.value,
                            bottomBeamBottomClip: bottomBeamBottomClip.value,
                            bottomBeamTranslation: bottomBeamTranslation.value,
                            topBeamClip: topBeamClip.value,
                            topBeamBounce:
                                topBeamBounceUp.value + topBeamBounceDown.value,
                            showClippingPaths: _showClippingPaths),
                        child: Container(
                          height: widget.size * scale,
                          width: widget.size * scale,
                          color: Colors.transparent,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // void _decreaseDuration() {
  //   setState(() {
  //     _currentDuration = (_currentDuration - 1).clamp(1, 20);
  //     animationController.duration = Duration(seconds: _currentDuration);
  //   });
  //   _startAnimation();
  // }

  // void _increaseDuration() {
  //   setState(() {
  //     _currentDuration = (_currentDuration + 1).clamp(1, 20);
  //     animationController.duration = Duration(seconds: _currentDuration);
  //   });
  //   _startAnimation();
  // }

  void _startAnimation() {
    animationController
      ..forward()
      ..repeat(reverse: true);
  }
}

// This is based on flutter_logo.dart file from Flutter
// Coordinates and selected painting approaches are taken from
// the Flutter source code
// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found at the bottom of this file
class AnimatedLogoPainter extends CustomPainter {
  final double? beamRotation;
  final double? shadowOpacity;
  final double? middleBeamTopClip;
  final double? bottomBeamBottomClip;
  final double? bottomBeamTranslation;
  final double? topBeamClip;
  final double? topBeamBounce;
  final double? middleBeamTopBounce;
  final bool? showClippingPaths;

  AnimatedLogoPainter({
    this.beamRotation,
    this.shadowOpacity,
    this.middleBeamTopClip,
    this.bottomBeamBottomClip,
    this.bottomBeamTranslation,
    this.topBeamClip,
    this.topBeamBounce,
    this.middleBeamTopBounce,
    this.showClippingPaths,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    // Coordinate space is 166x202 px
    // so we transform canvas and place it in the middle
    canvas.save();
    canvas.translate(rect.left, rect.top);
    canvas.scale(rect.width / 202.0, rect.height / 202.0);
    // Next, offset it some more so that the 166 horizontal pixels are centered
    // in that square (as opposed to being on the left side of it). This means
    // that if we draw in the rectangle from 0,0 to 166,202, we are drawing in
    // the center of the given rect.
    canvas.translate((202.0 - 166.0) / 2.0, 0.0);

    final lightPaint = Paint()..color = Colors.blue[400]!.withOpacity(0.8);
    final darkPaint = Paint()..color = Colors.blue[900]!;

    _drawTopBeam(canvas, lightPaint);
    _drawBottomDarkBeam(canvas, darkPaint);
    _drawMiddleBeam(canvas, lightPaint);

    if (beamRotation! < math.pi / 2) {
      // rotate shadow only when over beam
      drawShadows(canvas);
    }

    canvas.restore();
  }

  void drawShadows(Canvas canvas) {
    ui.Gradient triangleGradient = _getTriangleGradient();
    final Paint trianglePaint = Paint()
      ..shader = triangleGradient
      ..blendMode = BlendMode.multiply;

    final Path triangle = Path()
      ..moveTo(79.5, 170.7)
      ..lineTo(120.9, 156.4)
      ..lineTo(107.4, 142.8);
    canvas.drawPath(triangle, trianglePaint);
  }

  void _drawMiddleBeam(Canvas canvas, Paint lightPaint) {
    canvas.save();

    _flipMiddleBeamWhenInTheMiddle(canvas);
    _rotateMiddleBeamAroundAxis(canvas);

    final topCornerPerspectiveOffset =
        beamRotation! < math.pi / 2 ? middleBeamTopBounce! * 40.0 : 0.0;
    final bottomCornerPerspectiveOffset =
        beamRotation! > math.pi / 2 ? (beamRotation! - math.pi) * 20.0 : 0.0;
    final xDistance = 100.4 - 51.6;
    final xDistance2 = 156.2 - 79.5;

    final Path middleBeam = Path()
      ..moveTo(
          156.2 + topCornerPerspectiveOffset, 94.0 - topCornerPerspectiveOffset)
      ..lineTo(100.4 + bottomCornerPerspectiveOffset,
          94.0 - topCornerPerspectiveOffset)
      ..lineTo(51.6, 142.8)
      ..lineTo(79.5, 170.7);

    // we clip the middle beam before rotating
    final distance = middleBeamTopClip! * xDistance2;
    final margin = 30.0;
    final alongMargin = 50.0;
    final clippingPath = Path()
      ..moveTo(79.5 + distance + margin, 170.7 - distance + margin)
      ..lineTo(107.4 + xDistance + margin + alongMargin,
          142.8 - xDistance + margin - alongMargin)
      ..lineTo(79.5 + xDistance - margin + alongMargin,
          114.9 - xDistance - margin - alongMargin)
      ..lineTo(51.6 + distance - margin, 142.8 - distance - margin);
    canvas.clipPath(clippingPath);

    canvas.drawPath(middleBeam, lightPaint);
    canvas.restore();
    if (showClippingPaths!) {
      canvas.save();
      canvas.drawPath(clippingPath, Paint()..color = Colors.pink);
      canvas.restore();
    }
  }

  void _flipMiddleBeamWhenInTheMiddle(Canvas canvas) {
    if (beamRotation! > math.pi / 2) {
      // flip the middle beam when on the left side
      final rot2 = RotationMatrix(93.45, 128.85, 0.0, -1, 1, 0.0, math.pi);
      final mtx2 = rot2.getMatrix()!;
      canvas.transform(mtx2);
    }
  }

  void _rotateMiddleBeamAroundAxis(Canvas canvas) {
    final rot = RotationMatrix(79.5, 170.7, 0.0, 1, 1, 0.0, beamRotation!);
    final mtx = rot.getMatrix()!;
    canvas.transform(mtx);
  }

  void _drawTopBeam(Canvas canvas, Paint lightPaint) {
    canvas.save();

    final clippingOffset = topBeamClip! * (128.9);
    final clipPath = Path()
      ..moveTo(0.0, 128.9)
      ..lineTo(0.0, 0 + clippingOffset)
      ..lineTo(170.0, 0 + clippingOffset)
      ..lineTo(170.0, 128.9);

    canvas.clipPath(clipPath);

    final topOffset = topBeamBounce! * 3.0;

    final Path topBeam = Path()
      ..moveTo(37.7, 128.9)
      ..lineTo(9.8, 101.0)
      ..lineTo(100.4 + topOffset, 10.4 - topOffset)
      ..lineTo(156.2 + topOffset, 10.4 - topOffset);
    canvas.drawPath(topBeam, lightPaint);
    canvas.restore();
    if (showClippingPaths!) {
      canvas.save();
      canvas.drawPath(clipPath, Paint()..color = Colors.yellow);
      canvas.restore();
    }
  }

  void _drawBottomDarkBeam(Canvas canvas, Paint darkPaint) {
    canvas.save();

    final clippingOffset = bottomBeamBottomClip! * (191.6 - 114.9 + 45);
    final clipPath = Path()
      ..moveTo(0.0, 0)
      ..lineTo(0.0, 191.6 - clippingOffset)
      ..lineTo(160.0, 191.6 - clippingOffset)
      ..lineTo(160.0, 114.9);

    canvas.clipPath(clipPath);

    final xStartOffset = (51.6 - 9.8) * bottomBeamTranslation!;
    final yStartOffset = (142.8 - 101.0) * bottomBeamTranslation!;
    final Path bottomDarkBeam = Path()
      ..moveTo(51.6 - xStartOffset, 142.8 - yStartOffset)
      ..lineTo(100.4, 191.6)
      ..lineTo(156.2, 191.6)
      ..lineTo(79.5 - xStartOffset, 114.9 - yStartOffset);

    canvas.drawPath(bottomDarkBeam, darkPaint);
    canvas.restore();
    if (showClippingPaths!) {
      canvas.save();
      canvas.drawPath(clipPath, Paint()..color = Colors.green);
      canvas.restore();
    }
  }

  ui.Gradient _getTriangleGradient() {
    final triangleShadow = ui.Gradient.linear(
      const Offset(87.2623 + 37.9092, 28.8384 + 123.4389),
      const Offset(42.9205 + 37.9092, 35.0952 + 123.4389),
      <Color>[
        const Color(0xBFFFFFFF).withOpacity(shadowOpacity!),
        const Color(0xBFFCFCFC).withOpacity(shadowOpacity!),
        const Color(0xBFF4F4F4).withOpacity(shadowOpacity!),
        const Color(0xBFE5E5E5).withOpacity(shadowOpacity!),
        const Color(0xBFD1D1D1).withOpacity(shadowOpacity!),
        const Color(0xBFB6B6B6).withOpacity(shadowOpacity!),
        const Color(0xBF959595).withOpacity(shadowOpacity!),
        const Color(0xBF6E6E6E).withOpacity(shadowOpacity!),
        const Color(0xBF616161).withOpacity(shadowOpacity!),
      ],
      <double>[
        0.2690,
        0.4093,
        0.4972,
        0.5708,
        0.6364,
        0.6968,
        0.7533,
        0.8058,
        0.8219
      ],
    );
    return triangleShadow;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

// Copyright 2014 The Flutter Authors. All rights reserved.

// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:

//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above
//       copyright notice, this list of conditions and the following
//       disclaimer in the documentation and/or other materials provided
//       with the distribution.
//     * Neither the name of Google Inc. nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.

// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
// ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
// ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

/// Class building a rotation matrix for rotations about the line through (a, b, c)
/// parallel to [u, v, w] by the angle theta.
///
/// Original implementation in Java by Glenn Murray
/// available online on https://sites.google.com/site/glennmurray/Home/rotation-matrices-and-formulas
class RotationMatrix {
  static const TOLERANCE = 1E-9;
  Float64List? _matrix;

  late num m11;
  late num m12;
  late num m13;
  late num m14;
  late num m21;
  late num m22;
  late num m23;
  late num m24;
  late num m31;
  late num m32;
  late num m33;
  late num m34;

  /// Build a rotation matrix for rotations about the line through (a, b, c)
  /// parallel to [u, v, w] by the angle theta.
  ///
  /// [a] x-coordinate of a point on the line of rotation.
  /// [b] y-coordinate of a point on the line of rotation.
  /// [c] z-coordinate of a point on the line of rotation.
  /// [uUn] x-coordinate of the line's direction vector (unnormalized).
  /// [vUn] y-coordinate of the line's direction vector (unnormalized).
  /// [wUn] z-coordinate of the line's direction vector (unnormalized).
  /// [theta] The angle of rotation, in radians.
  RotationMatrix(num a, num b, num c, num uUn, num vUn, num wUn, num theta) {
    late num l;
    assert((l = _longEnough(uUn, vUn, wUn)) > 0,
        'RotationMatrix: direction vector too short!');

    // In this instance we normalize the direction vector.
    num u = uUn / l;
    num v = vUn / l;
    num w = wUn / l;

    // Set some intermediate values.
    num u2 = u * u;
    num v2 = v * v;
    num w2 = w * w;
    num cosT = math.cos(theta);
    num oneMinusCosT = 1 - cosT;
    num sinT = math.sin(theta);

    // Build the matrix entries element by element.
    m11 = u2 + (v2 + w2) * cosT;
    m12 = u * v * oneMinusCosT - w * sinT;
    m13 = u * w * oneMinusCosT + v * sinT;
    m14 = (a * (v2 + w2) - u * (b * v + c * w)) * oneMinusCosT +
        (b * w - c * v) * sinT;

    m21 = u * v * oneMinusCosT + w * sinT;
    m22 = v2 + (u2 + w2) * cosT;
    m23 = v * w * oneMinusCosT - u * sinT;
    m24 = (b * (u2 + w2) - v * (a * u + c * w)) * oneMinusCosT +
        (c * u - a * w) * sinT;

    m31 = u * w * oneMinusCosT - v * sinT;
    m32 = v * w * oneMinusCosT + u * sinT;
    m33 = w2 + (u2 + v2) * cosT;
    m34 = (c * (u2 + v2) - w * (a * u + b * v)) * oneMinusCosT +
        (a * v - b * u) * sinT;
  }

  /// Multiply this [RotationMatrix] times the point (x, y, z, 1),
  /// representing a point P(x, y, z) in homogeneous coordinates.  The final
  /// coordinate, 1, is assumed.
  ///
  /// [x] The point's x-coordinate.
  /// [y] The point's y-coordinate.
  /// [z] The point's z-coordinate.
  ///
  /// Returns the product, in a [Vector3], representing the
  /// rotated point.
  List<num> timesXYZ(num x, num y, num z) {
    final p = [0.0, 0.0, 0.0];

    p[0] = m11 * x + m12 * y + m13 * z + (m14 as double);
    p[1] = m21 * x + m22 * y + m23 * z + (m24 as double);
    p[2] = m31 * x + m32 * y + m33 * z + (m34 as double);

    return p;
  }

  /// Compute the rotated point from the formula given in the paper, as opposed
  /// to multiplying this matrix by the given point. Theoretically this should
  /// give the same answer as [timesXYZ]. For repeated
  /// calculations this will be slower than using [timesXYZ]
  /// because, in effect, it repeats the calculations done in the constructor.
  ///
  /// This method is static partly to emphasize that it does not
  /// mutate an instance of [RotationMatrix], even though it uses
  /// the same parameter names as the the constructor.
  ///
  /// [a] x-coordinate of a point on the line of rotation.
  /// [b] y-coordinate of a point on the line of rotation.
  /// [c] z-coordinate of a point on the line of rotation.
  /// [u] x-coordinate of the line's direction vector.  This direction
  ///          vector will be normalized.
  /// [v] y-coordinate of the line's direction vector.
  /// [w] z-coordinate of the line's direction vector.
  /// [x] The point's x-coordinate.
  /// [y] The point's y-coordinate.
  /// [z] The point's z-coordinate.
  /// [theta] The angle of rotation, in radians.
  ///
  /// Returns the product, in a [Vector3], representing the
  /// rotated point.
  static List<num>? rotPointFromFormula(num a, num b, num c, num u, num v,
      num w, num x, num y, num z, num theta) {
    // We normalize the direction vector.

    num l;
    if ((l = _longEnough(u, v, w)) < 0) {
      print("RotationMatrix direction vector too short");
      return null; // Don't bother.
    }
    // Normalize the direction vector.
    u = u / l; // Note that is not "this.u".
    v = v / l;
    w = w / l;
    // Set some intermediate values.
    num u2 = u * u;
    num v2 = v * v;
    num w2 = w * w;
    num cosT = math.cos(theta);
    num oneMinusCosT = 1 - cosT;
    num sinT = math.sin(theta);

    // Use the formula in the paper.
    final p = [0.0, 0.0, 0.0];
    p[0] = (a * (v2 + w2) - u * (b * v + c * w - u * x - v * y - w * z)) *
            oneMinusCosT +
        x * cosT +
        (-c * v + b * w - w * y + v * z) * (sinT as double);

    p[1] = (b * (u2 + w2) - v * (a * u + c * w - u * x - v * y - w * z)) *
            oneMinusCosT +
        y * cosT +
        (c * u - a * w + w * x - u * z) * sinT;

    p[2] = (c * (u2 + v2) - w * (a * u + b * v - u * x - v * y - w * z)) *
            oneMinusCosT +
        z * cosT +
        (-b * u + a * v - v * x + u * y) * sinT;

    return p;
  }

  /// Check whether a vector's length is less than [TOLERANCE].
  ///
  /// [u] The vector's x-coordinate.
  /// [v] The vector's y-coordinate.
  /// [w] The vector's z-coordinate.
  ///
  /// Returns length = math.sqrt(u^2 + v^2 + w^2) if it is greater than
  /// [TOLERANCE], or -1 if not.
  static num _longEnough(num u, num v, num w) {
    num l = math.sqrt(u * u + v * v + w * w);
    if (l > TOLERANCE) {
      return l;
    } else {
      return -1;
    }
  }

  /// Get the resulting matrix.
  ///
  /// Returns The matrix as [Matrix4].
  Float64List? getMatrix() {
    if (_matrix == null) {
      _matrix = Float64List.fromList([
        m11 as double,
        m21 as double,
        m31 as double,
        0,
        m12 as double,
        m22 as double,
        m32 as double,
        0,
        m13 as double,
        m23 as double,
        m33 as double,
        0,
        m14 as double,
        m24 as double,
        m34 as double,
        1
      ]);
      // vector math is not supported online
      // matrix = Matrix4.columns(
      //   Vector4(m11, m21, m31, 0),
      //   Vector4(m12, m22, m32, 0),
      //   Vector4(m13, m23, m33, 0),
      //   Vector4(m14, m24, m34, 1),
      // );
    }
    return _matrix;
  }
}
