import 'package:flutter/foundation.dart';

@immutable
class AppAssetImages {
  const AppAssetImages._();

  static const String homeBackground = 'assets/images/home_bg.png';
  static const String splashBackground = 'assets/images/home_bg.png';
  static const String authSheetBackground = 'assets/images/auth_sheet_bg.png';
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
  
  static const String courierPin = 'assets/icons/pins/courier.png';
  static const String hailingPin = 'assets/icons/pins/hailing.png';
  static const String marketplacePin = 'assets/icons/pins/marketplace.png';
  static const String questOnlinePin = 'assets/icons/pins/quest_online.png';
  static const String questPhysicalPin = 'assets/icons/pins/quest_phy.png';
  static const String recyclePin = 'assets/icons/pins/recycle.png';

  // Home Tab Icons
  static const String homeTab = 'assets/icons/tabs/home.png';
  static const String historyTab = 'assets/icons/tabs/history.png';
  static const String profileTab = 'assets/icons/tabs/profile.png';

  // Home App Bar Icons
  static const String trekkaPoint = 'assets/icons/trekka_point.png';
  static const String notification = 'assets/icons/notification.png';

  // Social Icons
  static const String google = 'assets/icons/socials/google.png';
  static const String facebook = 'assets/icons/socials/facebook.png';
  static const String apple = 'assets/icons/socials/apple.png';
  static const String x = 'assets/icons/socials/x.png';
}

@immutable
class AppAssetGifs {
  const AppAssetGifs._();

  static const String loader = 'assets/gifs/loader.gif';
  static const String loading = 'assets/gifs/loading.gif';
}
