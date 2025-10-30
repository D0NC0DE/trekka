import 'package:flutter/material.dart';

import 'package:trekka/core/design/gradients.dart';
import 'package:trekka/core/design/shadows.dart';
import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/core/widgets/inner_shadow.dart';

/// A card with gradient background containing a toggle button and volume slider.
/// Similar styling to GradientInfoCard but with interactive controls.
class GradientVolumeCard extends StatelessWidget {
  const GradientVolumeCard({
    required this.icon,
    required this.isEnabled,
    required this.onToggle,
    required this.value,
    required this.onChanged,
    required this.label,
    this.gradient = AppGradients.logisticsActionButton,
    this.borderColor = AppColors.primaryBright,
    this.labelColor = AppColors.accentAmber,
    this.padding = const EdgeInsets.only(
      top: 12,
      bottom: 12,
      left: 16,
      right: 16,
    ),
    this.borderWidth = 2,
    this.borderRadius,
    super.key,
  });

  /// Icon widget for the toggle button
  final Widget icon;

  /// Whether the control is enabled/active
  final bool isEnabled;

  /// Callback when toggle button is tapped
  final VoidCallback onToggle;

  /// Current slider value (0.0 to 1.0)
  final double value;

  /// Callback when slider value changes
  final ValueChanged<double> onChanged;

  /// Label text displayed at bottom-right
  final String label;

  /// Background gradient
  final Gradient gradient;

  /// Border color
  final Color borderColor;

  /// Label text color
  final Color labelColor;

  /// Internal padding
  final EdgeInsetsGeometry padding;

  /// Border width
  final double borderWidth;

  /// Border radius (defaults to AppRadius.sm)
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        gradient: gradient,
        border: Border.all(color: borderColor, width: borderWidth),
        borderRadius: BorderRadius.circular(borderRadius ?? AppRadius.sm),
      ),
      child: Row(
        children: <Widget>[
          _VolumeButton(icon: icon),
          const SizedBox(width: 12),
          Expanded(
            child: _VolumeSlider(
              value: value,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

/// Volume button with gradient and shadows (38×36px).
class _VolumeButton extends StatelessWidget {
  const _VolumeButton({required this.icon});

  final Widget icon;

  static const double _width = 38;
  static const double _height = 36;
  static const double _borderRadius = 16;

  @override
  Widget build(BuildContext context) {
    return InnerShadow(
      shadows: AppShadows.volumeButtonInner,
      borderRadius: BorderRadius.circular(_borderRadius),
      child: Container(
        width: _width,
        height: _height,
        decoration: BoxDecoration(
          gradient: AppGradients.logisticsActionButton,
          border: Border.all(color: AppColors.primaryBright, width: 1),
          borderRadius: BorderRadius.circular(_borderRadius),
          boxShadow: AppShadows.volumeButton,
        ),
        child: Center(child: SizedBox(width: 20, height: 20, child: icon)),
      ),
    );
  }
}

/// Custom two-layer slider for volume control.
class _VolumeSlider extends StatefulWidget {
  const _VolumeSlider({
    required this.value,
    required this.onChanged,
  });

  final double value;
  final ValueChanged<double> onChanged;

  @override
  State<_VolumeSlider> createState() => _VolumeSliderState();
}

class _VolumeSliderState extends State<_VolumeSlider> {
  double _localValue = 0.0;

  static const double _trackWidth = 184;
  static const double _trackHeight = 16;
  static const double _progressHeight = 20;
  static const double _borderRadius = 12;

  @override
  void initState() {
    super.initState();
    _localValue = widget.value.clamp(0.0, 1.0);
  }

  @override
  void didUpdateWidget(_VolumeSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _localValue = widget.value.clamp(0.0, 1.0);
    }
  }

  void _updateValue(double localX) {
    final double newValue = (localX / _trackWidth).clamp(0.0, 1.0);
    setState(() {
      _localValue = newValue;
    });
    widget.onChanged(_localValue);
  }

  @override
  Widget build(BuildContext context) {
    final double progressWidth = _localValue * _trackWidth;

    return GestureDetector(
      onPanStart: (DragStartDetails details) {
        _updateValue(details.localPosition.dx);
      },
      onPanUpdate: (DragUpdateDetails details) {
        _updateValue(details.localPosition.dx);
      },
      onTapDown: (TapDownDetails details) {
        _updateValue(details.localPosition.dx);
      },
      child: SizedBox(
        width: _trackWidth,
        height: _progressHeight,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: <Widget>[
            // Background layer (track)
            Positioned(
              left: 0,
              child: Container(
                width: _trackWidth,
                height: _trackHeight,
                decoration: BoxDecoration(
                  color: AppColors.sliderTrackBackground,
                  borderRadius: BorderRadius.circular(_borderRadius),
                  boxShadow: AppShadows.volumeSliderTrack,
                ),
              ),
            ),
            // Foreground layer (progress indicator)
            if (progressWidth > 0)
              Positioned(
                left: 0,
                child: InnerShadow(
                  shadows: AppShadows.volumeSliderThumbInner,
                  borderRadius: BorderRadius.circular(_borderRadius),
                  child: Container(
                    width: progressWidth.clamp(
                        _progressHeight, _trackWidth), // Min width = height for rounded ends
                    height: _progressHeight,
                    decoration: BoxDecoration(
                      color: AppColors.accentAmber,
                      borderRadius: BorderRadius.circular(_borderRadius),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
