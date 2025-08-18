import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NeuralLogoDecoration extends Decoration {
  const NeuralLogoDecoration({
    this.color = const Color(0xFF3651F5),
    this.margin = EdgeInsets.zero,
  }) : _opacity = 1.0;

  const NeuralLogoDecoration._(this.color, this.margin, this._opacity);

  final Color color;

  final EdgeInsets margin;

  final double _opacity;

  @override
  bool debugAssertIsValid() {
    assert(_opacity >= 0.0 && _opacity <= 1.0);
    return true;
  }

  @override
  bool get isComplex => false;

  static NeuralLogoDecoration? lerp(
    NeuralLogoDecoration? a,
    NeuralLogoDecoration? b,
    double t,
  ) {
    assert(a == null || a.debugAssertIsValid());
    assert(b == null || b.debugAssertIsValid());
    if (identical(a, b)) {
      return a;
    }
    if (a == null) {
      return NeuralLogoDecoration._(
        b!.color,
        b.margin * t,
        b._opacity * clampDouble(t, 0.0, 1.0),
      );
    }
    if (b == null) {
      return NeuralLogoDecoration._(
        a.color,
        a.margin * t,
        a._opacity * clampDouble(1.0 - t, 0.0, 1.0),
      );
    }
    if (t == 0.0) {
      return a;
    }
    if (t == 1.0) {
      return b;
    }
    return NeuralLogoDecoration._(
      Color.lerp(a.color, b.color, t)!,
      EdgeInsets.lerp(a.margin, b.margin, t)!,
      clampDouble(a._opacity + (b._opacity - a._opacity) * t, 0.0, 1.0),
    );
  }

  @override
  NeuralLogoDecoration? lerpFrom(Decoration? a, double t) {
    assert(debugAssertIsValid());
    if (a is NeuralLogoDecoration?) {
      assert(a?.debugAssertIsValid() ?? true);
      return NeuralLogoDecoration.lerp(a, this, t);
    }
    return super.lerpFrom(a, t) as NeuralLogoDecoration?;
  }

  @override
  NeuralLogoDecoration? lerpTo(Decoration? b, double t) {
    assert(debugAssertIsValid());
    if (b is NeuralLogoDecoration?) {
      assert(b?.debugAssertIsValid() ?? true);
      return NeuralLogoDecoration.lerp(this, b, t);
    }
    return super.lerpTo(b, t) as NeuralLogoDecoration?;
  }

  @override
  bool hitTest(Size size, Offset position, {TextDirection? textDirection}) =>
      true;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    assert(debugAssertIsValid());
    return _NeuralLogoPainter(this);
  }

  @override
  Path getClipPath(Rect rect, TextDirection textDirection) {
    return Path()..addRect(rect);
  }

  @override
  bool operator ==(Object other) {
    assert(debugAssertIsValid());
    if (identical(this, other)) {
      return true;
    }
    return other is NeuralLogoDecoration &&
        other.color == color &&
        other._opacity == _opacity &&
        other.margin == margin;
  }

  @override
  int get hashCode {
    assert(debugAssertIsValid());
    return Object.hash(color, _opacity, margin);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('color', color));
    properties.add(DiagnosticsProperty<EdgeInsets>('margin', margin));
    if (_opacity != 1.0) {
      properties.add(DoubleProperty('opacity', _opacity));
    }
  }
}

/// An object that paints a [NeuralLogoDecoration] into a canvas.
class _NeuralLogoPainter extends BoxPainter {
  _NeuralLogoPainter(this._config)
    : assert(_config.debugAssertIsValid()),
      super(null);

  final NeuralLogoDecoration _config;

