import 'dart:math' as math;

import 'package:flutter/material.dart';

class FogParticleField extends StatefulWidget {
  const FogParticleField({super.key, required this.active});

  final bool active;

  @override
  State<FogParticleField> createState() => _FogParticleFieldState();
}

class _FogParticleFieldState extends State<FogParticleField>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 8),
  );

  @override
  void initState() {
    super.initState();
    if (widget.active) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant FogParticleField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.active && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        return CustomPaint(
          painter: _FogParticlePainter(progress: _controller.value),
        );
      },
    );
  }
}

class _FogParticlePainter extends CustomPainter {
  _FogParticlePainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;
    final double angle = progress * 2 * math.pi;

    final List<_ParticleDescriptor> particles = <_ParticleDescriptor>[
      _ParticleDescriptor(
        center: Offset(
          width * 0.28 + math.sin(angle) * 30,
          height * 0.35 + math.cos(angle * 0.7) * 25,
        ),
        radius: width * 0.22,
        maxOpacity: 0.40,
      ),
      _ParticleDescriptor(
        center: Offset(
          width * 0.62 + math.cos(angle * 0.9) * 40,
          height * 0.55 + math.sin(angle) * 20,
        ),
        radius: width * 0.26,
        maxOpacity: 0.35,
      ),
      _ParticleDescriptor(
        center: Offset(
          width * 0.45 + math.sin(angle * 1.2) * 35,
          height * 0.75 + math.cos(angle * 0.8) * 22,
        ),
        radius: width * 0.24,
        maxOpacity: 0.30,
      ),
    ];

    for (final _ParticleDescriptor particle in particles) {
      final double opacity =
          particle.maxOpacity * (0.6 + 0.4 * math.sin(angle + particle.radius));
      final double clampedOpacity = opacity.clamp(0.0, 1.0).toDouble();
      final Paint paint = Paint()
        ..shader = RadialGradient(
          colors: <Color>[
            Colors.white.withValues(alpha: clampedOpacity),
            Colors.white.withValues(alpha: 0.0),
          ],
        ).createShader(
          Rect.fromCircle(center: particle.center, radius: particle.radius),
        );

      canvas.drawCircle(particle.center, particle.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _FogParticlePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _ParticleDescriptor {
  const _ParticleDescriptor({
    required this.center,
    required this.radius,
    required this.maxOpacity,
  });

  final Offset center;
  final double radius;
  final double maxOpacity;
}
