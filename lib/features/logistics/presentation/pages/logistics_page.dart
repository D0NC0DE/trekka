import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:trekka/core/assets/app_assets.dart';
import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/core/widgets/button/gradient_back_button.dart';
import 'package:trekka/features/logistics/presentation/widgets/logistics_sheet_overlay.dart';

class LogisticsPage extends StatefulWidget {
  const LogisticsPage({super.key});

  @override
  State<LogisticsPage> createState() => _LogisticsPageState();
}

class _LogisticsPageState extends State<LogisticsPage>
    with SingleTickerProviderStateMixin {
  static const double _initialZoom = 14.0;
  static const LatLng _fallbackCenter = LatLng(7.1897, 21.0937); // Africa
  static const double _fallbackZoom = 3.6;
  static const double _userZoom = 17.0;
  final CameraPosition _initialCameraPosition = const CameraPosition(
    target: _fallbackCenter,
    zoom: _fallbackZoom,
    tilt: 180,
  );

  GoogleMapController? _mapController;
  BitmapDescriptor? _riderIcon;
  String? _darkMapStyle;
  String? _lightMapStyle;
  String? _mapStyle;
  LatLng? _userLocation;
  bool _isLocating = false;
  bool _showBottomSheet = false;
  late final AnimationController _sheetAnimationController;
  late final Animation<Offset> _sheetSlideAnimation;

  @override
  void initState() {
    super.initState();
    _sheetAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _sheetSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _sheetAnimationController,
      curve: Curves.easeIn,
    ));
    _loadMarkerIcon();
    _loadMapStyles();
    _primeWithLastKnownPosition();
    _resolveUserLocation();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _sheetAnimationController.dispose();
    super.dispose();
  }

  Future<void> _loadMarkerIcon() async {
    try {
      final BitmapDescriptor icon = await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(24, 24)),
        AppAssetIcons.riderMarker,
      );
      if (!mounted) return;
      setState(() => _riderIcon = icon);
    } catch (error) {
      debugPrint('Failed to load rider marker icon: $error');
    }
  }

  Future<void> _loadMapStyles() async {
    try {
      final List<String> styles = await Future.wait<String>(<Future<String>>[
        rootBundle.loadString(AppAssetMapStyles.dark),
        rootBundle.loadString(AppAssetMapStyles.light),
      ]);

      if (!mounted) return;
      _darkMapStyle = styles[0];
      _lightMapStyle = styles[1];
      _updateMapStyle(forceNotify: true);
    } catch (error) {
      debugPrint('Failed to load map styles: $error');
    }
  }

  Future<void> _primeWithLastKnownPosition() async {
    try {
      final Position? lastKnown = await Geolocator.getLastKnownPosition();
      if (!mounted || lastKnown == null) return;
      final LatLng target = LatLng(lastKnown.latitude, lastKnown.longitude);
      setState(() {
        _userLocation = target;
      });
      if (_mapController != null) {
        await _mapController!.moveCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: target, zoom: _initialZoom, tilt: 20),
          ),
        );
      }
    } catch (error) {
      debugPrint('No last known position: $error');
    }
  }

  Future<void> _resolveUserLocation() async {
    if (!mounted) return;
    setState(() => _isLocating = true);

    try {
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // _showInfo('Enable location services to center the map on you.');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever) {
          // _showInfo(
          //   'Location permission permanently denied. Update settings to enable.',
          // );
          return;
        }
        if (permission == LocationPermission.denied) {
          // _showInfo('Location permission denied. Showing default map.');
          return;
        }
      }

      late LocationSettings locationSettings;
      if (defaultTargetPlatform == TargetPlatform.android) {
        locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.bestForNavigation,
        );
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        locationSettings = AppleSettings(
          accuracy: LocationAccuracy.bestForNavigation,
          pauseLocationUpdatesAutomatically: true,
        );
      } else {
        locationSettings = const LocationSettings(
          accuracy: LocationAccuracy.bestForNavigation,
        );
      }

      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );

      if (!mounted) return;
      final LatLng target = LatLng(position.latitude, position.longitude);
      setState(() {
        _userLocation = target;
      });

      if (_mapController != null) {
        await _mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: target, zoom: _userZoom, tilt: 20),
          ),
        );
      }
    } catch (error) {
      // _showInfo('Unable to determine location.');
      debugPrint('Failed to resolve user location: $error');
    } finally {
      if (mounted) {
        setState(() => _isLocating = false);
      }
    }
  }

  Set<Marker> _buildMarkers() {
    if (_userLocation == null) return <Marker>{};

    return <Marker>{
      Marker(
        markerId: const MarkerId('user-location'),
        position: _userLocation!,
        icon: _riderIcon ?? BitmapDescriptor.defaultMarker,
        infoWindow: const InfoWindow(title: 'Your location'),
      ),
    };
  }

  bool _isDarkMode(BuildContext context) {
    final MediaQueryData? mediaQuery = MediaQuery.maybeOf(context);
    if (mediaQuery != null) {
      return mediaQuery.platformBrightness == Brightness.dark;
    }
    return Theme.of(context).brightness == Brightness.dark;
  }

  void _updateMapStyle({bool forceNotify = false}) {
    final bool isDark = _isDarkMode(context);
    final String? resolvedStyle = isDark ? _darkMapStyle : _lightMapStyle;
    if (!forceNotify && _mapStyle == resolvedStyle) return;
    setState(() {
      _mapStyle = resolvedStyle;
    });
  }

  void _handleLocationButtonPressed() {
    if (_userLocation != null && _mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _userLocation!,
            zoom: _userZoom,
            tilt: 20,
          ),
        ),
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateMapStyle();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.midnightGreen,
        body: Stack(
          children: <Widget>[
            GoogleMap(
              initialCameraPosition: _userLocation != null
                  ? CameraPosition(target: _userLocation!, zoom: _userZoom, tilt: 20)
                  : _initialCameraPosition,
              markers: _buildMarkers(),
              style: _mapStyle,
              myLocationEnabled: _userLocation != null,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              zoomGesturesEnabled: true,
              scrollGesturesEnabled: true,
              tiltGesturesEnabled: true,
              rotateGesturesEnabled: true,
              mapType: MapType.normal,
              compassEnabled: false,
              mapToolbarEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
                if (_userLocation != null) {
                  controller.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: _userLocation!,
                        zoom: _userZoom,
                        tilt: 20,
                      ),
                    ),
                  );
                }
                // Show bottom sheet when map is created
                if (!_showBottomSheet) {
                  setState(() => _showBottomSheet = true);
                  _sheetAnimationController.forward();
                }
              },
            ),
            if (_isLocating)
              SafeArea(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: AppSpacing.lg,
                      left: AppSpacing.lg,
                      right: AppSpacing.lg,
                    ),
                    // child: const _LocatingBanner(),
                  ),
                ),
              ),
            SafeArea(
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.sm,
                  ),
                  child: GradientBackButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                ),
              ),
            ),
            // Bottom sheet overlay with floating button
            if (_showBottomSheet)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SlideTransition(
                  position: _sheetSlideAnimation,
                  child: LogisticsSheetOverlay(
                    onLocationPressed: _handleLocationButtonPressed,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
