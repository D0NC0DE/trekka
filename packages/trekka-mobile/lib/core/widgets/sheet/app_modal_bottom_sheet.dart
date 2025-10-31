import 'package:flutter/material.dart';

class AppModalBottomSheet {
  /// Shows a modal bottom sheet with consistent app-wide styling and behavior.
  /// 
  /// Modal sheets prevent interaction with the rest of the screen.
  ///
  /// [context] - The build context
  /// [child] - The content widget to display in the sheet
  /// [heightFactor] - The height as a fraction of screen height (0.0 to 1.0)
  /// [maxHeightFactor] - Maximum height as a fraction (for flexible mode)
  /// [isFlexible] - If true, height adapts to content up to maxHeightFactor
  /// [isDismissible] - Whether tapping outside dismisses the sheet
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    double heightFactor = 0.8,
    double? maxHeightFactor,
    bool isFlexible = false,
    bool isDismissible = true,
  }) {
    if (!isFlexible) {
      assert(
        heightFactor > 0.0 && heightFactor <= 1.0,
        'heightFactor must be between 0.0 and 1.0',
      );
    }

    final Size size = MediaQuery.of(context).size;
    final double? sheetHeight = isFlexible ? null : size.height * heightFactor;
    final double? maxHeight = isFlexible && maxHeightFactor != null
        ? size.height * maxHeightFactor
        : null;

    return showModalBottomSheet<T>(
      context: context,
      elevation: 0,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: isDismissible,
      enableDrag: isDismissible,
      sheetAnimationStyle: const AnimationStyle(
        curve: Curves.easeIn,
        reverseCurve: Curves.easeOut,
        duration: Duration(milliseconds: 500),
        reverseDuration: Duration(milliseconds: 500),
      ),
      builder: (BuildContext sheetContext) {
        final double bottomInset = MediaQuery.of(
          sheetContext,
        ).viewInsets.bottom;

        return Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: Stack(
            children: <Widget>[
              if (isDismissible)
                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => Navigator.of(sheetContext).pop(),
                  ),
                ),
              Align(
                alignment: Alignment.bottomCenter,
                child: isFlexible
                    ? ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: maxHeight ?? size.height * 0.9,
                        ),
                        child: IntrinsicHeight(
                          child: child,
                        ),
                      )
                    : SizedBox(
                        height: sheetHeight,
                        child: child,
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

