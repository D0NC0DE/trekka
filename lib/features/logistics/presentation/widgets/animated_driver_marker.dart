import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:trekka/core/assets/app_assets.dart';
import 'package:trekka/core/design/tokens.dart';

/// Manages animated nearby driver markers on the map
class AnimatedDriverMarkerController {
  AnimatedDriverMarkerController({
    required this.pickupLocation,
    required this.onMarkersUpdated,
  });

  final LatLng pickupLocation;
  final ValueChanged<Set<Marker>> onMarkersUpdated;

  Timer? _updateTimer;
  Timer? _animationTimer;
  final List<_DriverMarkerData> _activeMarkers = [];
  final Random _random = Random();
  int _markerIdCounter = 0;
  final List<BitmapDescriptor> _animationFrames = [];
  int _currentFrame = 0;

  /// Start showing animated drivers
  Future<void> start() async {
    stop();

    await _generateAnimationFrames();

    _spawnInitialDrivers();

    _updateTimer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => _updateDrivers(),
    );

    // Animate marker pulsing every 50ms (20fps for smooth animation)
    _animationTimer = Timer.periodic(
      const Duration(milliseconds: 50),
      (_) => _animateMarkers(),
    );
  }

  /// Generate animation frames for pulsing effect
  Future<void> _generateAnimationFrames() async {
    const int frameCount = 30;
    _animationFrames.clear();

    for (int i = 0; i < frameCount; i++) {
      final double t = i / (frameCount - 1);
      final double animationValue = _springCurve(t);
      final frame = await _createDriverMarkerIcon(animationValue);
      _animationFrames.add(frame);
    }
  }

  /// Spring physics curve (mass: 1, stiffness: 28.8, damping: 12)
  double _springCurve(double t) {
    const double mass = 1.0;
    const double stiffness = 28.8;
    const double damping = 12.0;

    final double omega = sqrt(stiffness / mass);
    final double zeta = damping / (2 * sqrt(mass * stiffness));

    if (zeta < 1) {
      // Under-damped spring
      final double omegaD = omega * sqrt(1 - zeta * zeta);
      final double envelope = exp(-zeta * omega * t);
      return 1 -
          envelope *
              (cos(omegaD * t) + (zeta * omega / omegaD) * sin(omegaD * t));
    } else {
      return 1 - exp(-omega * t);
    }
  }

  void _animateMarkers() {
    _currentFrame = (_currentFrame + 1) % _animationFrames.length;
    _notifyUpdate();
  }

  /// Stop showing animated drivers
  void stop() {
    _updateTimer?.cancel();
    _updateTimer = null;
    _animationTimer?.cancel();
    _animationTimer = null;
    _activeMarkers.clear();
    _animationFrames.clear();
    _currentFrame = 0;
    onMarkersUpdated({});
  }

  void _spawnInitialDrivers() {
    final count = _random.nextInt(3) + 1;
    for (int i = 0; i < count; i++) {
      _spawnDriver();
    }
    _notifyUpdate();
  }

  void _updateDrivers() {
    final targetCount = _random.nextInt(5);
    while (_activeMarkers.length > targetCount) {
      _activeMarkers.removeAt(_random.nextInt(_activeMarkers.length));
    }

    while (_activeMarkers.length < targetCount) {
      _spawnDriver();
    }

    for (var driver in _activeMarkers) {
      _moveDriver(driver);
    }

    _notifyUpdate();
  }

  void _spawnDriver() {
    final angle = _random.nextDouble() * 2 * pi;
    final distance = (_random.nextDouble() * 0.003) + 0.001; // 100-400m roughly

    final lat = pickupLocation.latitude + (distance * cos(angle));
    final lng = pickupLocation.longitude + (distance * sin(angle));

    _activeMarkers.add(
      _DriverMarkerData(
        id: 'nearby_driver_${_markerIdCounter++}',
        position: LatLng(lat, lng),
        direction: _random.nextDouble() * 2 * pi,
      ),
    );
  }

  void _moveDriver(_DriverMarkerData driver) {
    // Random walk with slight bias toward pickup location
    final towardsPickup = _random.nextDouble() < 0.3;

    double newDirection;
    if (towardsPickup) {
      // Move slightly toward pickup
      final angleToPickup = atan2(
        pickupLocation.latitude - driver.position.latitude,
        pickupLocation.longitude - driver.position.longitude,
      );
      newDirection = angleToPickup + (_random.nextDouble() - 0.5) * pi / 2;
    } else {
      // Random direction change
      newDirection = driver.direction + (_random.nextDouble() - 0.5) * pi / 3;
    }

    final moveDistance = 0.0003; // ~30m
    final newLat =
        driver.position.latitude + (moveDistance * cos(newDirection));
    final newLng =
        driver.position.longitude + (moveDistance * sin(newDirection));

    driver.position = LatLng(newLat, newLng);
    driver.direction = newDirection;
  }

  void _notifyUpdate() {
    if (_animationFrames.isEmpty) return;

    final currentIcon = _animationFrames[_currentFrame];

    final markers = _activeMarkers.map((driver) {
      return Marker(
        markerId: MarkerId(driver.id),
        position: driver.position,
        anchor: const Offset(0.5, 0.5),
        icon: currentIcon,
      );
    }).toSet();

    onMarkersUpdated(markers);
  }

  /// Create custom driver marker icon with pulsing circles
  /// [animationValue] ranges from 0.0 (start) to 1.0 (end of pulse)
  Future<BitmapDescriptor> _createDriverMarkerIcon(
    double animationValue,
  ) async {
    const int size = 140;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint()..isAntiAlias = true;

    const center = Offset(size / 2, size / 2);

    const double outerBaseRadius = 26.0;
    const double outerMaxRadius = 36.0;
    const double innerBaseRadius = 18.0;
    const double innerMaxRadius = 24.0;

    final double outerRadius =
        outerBaseRadius + (outerMaxRadius - outerBaseRadius) * animationValue;
    final double innerRadius =
        innerBaseRadius + (innerMaxRadius - innerBaseRadius) * animationValue;

    // Outer circle - solid with 35% opacity (animated size)
    paint.color = AppColors.nearbyDriverMarkerOuter;
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(center, outerRadius, paint);

    // Inner circle - solid with 50% opacity (animated size)
    paint.color = AppColors.nearbyDriverMarkerInner;
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(center, innerRadius, paint);

    // Solid center circle (fixed size)
    paint.color = AppColors.nearbyDriverMarkerCenter;
    canvas.drawCircle(center, 16, paint);

    try {
      final ByteData data = await rootBundle.load(
        AppAssetIcons.nearbyDriversMarker,
      );
      final codec = await ui.instantiateImageCodec(
        data.buffer.asUint8List(),
        targetWidth: 14,
        targetHeight: 24,
      );
      final frame = await codec.getNextFrame();
      final image = frame.image;

      canvas.drawImage(image, Offset(center.dx - 7, center.dy - 12), Paint());
    } catch (e) {
      debugPrint('Failed to load driver marker icon: $e');
    }

    final picture = recorder.endRecording();
    final img = await picture.toImage(size, size);
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    final buffer = byteData!.buffer.asUint8List();

    return BitmapDescriptor.bytes(buffer);
  }

  void dispose() {
    stop();
  }
}

