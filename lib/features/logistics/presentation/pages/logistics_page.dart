import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:trekka/core/assets/app_assets.dart';
import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/core/widgets/button/gradient_back_button.dart';
import 'package:trekka/core/widgets/button/icon_text_button.dart';
import 'package:trekka/features/logistics/domain/entities/logistics_stage.dart';
import 'package:trekka/features/logistics/presentation/providers/logistics_provider.dart';
import 'package:trekka/features/logistics/presentation/widgets/logistics_sheet_overlay.dart';
import 'package:trekka/core/widgets/sheet/gradient_overlay_modal.dart';
import 'package:trekka/features/logistics/utils/address_formatter.dart';
import 'package:trekka/features/logistics/presentation/viewmodels/logistics_state.dart';

class LogisticsPage extends ConsumerStatefulWidget {
  const LogisticsPage({super.key});

  @override
  ConsumerState<LogisticsPage> createState() => _LogisticsPageState();
}

class _LogisticsPageState extends ConsumerState<LogisticsPage>
    with SingleTickerProviderStateMixin {
  // static const double _initialZoom = 16.0; // Unused after optimization
  static const LatLng _fallbackCenter = LatLng(7.1897, 21.0937); // Africa
  static const double _fallbackZoom = 3.6;
  static const double _userZoom = 17.0;
  final CameraPosition _initialCameraPosition = const CameraPosition(
    target: _fallbackCenter,
    zoom: _fallbackZoom,
    tilt: 20,
  );

  GoogleMapController? _mapController;
  BitmapDescriptor? _riderIcon;
  // String? _darkMapStyle;
  // String? _lightMapStyle;
  // String? _mapStyle;
  LatLng? _userLocation;
  bool _isLocating = false;
  bool _showBottomSheet = false;
  bool _hasResolvedCurrentPosition = false;
  LogisticsStage _currentStage = LogisticsStage.initial;
  late final AnimationController _sheetAnimationController;
  late final Animation<Offset> _sheetSlideAnimation;
  static const List<LogisticsStage> _stageFlow = <LogisticsStage>[
    LogisticsStage.initial,
    LogisticsStage.enterDestination,
    LogisticsStage.confirmPickupLocation,
    LogisticsStage.enterPickupLocation,
    LogisticsStage.confirmRequest,
    LogisticsStage.lookingForDriver,
    LogisticsStage.waitingForDriver,
    LogisticsStage.driverArrived,
    LogisticsStage.inProgress,
    LogisticsStage.complete,
    LogisticsStage.review,
  ];

  @override
  void initState() {
    super.initState();
    _sheetAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _sheetSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _sheetAnimationController,
            curve: Curves.easeIn,
          ),
        );
    _loadMarkerIcon();
    // _loadMapStyles(); // Temporarily disabled for performance
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

  // Temporarily disabled for performance
  // Future<void> _loadMapStyles() async {
  //   try {
  //     final List<String> styles = await Future.wait<String>(<Future<String>>[
  //       rootBundle.loadString(AppAssetMapStyles.dark),
  //       rootBundle.loadString(AppAssetMapStyles.light),
  //     ]);

  //     if (!mounted) return;
  //     _darkMapStyle = styles[0];
  //     _lightMapStyle = styles[1];
  //     _updateMapStyle(forceNotify: true);
  //   } catch (error) {
  //     debugPrint('Failed to load map styles: $error');
  //   }
  // }

  Future<void> _primeWithLastKnownPosition() async {
    try {
      final Position? lastKnown = await Geolocator.getLastKnownPosition();
      if (!mounted || lastKnown == null || _hasResolvedCurrentPosition) return;

      final LatLng target = LatLng(lastKnown.latitude, lastKnown.longitude);
      bool didPrimeLocation = false;
      setState(() {
        if (!_hasResolvedCurrentPosition) {
          _userLocation = target;
          didPrimeLocation = true;
        }
      });

      if (!didPrimeLocation) return;

      ref.read(logisticsViewModelProvider.notifier).setUserLocation(target);

      if (_mapController != null) {
        await _mapController!.moveCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: target, zoom: _userZoom, tilt: 20),
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
        _hasResolvedCurrentPosition = true;
        _userLocation = target;
      });

      ref.read(logisticsViewModelProvider.notifier).setUserLocation(target);

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

  Set<Marker> _buildMarkers(LogisticsState logisticsState) {
    final LatLng? pickupLocation = logisticsState.userLocation ?? _userLocation;
    if (pickupLocation == null) {
      return <Marker>{};
    }

    return <Marker>{
      Marker(
        markerId: const MarkerId('user-location'),
        position: pickupLocation,
        icon: _riderIcon ?? BitmapDescriptor.defaultMarker,
        infoWindow: const InfoWindow(title: 'Pickup location'),
      ),
    };
  }

  // String _formatAddress(String? address, String fallback) {
  //   if (address == null || address.trim().isEmpty) {
  //     return fallback;
  //   }

  //   final parts = address.split(',');
  //   if (parts.length > 2) {
  //     return '${parts[0]}, ${parts[1].trim()}';
  //   }

  //   return address.trim();
  // }

  // bool _isDarkMode(BuildContext context) {
  //   final MediaQueryData? mediaQuery = MediaQuery.maybeOf(context);
  //   if (mediaQuery != null) {
  //     return mediaQuery.platformBrightness == Brightness.dark;
  //   }
  //   return Theme.of(context).brightness == Brightness.dark;
  // }

  // void _updateMapStyle({bool forceNotify = false}) {
  //   final bool isDark = _isDarkMode(context);
  //   final String? resolvedStyle = isDark ? _darkMapStyle : _lightMapStyle;
  //   if (!forceNotify && _mapStyle == resolvedStyle) return;
  //   setState(() {
  //     _mapStyle = resolvedStyle;
  //   });
  // }

  void _handleLocationButtonPressed() {
    if (_userLocation != null && _mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _userLocation!, zoom: _userZoom, tilt: 20),
        ),
      );
    }
  }

  void _handleNextStage() {
    setState(() {
      if (_currentStage == LogisticsStage.enterPickupLocation) {
        _currentStage = LogisticsStage.confirmPickupLocation;
        final pickupLocation = ref
            .read(logisticsViewModelProvider)
            .userLocation;
        if (_mapController != null && pickupLocation != null) {
          _mapController!.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(target: pickupLocation, zoom: _userZoom, tilt: 20),
            ),
          );
        }
        return;
      }

      if (_currentStage == LogisticsStage.confirmPickupLocation) {
        _currentStage = LogisticsStage.confirmRequest;
        return;
      }

      final int currentIndex = _stageFlow.indexOf(_currentStage);
      if (currentIndex == -1) {
        _currentStage = LogisticsStage.initial;
        return;
      }

      final bool isLastStage = currentIndex >= _stageFlow.length - 1;
      _currentStage = isLastStage
          ? LogisticsStage.initial
          : _stageFlow[currentIndex + 1];
    });
  }

  void _handleBackStage() {
    if (!_currentStage.canGoBack) return;

    setState(() {
      if (_currentStage == LogisticsStage.confirmPickupLocation) {
        _currentStage = LogisticsStage.initial;
        if (_mapController != null && _userLocation != null) {
          _mapController!.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(target: _userLocation!, zoom: _userZoom, tilt: 20),
            ),
          );
        }
        return;
      }

      if (_currentStage == LogisticsStage.enterPickupLocation) {
        _currentStage = LogisticsStage.confirmPickupLocation;
        return;
      }

      if (_currentStage == LogisticsStage.confirmRequest) {
        _currentStage = LogisticsStage.confirmPickupLocation;
        return;
      }

      final int currentIndex = _stageFlow.indexOf(_currentStage);
      if (currentIndex > 0) {
        _currentStage = _stageFlow[currentIndex - 1];
      }
    });
  }

  void _handleCancelRide() {
    setState(() {
      _currentStage = LogisticsStage.initial;
    });
    final origin = ref.read(logisticsViewModelProvider).userLocation;
    if (_mapController != null && origin != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: origin, zoom: _userZoom, tilt: 20),
        ),
      );
    }
    // TODO: Cancel any active ride requests
  }

  void _handleEditPickup() {
    setState(() {
      _currentStage = LogisticsStage.enterPickupLocation;
    });
    ref.read(logisticsViewModelProvider.notifier).clearPredictions();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   _updateMapStyle();
  // }

  @override
  Widget build(BuildContext context) {
    final logisticsState = ref.watch(logisticsViewModelProvider);
    final pickupSummary = AddressFormatter.formatWithFallback(
      logisticsState.userAddress,
      'Fetching pickup...',
    );
    final destinationSummary = AddressFormatter.formatWithFallback(
      logisticsState.destinationAddress,
      'Fetching destination...',
    );
    final bool shouldShowBackButton =
        _currentStage != LogisticsStage.enterDestination &&
        _currentStage != LogisticsStage.confirmPickupLocation &&
        _currentStage != LogisticsStage.enterPickupLocation;
    final bool shouldShowFloatingButton =
        _currentStage != LogisticsStage.confirmPickupLocation &&
        _currentStage != LogisticsStage.confirmRequest;

    return PopScope(
      canPop: _currentStage == LogisticsStage.initial,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (!didPop && _currentStage.canGoBack) {
          _handleBackStage();
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        child: Scaffold(
          backgroundColor: AppColors.midnightGreen,
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: <Widget>[
              GoogleMap(
                initialCameraPosition: _userLocation != null
                    ? CameraPosition(
                        target: _userLocation!,
                        zoom: _userZoom,
                        tilt: 20,
                      )
                    : _initialCameraPosition,
                markers: _buildMarkers(logisticsState),
                // style: _mapStyle, // Temporarily disabled for performance
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
              // Hide back button in enterDestination and confirmPickupLocation
              if (shouldShowBackButton)
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
              if (_currentStage == LogisticsStage.confirmPickupLocation)
                GradientOverlayModal(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconTextButton(
                        text: pickupSummary,
                        leadingIcon: AppAssetIcons.riderMarker,
                        onPressed: null,
                        textColor: AppColors.textPrimary,
                      ),
                      const SizedBox(height: AppSpacing.smLg),
                      IconTextButton(
                        text: destinationSummary,
                        leadingIcon: AppAssetIcons.destinationInfo,
                        trailingIcon: AppAssetIcons.stop,
                        onPressed: null,
                        textColor: AppColors.textPrimary,
                      ),
                    ],
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
                      stage: _currentStage,
                      onLocationPressed: _handleLocationButtonPressed,
                      onNext: _handleNextStage,
                      onBack: _handleBackStage,
                      onCancel: _handleCancelRide,
                      showFloatingButton: shouldShowFloatingButton,
                      onEditPickup: _handleEditPickup,
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
