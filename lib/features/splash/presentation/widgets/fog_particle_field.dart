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
    duration: const Duration(seconds: 10),
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
  
  static final Paint _paint = Paint();

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
        radius: width * 0.28,
        maxOpacity: 0.70,
      ),
      _ParticleDescriptor(
        center: Offset(
          width * 0.62 + math.cos(angle * 0.9) * 40,
          height * 0.55 + math.sin(angle) * 20,
        ),
        radius: width * 0.32,
        maxOpacity: 0.60,
      ),
      _ParticleDescriptor(
        center: Offset(
          width * 0.45 + math.sin(angle * 1.2) * 35,
          height * 0.75 + math.cos(angle * 0.8) * 22,
        ),
        radius: width * 0.30,
        maxOpacity: 0.55,
      ),
      _ParticleDescriptor(
        center: Offset(
          width * 0.20 + math.cos(angle * 0.6) * 42,
          height * 0.68 + math.sin(angle * 0.9) * 28,
        ),
        radius: width * 0.25,
        maxOpacity: 0.50,
      ),
      _ParticleDescriptor(
        center: Offset(
          width * 0.78 + math.sin(angle * 0.8) * 35,
          height * 0.40 + math.cos(angle * 1.1) * 24,
        ),
        radius: width * 0.26,
        maxOpacity: 0.58,
      ),
    ];

    for (final _ParticleDescriptor particle in particles) {
      final double modulation = 0.75 + 0.25 * math.sin(angle + particle.radius);
      final double opacity = particle.maxOpacity * modulation;
      final double clampedOpacity = opacity.clamp(0.0, 1.0).toDouble();
      
      _paint.shader = RadialGradient(
        colors: <Color>[
          Colors.white.withValues(alpha: clampedOpacity),
          Colors.white.withValues(alpha: 0.0),
        ],
      ).createShader(
        Rect.fromCircle(center: particle.center, radius: particle.radius),
      );

      canvas.drawCircle(particle.center, particle.radius, _paint);
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
