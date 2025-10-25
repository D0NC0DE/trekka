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
}
