import 'package:flutter/foundation.dart';

@immutable
class AppAssetImages {
  const AppAssetImages._();

  static const String homeBackground = 'assets/images/home_bg.png';
  static const String splashBackground = 'assets/images/home_bg.png';

  static const String authSheetBackground = 'assets/images/auth_sheet_bg.png';

  // Avatar Images
  // static const String avatar = 'assets/images/avatars/avatar.jpg';
  static const String avatar1 = 'assets/images/avatars/avatar1.jpg';
  static const String avatar2 = 'assets/images/avatars/avatar2.png';
  static const String avatar3 = 'assets/images/avatars/avatar3.png';
  static const String avatar4 = 'assets/images/avatars/avatar4.png';
  static const String avatar5 = 'assets/images/avatars/avatar5.png';
  static const String avatar6 = 'assets/images/avatars/avatar6.png';
  static const String avatar7 = 'assets/images/avatars/avatar7.png';
  static const String avatar8 = 'assets/images/avatars/avatar8.png';
  static const String avatar9 = 'assets/images/avatars/avatar9.png';
  static const String avatar10 = 'assets/images/avatars/avatar10.png';

  /// Get avatar path by ID (1-10)
  static String getAvatarById(int id) {
    switch (id) {
      case 1:
        return avatar1;
      case 2:
        return avatar2;
      case 3:
        return avatar3;
      case 4:
        return avatar4;
      case 5:
        return avatar5;
      case 6:
        return avatar6;
      case 7:
        return avatar7;
      case 8:
        return avatar8;
      case 9:
        return avatar9;
      case 10:
        return avatar10;
      default:
        return avatar1; // Default to avatar 1
    }
  }
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

  // Map Markers
  static const String riderMarker = 'assets/icons/markers/user.png';
  static const String destinationMarker =
      'assets/icons/markers/destination.png';
  static const String nearbyDriversMarker = 'assets/icons/markers/drivers.png';

  // Action Icons
  static const String back = 'assets/icons/actions/back.png';
  static const String journey = 'assets/icons/actions/journey.png';
  static const String courier = 'assets/icons/actions/courier.png';
  static const String myLocation = 'assets/icons/actions/my_location.png';
  static const String search = 'assets/icons/actions/search.png';
  static const String searchWhite = 'assets/icons/actions/search_white.png';
  static const String close = 'assets/icons/actions/close.png';
  static const String selectOnMap = 'assets/icons/actions/on_map.png';
  static const String stop = 'assets/icons/actions/stop.png';
  static const String increase = 'assets/icons/actions/increase.png';
  static const String reduce = 'assets/icons/actions/reduce.png';
  static const String edit = 'assets/icons/actions/edit.png';
  static const String chat = 'assets/icons/actions/chat.png';
  static const String call = 'assets/icons/actions/call.png';
  static const String popDots = 'assets/icons/actions/pop_dots.png';
  static const String profile = 'assets/icons/actions/profile.png';

  // Profile Icons
  static const String user = 'assets/icons/profile/user.png';
  static const String signout = 'assets/icons/profile/signout.png';
  static const String settings = 'assets/icons/profile/settings.png';
  static const String forward = 'assets/icons/profile/forward.png';
  static const String editProfile = 'assets/icons/profile/edit.png';
  static const String volume = 'assets/icons/profile/volume.png';
  static const String music = 'assets/icons/profile/music.png';
  static const String delete = 'assets/icons/profile/delete.png';

  // Other Icons
  static const String destinationInfo = 'assets/icons/destination.png';
  static const String ride = 'assets/icons/ride.png';
  static const String seat = 'assets/icons/seat.png';
  static const String star = 'assets/icons/star.png';
  static const String success = 'assets/icons/success.png';
}

@immutable
class AppAssetGifs {
  const AppAssetGifs._();

  static const String loader = 'assets/gifs/loader.gif';
  static const String loading = 'assets/gifs/loading.gif';
}

@immutable
class AppAssetMapStyles {
  const AppAssetMapStyles._();

  static const String dark = 'assets/map_styles/dark.json';
  static const String light = 'assets/map_styles/light.json';
}
