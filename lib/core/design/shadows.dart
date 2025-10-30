import 'package:flutter/material.dart';

import 'tokens.dart';

class AppShadows {
  AppShadows._();

  static const List<BoxShadow> homeNav = <BoxShadow>[
    BoxShadow(
      color: AppColors.shadowSoftBlack,
      offset: Offset(2, 2),
      blurRadius: 5.8,
      blurStyle: BlurStyle.inner,
    ),
    BoxShadow(
      color: AppColors.deepTeal,
      offset: Offset(-1, -2),
      blurRadius: 4,
      blurStyle: BlurStyle.inner,
    ),
  ];

  static const List<BoxShadow> homeNavDrop = <BoxShadow>[
    BoxShadow(
      color: AppColors.shadowStrongBlack,
      offset: Offset(0, 4),
      blurRadius: 16,
      spreadRadius: 0,
      blurStyle: BlurStyle.normal,
    ),
  ];

  static const List<BoxShadow> homeNavOptionInner = <BoxShadow>[
    BoxShadow(
      color: AppColors.deepTeal,
      offset: Offset(-1, -2),
      blurRadius: 4,
      blurStyle: BlurStyle.inner,
    ),
    BoxShadow(
      color: AppColors.shadowMidBlack,
      offset: Offset(2, 2),
      blurRadius: 5.8,
      blurStyle: BlurStyle.inner,
    ),
  ];

  static const List<BoxShadow> homePointBadgeInner = <BoxShadow>[
    BoxShadow(
      color: AppColors.badgeInnerHighlight,
      offset: Offset(-1, -2),
      blurRadius: 4,
      blurStyle: BlurStyle.inner,
    ),
    BoxShadow(
      color: AppColors.badgeInnerShade,
      offset: Offset(0, 4),
      blurRadius: 4,
      blurStyle: BlurStyle.inner,
    ),
  ];

  static const List<BoxShadow> textFieldInner = <BoxShadow>[
    BoxShadow(
      color: AppColors.shadowMidBlack,
      offset: Offset(-1, -2),
      blurRadius: 4,
      blurStyle: BlurStyle.inner,
    ),
    BoxShadow(
      color: AppColors.shadowMidBlack,
      offset: Offset(2, 2),
      blurRadius: 4,
      blurStyle: BlurStyle.inner,
    ),
  ];

  static const List<BoxShadow> buttonInner = <BoxShadow>[
    BoxShadow(
      color: AppColors.shadowMidBlack,
      offset: Offset(-1, -2),
      blurRadius: 4,
      blurStyle: BlurStyle.inner,
    ),
    BoxShadow(
      color: AppColors.shadowMidBlack,
      offset: Offset(2, 2),
      blurRadius: 4,
      blurStyle: BlurStyle.inner,
    ),
  ];

  static const List<BoxShadow> floatingButton = <BoxShadow>[
    BoxShadow(
      color: Color(0x80000000),
      offset: Offset(0, 0),
      blurRadius: 4,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> routeConnectorDot = <BoxShadow>[
    BoxShadow(
      color: AppColors.shadowRouteConnector,
      offset: Offset(0, 1),
      blurRadius: 2,
    ),
    BoxShadow(
      color: AppColors.shadowRouteConnector,
      offset: Offset(0, -1),
      blurRadius: 2,
    ),
  ];

  static const List<BoxShadow> routeConnectorLineInner = <BoxShadow>[
    BoxShadow(
      color: AppColors.shadowRouteConnector,
      offset: Offset(1, 0),
      blurRadius: 4,
    ),
  ];

  static const List<BoxShadow> routeConnectorLineOuter = <BoxShadow>[
    BoxShadow(
      color: AppColors.shadowMidBlack,
      offset: Offset(-1, 0),
      blurRadius: 4,
    ),
  ];

  static const List<BoxShadow> avatarBorderShadow = <BoxShadow>[
    BoxShadow(
      color: AppColors.reduceActionShadow,
      offset: Offset(0, 2),
      blurRadius: 2,
    ),
  ];

  static const List<BoxShadow> completeRideSuccessBadge = <BoxShadow>[
    BoxShadow(
      color: AppColors.shadowMidBlack,
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> modalCircularButtonInner = <BoxShadow>[
    BoxShadow(
      color: AppColors.modalButtonInnerShadow,
      blurRadius: 4,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: AppColors.modalButtonInnerShadow,
      blurRadius: 4,
      offset: Offset(4, 0),
    ),
    BoxShadow(
      color: AppColors.modalButtonInnerShadow,
      blurRadius: 4,
      offset: Offset(-4, 0),
    ),
  ];

  static const List<BoxShadow> volumeButton = <BoxShadow>[
    BoxShadow(
      color: AppColors.shadowSoftBlack,
      blurRadius: 2,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> volumeButtonInner = <BoxShadow>[
    BoxShadow(
      color: AppColors.accentAmberInnerShadow,
      blurRadius: 4,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: AppColors.accentAmberInnerShadow,
      blurRadius: 4,
      offset: Offset(0, -2),
    ),
  ];

  static const List<BoxShadow> volumeSliderTrack = <BoxShadow>[
    BoxShadow(
      color: AppColors.shadowLightBlack,
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> volumeSliderThumbInner = <BoxShadow>[
    BoxShadow(
      color: AppColors.shadowMidBlack,
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
    BoxShadow(
      color: AppColors.shadowMidBlack,
      blurRadius: 4,
      offset: Offset(0, -4),
    ),
    BoxShadow(
      color: AppColors.shadowMidBlack,
      blurRadius: 12,
      offset: Offset(4, 0),
    ),
  ];
}
