import 'package:flutter/material.dart';

/// Inset shadow for a rounded rectangle using a foreground CustomPainter.
class InnerShadow extends StatelessWidget {
  const InnerShadow({
    super.key,
    required this.borderRadius,
    required this.shadows,
    required this.child,
  });

  final BorderRadius borderRadius;
  final List<BoxShadow> shadows;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: _InnerShadowPainter(
        borderRadius: borderRadius,
        shadows: shadows,
      ),
      child: child,
    );
  }
}

class _InnerShadowPainter extends CustomPainter {
  _InnerShadowPainter({
    required this.borderRadius,
    required this.shadows,
  });

  final BorderRadius borderRadius;
  final List<BoxShadow> shadows;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || shadows.isEmpty) return;

    final Rect rect = Offset.zero & size;
    final RRect rrect = RRect.fromRectAndCorners(
      rect,
      topLeft: borderRadius.topLeft,
      topRight: borderRadius.topRight,
      bottomLeft: borderRadius.bottomLeft,
      bottomRight: borderRadius.bottomRight,
    );

    canvas.save();
    canvas.clipRRect(rrect);

    const double kOuterInflate = 50;
    final Rect outerRect = Rect.fromLTWH(
      -kOuterInflate,
      -kOuterInflate,
      size.width + kOuterInflate * 2,
      size.height + kOuterInflate * 2,
    );
    final Path outerPath = Path()
      ..addRect(outerRect)
      ..addRRect(rrect)
      ..fillType = PathFillType.evenOdd;

    for (final BoxShadow shadow in shadows) {
      final Paint paint = Paint()
        ..color = shadow.color
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, shadow.blurRadius);

      canvas.save();
      canvas.translate(shadow.offset.dx, shadow.offset.dy);
      canvas.drawPath(outerPath, paint);
      canvas.restore();
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _InnerShadowPainter oldDelegate) {
    return oldDelegate.borderRadius != borderRadius ||
        oldDelegate.shadows != shadows;
  }
}


