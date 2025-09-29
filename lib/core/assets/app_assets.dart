import 'package:flutter/foundation.dart';

@immutable
class AppAssetImages {
  const AppAssetImages._();

  static const String homeBackground = 'assets/images/home_bg.png';
  static const String splashBackground = 'assets/images/splash_bg.png';
}

@immutable
class AppAssetIcons {
  const AppAssetIcons._();

  // Trekka Icons
  static const String trekkaAnimated = 'assets/icons/trekka_ani.png';
  static const String trekkaLogo = 'assets/icons/trekka_logo.png';
  static const String trekkaSplash = 'assets/icons/trekka_splash.png';

  // Home Action Icons
  static const String pinpoint = 'assets/icons/pinpoint.png';
  
  static const String courierPin = 'assets/icons/courier.png';
  static const String hailingPin = 'assets/icons/hailing.png';
  static const String marketplacePin = 'assets/icons/marketplace.png';
  static const String questOnlinePin = 'assets/icons/quest_online.png';
  static const String questPhysicalPin = 'assets/icons/quest_phy.png';
  static const String recyclePin = 'assets/icons/recycle.png';

  // Home Tab Icons
  static const String homeTab = 'assets/icons/home_tab.png';
  static const String historyTab = 'assets/icons/history_tab.png';
  static const String profileTab = 'assets/icons/profile_tab.png';

  // Home App Bar Icons
  static const String trekkaPoint = 'assets/icons/trekka_point.png';
  static const String notification = 'assets/icons/notification.png';
}

@immutable
class AppAssetGifs {
  const AppAssetGifs._();

  static const String loader = 'assets/gifs/loader.gif';
}