class _DriverMarkerData {
  _DriverMarkerData({
    required this.id,
    required this.position,
    required this.direction,
  });

  final String id;
  LatLng position;
  double direction;
}

class AnimatedDriverMarkerPainter extends CustomPainter {
  AnimatedDriverMarkerPainter({required this.animationValue});

  final double animationValue;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final outerRadius = 13 + (5 * animationValue);
    final outerPaint = Paint()
      ..color = AppColors.nearbyDriverMarkerOuter
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 50);

    canvas.drawCircle(center, outerRadius, outerPaint);

    final innerRadius = 9 + (3 * animationValue);
    final innerPaint = Paint()
      ..color = AppColors.nearbyDriverMarkerInner
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30);

    canvas.drawCircle(center, innerRadius, innerPaint);

    final solidPaint = Paint()
      ..color = AppColors.nearbyDriverMarkerCenter
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, 9, solidPaint);
  }

  @override
  bool shouldRepaint(AnimatedDriverMarkerPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

/// Manages animated pickup marker (pulsing effect during driver search)
class AnimatedPickupMarkerController {
  AnimatedPickupMarkerController({required this.onFrameUpdated});

  final ValueChanged<BitmapDescriptor> onFrameUpdated;

  Timer? _animationTimer;
  final List<BitmapDescriptor> _animationFrames = [];
  int _currentFrame = 0;

  /// Start animating the pickup marker
  Future<void> start() async {
    stop();
    await _generateAnimationFrames();
    _animationTimer = Timer.periodic(
      const Duration(milliseconds: 50),
      (_) => _animateFrame(),
    );
  }

  /// Stop animating
  void stop() {
    _animationTimer?.cancel();
    _animationTimer = null;
    _currentFrame = 0;
  }

  void _animateFrame() {
    if (_animationFrames.isEmpty) return;
    _currentFrame = (_currentFrame + 1) % _animationFrames.length;
    onFrameUpdated(_animationFrames[_currentFrame]);
  }

  Future<void> _generateAnimationFrames() async {
    const int frameCount = 30;
    _animationFrames.clear();

    for (int i = 0; i < frameCount; i++) {
      final double t = i / (frameCount - 1);
      final double animationValue = _springCurve(t);
      final frame = await _createPickupMarkerIcon(animationValue);
      _animationFrames.add(frame);
    }
  }

  double _springCurve(double t) {
    const double mass = 1.0;
    const double stiffness = 28.8;
    const double damping = 12.0;

    final double omega = sqrt(stiffness / mass);
    final double zeta = damping / (2 * sqrt(mass * stiffness));

    if (zeta < 1) {
      final double omegaD = omega * sqrt(1 - zeta * zeta);
      final double envelope = exp(-zeta * omega * t);
      return 1 -
          envelope *
              (cos(omegaD * t) + (zeta * omega / omegaD) * sin(omegaD * t));
    } else {
      return 1 - exp(-omega * t);
    }
  }

  Future<BitmapDescriptor> _createPickupMarkerIcon(
    double animationValue,
  ) async {
    const int size = 96;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint()..isAntiAlias = true;

    const center = Offset(size / 2, size / 2);

    // Animate outer and inner circles while keeping the footprint compact.
    const double outerBaseRadius = 20.0;
    const double outerMaxRadius = 28.0;
    const double innerBaseRadius = 14.0;
    const double innerMaxRadius = 20.0;

    final double outerRadius =
        outerBaseRadius + (outerMaxRadius - outerBaseRadius) * animationValue;
    final double innerRadius =
        innerBaseRadius + (innerMaxRadius - innerBaseRadius) * animationValue;

    // Outer circle using alternate blue pulse to avoid clashing with driver markers
    paint.color = AppColors.pickupPulseOuter;
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(center, outerRadius, paint);

    // Inner circle with slightly stronger opacity
    paint.color = AppColors.pickupPulseInner;
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(center, innerRadius, paint);

    // Solid center circle (fixed size)
    paint.color = AppColors.accentAmber;
    canvas.drawCircle(center, 10, paint);

    // Load and draw the rider marker icon
    try {
      final ByteData data = await rootBundle.load(AppAssetIcons.riderMarker);
      final codec = await ui.instantiateImageCodec(
        data.buffer.asUint8List(),
        targetWidth: 26,
        targetHeight: 26,
      );
      final frame = await codec.getNextFrame();
      final image = frame.image;

      canvas.drawImage(image, Offset(center.dx - 13, center.dy - 13), Paint());
    } catch (e) {
      debugPrint('Failed to load rider marker icon: $e');
    }

    final picture = recorder.endRecording();
    final img = await picture.toImage(size, size);
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    final buffer = byteData!.buffer.asUint8List();

    return BitmapDescriptor.bytes(buffer);
  }

  void dispose() {
    stop();
    _animationFrames.clear();
  }
}
