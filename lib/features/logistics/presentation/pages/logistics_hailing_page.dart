import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:trekka/core/assets/app_assets.dart';
import 'package:trekka/core/design/tokens.dart';

class LogisticsHailingPage extends StatefulWidget {
  const LogisticsHailingPage({super.key});

  @override
  State<LogisticsHailingPage> createState() => _LogisticsHailingPageState();
}

class _LogisticsHailingPageState extends State<LogisticsHailingPage> {
  static const LatLng _hubLocation = LatLng(6.4974, 3.3770); // Lagos, NG
  static const CameraPosition _fallbackCameraPosition = CameraPosition(
    target: _hubLocation,
    zoom: 17,
  );
  static const InfoWindow _hubInfoWindow = InfoWindow(
    title: 'Trekka Hub',
    snippet: 'Tap to request a courier pickup',
  );

  GoogleMapController? _mapController;
  BitmapDescriptor? _riderIcon;
  String? _darkMapStyle;
  String? _lightMapStyle;
  String? _mapStyle;
  CameraPosition? _userCameraPosition;

  @override
  void initState() {
    super.initState();
    _loadMarkerIcon();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _loadMapStyles();
    });
    _resolveUserLocation();
  }

  @override
  void dispose() {
    _mapController?.dispose();
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

  Future<void> _resolveUserLocation() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }

      final LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
      );

      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );

      if (!mounted) return;
      final CameraPosition cameraPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 16,
      );

      setState(() {
        _userCameraPosition = cameraPosition;
      });

      if (_mapController != null) {
        await _mapController!.animateCamera(
          CameraUpdate.newCameraPosition(cameraPosition),
        );
      }
    } catch (error) {
      debugPrint('Failed to resolve user location: $error');
    }
  }

  Set<Marker> _buildMarkers() {
    return <Marker>{
      Marker(
        markerId: const MarkerId('trekka-hq'),
        position: _hubLocation,
        icon: _riderIcon ?? BitmapDescriptor.defaultMarker,
        infoWindow: _hubInfoWindow,
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateMapStyle();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

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
              initialCameraPosition:
                  _userCameraPosition ?? _fallbackCameraPosition,
              markers: _buildMarkers(),
              style: _mapStyle,
              myLocationEnabled: true,
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
                if (_userCameraPosition != null) {
                  controller.animateCamera(
                    CameraUpdate.newCameraPosition(_userCameraPosition!),
                  );
                }
              },
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: _LogisticsBackButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    theme: theme,
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

class _LogisticsBackButton extends StatelessWidget {
  const _LogisticsBackButton({required this.onPressed, required this.theme});

  final VoidCallback onPressed;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.overlayBlurBlack,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: IconButton(
        icon: Icon(
          Icons.chevron_left_rounded,
          color: AppColors.white,
          size: theme.iconTheme.size ?? 28,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