  void _paintLogo(Canvas canvas, Rect rect) {
    canvas.save();
    canvas.translate(rect.left, rect.top);
    canvas.scale(rect.width / 100.0, rect.height / 17.0);

    final Paint paint =
        Paint()
          ..color = _config.color
          ..style = PaintingStyle.fill;

    final Path plusPath =
        Path()
          ..moveTo(100, 10.2142)
          ..lineTo(94.5053, 10.2142)
          ..lineTo(94.5053, 15.8542)
          ..lineTo(90.6677, 15.8542)
          ..lineTo(90.6677, 10.2142)
          ..lineTo(85.173, 10.2142)
          ..lineTo(85.173, 6.66731)
          ..lineTo(90.6677, 6.66731)
          ..lineTo(90.6677, 1.02723)
          ..lineTo(94.5053, 1.02723)
          ..lineTo(94.5053, 6.66731)
          ..lineTo(100, 6.66731)
          ..close();

    canvas.drawPath(plusPath, paint);

    final Path nPath =
        Path()
          ..moveTo(8.92528, 0.0290722)
          ..cubicTo(10.8441, 0.0290722, 12.3946, 0.639597, 13.5769, 1.86065)
          ..cubicTo(14.7592, 3.06231, 15.3503, 4.74852, 15.3503, 6.91927)
          ..lineTo(15.3503, 16.3679)
          ..lineTo(11.2802, 16.3679)
          ..lineTo(11.2802, 7.47165)
          ..cubicTo(11.2802, 6.19246, 10.9604, 5.21368, 10.3208, 4.53532)
          ..cubicTo(9.68117, 3.83758, 8.80899, 3.48871, 7.70424, 3.48871)
          ..cubicTo(6.5801, 3.48871, 5.68854, 3.83758, 5.02956, 4.53532)
          ..cubicTo(4.38996, 5.21368, 4.07016, 6.19246, 4.07016, 7.47165)
          ..lineTo(4.07016, 16.3679)
          ..lineTo(0, 16.3679)
          ..lineTo(0, 0.261653)
          ..lineTo(4.07016, 0.261653)
          ..lineTo(4.07016, 2.26766)
          ..cubicTo(4.61285, 1.56992, 5.3009, 1.02723, 6.13432, 0.639597)
          ..cubicTo(6.98711, 0.23258, 7.91743, 0.0290722, 8.92528, 0.0290722)
          ..close();

    canvas.drawPath(nPath, paint);

    final Path ePath =
        Path()
          ..moveTo(34.1932, 7.96589)
          ..cubicTo(34.1932, 8.54734, 34.1545, 9.07064, 34.0769, 9.53581)
          ..lineTo(22.3025, 9.53581)
          ..cubicTo(22.3994, 10.6987, 22.8065, 11.6096, 23.5236, 12.2686)
          ..cubicTo(24.2407, 12.9276, 25.1226, 13.2571, 26.1692, 13.2571)
          ..cubicTo(27.681, 13.2571, 28.7566, 12.6078, 29.3962, 11.3092)
          ..lineTo(33.7862, 11.3092)
          ..cubicTo(33.321, 12.8598, 32.4295, 14.139, 31.1115, 15.1468)
          ..cubicTo(29.7936, 16.1353, 28.1752, 16.6295, 26.2564, 16.6295)
          ..cubicTo(24.7059, 16.6295, 23.3104, 16.2903, 22.07, 15.612)
          ..cubicTo(20.8489, 14.9142, 19.8895, 13.9355, 19.1918, 12.6756)
          ..cubicTo(18.5134, 11.4158, 18.1742, 9.9622, 18.1742, 8.31476)
          ..cubicTo(18.1742, 6.64793, 18.5134, 5.18461, 19.1918, 3.9248)
          ..cubicTo(19.8701, 2.66499, 20.8198, 1.6959, 22.0409, 1.01754)
          ..cubicTo(23.2619, 0.33918, 24.6671, 0, 26.2564, 0)
          ..cubicTo(27.7876, 0, 29.154, 0.329489, 30.3556, 0.988467)
          ..cubicTo(31.5767, 1.64745, 32.5167, 2.58746, 33.1757, 3.80851)
          ..cubicTo(33.854, 5.01017, 34.1932, 6.39597, 34.1932, 7.96589)
          ..close()
          ..moveTo(29.9777, 6.80298)
          ..cubicTo(29.9583, 5.75637, 29.5804, 4.92296, 28.8439, 4.30274)
          ..cubicTo(28.1074, 3.66315, 27.2061, 3.34335, 26.1401, 3.34335)
          ..cubicTo(25.1323, 3.34335, 24.2795, 3.65345, 23.5817, 4.27367)
          ..cubicTo(22.9034, 4.8745, 22.4867, 5.71761, 22.3316, 6.80298)
          ..lineTo(29.9777, 6.80298)
          ..close();

    canvas.drawPath(ePath, paint);

    final Path uPath =
        Path()
          ..moveTo(52.369, 0.261653)
          ..lineTo(52.369, 16.3679)
          ..lineTo(48.2698, 16.3679)
          ..lineTo(48.2698, 14.3328)
          ..cubicTo(47.7465, 15.0305, 47.0584, 15.5829, 46.2056, 15.9899)
          ..cubicTo(45.3722, 16.3776, 44.4613, 16.5714, 43.4728, 16.5714)
          ..cubicTo(42.213, 16.5714, 41.0986, 16.3097, 40.1295, 15.7864)
          ..cubicTo(39.1604, 15.2437, 38.3948, 14.4588, 37.8327, 13.4315)
          ..cubicTo(37.2901, 12.3849, 37.0187, 11.1445, 37.0187, 9.71024)
          ..lineTo(37.0187, 0.261653)
          ..lineTo(41.0889, 0.261653)
          ..lineTo(41.0889, 9.12879)
          ..cubicTo(41.0889, 10.408, 41.4087, 11.3965, 42.0483, 12.0942)
          ..cubicTo(42.6879, 12.7726, 43.56, 13.1117, 44.6648, 13.1117)
          ..cubicTo(45.7889, 13.1117, 46.6708, 12.7726, 47.3104, 12.0942)
          ..cubicTo(47.95, 11.3965, 48.2698, 10.408, 48.2698, 9.12879)
          ..lineTo(48.2698, 0.261653)
          ..lineTo(52.369, 0.261653)
          ..close();

    canvas.drawPath(uPath, paint);

    final Path rPath =
        Path()
          ..moveTo(60.4551, 2.76189)
          ..cubicTo(60.9784, 1.9091, 61.6567, 1.24043, 62.4902, 0.755888)
          ..cubicTo(63.343, 0.271344, 64.312, 0.0290722, 65.3974, 0.0290722)
          ..lineTo(65.3974, 4.30274)
          ..lineTo(64.3217, 4.30274)
          ..cubicTo(63.0425, 4.30274, 62.0734, 4.60316, 61.4145, 5.20399)
          ..cubicTo(60.7749, 5.80483, 60.4551, 6.85144, 60.4551, 8.34383)
          ..lineTo(60.4551, 16.3679)
          ..lineTo(56.3849, 16.3679)
          ..lineTo(56.3849, 0.261653)
          ..lineTo(60.4551, 0.261653)
          ..lineTo(60.4551, 2.76189)
          ..close();

    canvas.drawPath(rPath, paint);

    final Path oPath =
        Path()
          ..moveTo(75.2907, 16.6295)
          ..cubicTo(73.7402, 16.6295, 72.3447, 16.2903, 71.1043, 15.612)
          ..cubicTo(69.8638, 14.9142, 68.8851, 13.9355, 68.1679, 12.6756)
          ..cubicTo(67.4702, 11.4158, 67.1213, 9.9622, 67.1213, 8.31476)
          ..cubicTo(67.1213, 6.66731, 67.4799, 5.21368, 68.197, 3.95387)
          ..cubicTo(68.9335, 2.69406, 69.9317, 1.72497, 71.1915, 1.04661)
          ..cubicTo(72.4513, 0.348871, 73.8565, 0, 75.407, 0)
          ..cubicTo(76.9576, 0, 78.3627, 0.348871, 79.6225, 1.04661)
          ..cubicTo(80.8824, 1.72497, 81.8708, 2.69406, 82.5879, 3.95387)
          ..cubicTo(83.3244, 5.21368, 83.6927, 6.66731, 83.6927, 8.31476)
          ..cubicTo(83.6927, 9.9622, 83.3148, 11.4158, 82.5589, 12.6756)
          ..cubicTo(81.8224, 13.9355, 80.8145, 14.9142, 79.5353, 15.612)
          ..cubicTo(78.2755, 16.2903, 76.8606, 16.6295, 75.2907, 16.6295)
          ..close()
          ..moveTo(75.2907, 13.0827)
          ..cubicTo(76.0272, 13.0827, 76.7153, 12.9082, 77.3549, 12.5594)
          ..cubicTo(78.0139, 12.1911, 78.5372, 11.6484, 78.9248, 10.9313)
          ..cubicTo(79.3124, 10.2142, 79.5062, 9.34199, 79.5062, 8.31476)
          ..cubicTo(79.5062, 6.7836, 79.0992, 5.61101, 78.2852, 4.79698)
          ..cubicTo(77.4905, 3.96356, 76.5118, 3.54685, 75.3489, 3.54685)
          ..cubicTo(74.186, 3.54685, 73.2072, 3.96356, 72.4125, 4.79698)
          ..cubicTo(71.6373, 5.61101, 71.2496, 6.7836, 71.2496, 8.31476)
          ..cubicTo(71.2496, 9.84591, 71.6276, 11.0282, 72.3835, 11.8616)
          ..cubicTo(73.1587, 12.6756, 74.1278, 13.0827, 75.2907, 13.0827)
          ..close();

    canvas.drawPath(oPath, paint);

    canvas.restore();
  }

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    offset += _config.margin.topLeft;
    final Size canvasSize = _config.margin.deflateSize(configuration.size!);
    if (canvasSize.isEmpty) {
      return;
    }

    final Rect rect = Alignment.center.inscribe(
      const Size(100, 17),
      offset & canvasSize,
    );

    if (_config._opacity < 1.0) {
      canvas.saveLayer(
        offset & canvasSize,
        Paint()
          ..colorFilter = ColorFilter.mode(
            const Color(0xFFFFFFFF).withValues(alpha: _config._opacity),
            BlendMode.modulate,
          ),
      );
    }

    _paintLogo(canvas, rect);

    if (_config._opacity < 1.0) {
      canvas.restore();
    }
  }
}
