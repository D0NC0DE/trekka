import 'package:flutter/material.dart';

import 'package:trekka/core/design/shadows.dart';
import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/core/widgets/inner_shadow.dart';

/// A visual connector showing route/journey flow from point A to point B.
/// 
/// Displays a vertical line with dots at both ends to indicate direction.
class RouteConnector extends StatelessWidget {
  const RouteConnector({
    this.height,
    this.lineColor,
    this.dotColor,
    this.lineWidth = 2,
    this.dotSize = 8,
    this.squareBottomDot = true,
    super.key,
  });

  final double? height;
  final Color? lineColor;
  final Color? dotColor;
  final double lineWidth;
  final double dotSize;
  final bool squareBottomDot;

  @override
  Widget build(BuildContext context) {
    final Color color = lineColor ?? AppColors.white;
    final Color dot = dotColor ?? AppColors.white;
    final double connectorHeight = height ?? AppSpacing.lg;

    return SizedBox(
      height: connectorHeight,
      child: Center(
        child: SizedBox(
          width: lineWidth + dotSize,
          child: Column(
            children: <Widget>[
              // Top dot (circle)
              InnerShadow(
                borderRadius: BorderRadius.circular(dotSize / 2),
                shadows: AppShadows.routeConnectorDot,
                child: Container(
                  width: dotSize,
                  height: dotSize,
                  decoration: BoxDecoration(
                    color: dot,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              
              // Connecting line
              Expanded(
                child: InnerShadow(
                  borderRadius: BorderRadius.zero,
                  shadows: AppShadows.routeConnectorLineInner,
                  child: Container(
                    width: lineWidth,
                    decoration: BoxDecoration(
                      color: color,
                      boxShadow: AppShadows.routeConnectorLineOuter,
                    ),
                  ),
                ),
              ),
              
              // Bottom dot (square or circle based on parameter)
              InnerShadow(
                borderRadius: BorderRadius.circular(squareBottomDot ? 2 : dotSize / 2),
                shadows: AppShadows.routeConnectorDot,
                child: Container(
                  width: dotSize,
                  height: dotSize,
                  decoration: BoxDecoration(
                    color: dot,
                    borderRadius: BorderRadius.circular(squareBottomDot ? 2 : dotSize / 2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

