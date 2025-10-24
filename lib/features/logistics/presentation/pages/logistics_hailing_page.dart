import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:trekka/core/design/tokens.dart';

class LogisticsHailingPage extends StatefulWidget {
  const LogisticsHailingPage({super.key});

  @override
  State<LogisticsHailingPage> createState() => _LogisticsHailingPageState();
}

class _LogisticsHailingPageState extends State<LogisticsHailingPage> {
  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(6.5298, 3.3893), // Lagos, NG
    zoom: 17,
  );

  final Set<Marker> _markers = <Marker>{
    const Marker(
      markerId: MarkerId('trekka-hq'),
      position: LatLng(6.4974, 3.3770),
      infoWindow: InfoWindow(
        title: 'Trekka Hub',
        snippet: 'Tap to request a courier pickup',
      ),
    ),
  };

  GoogleMapController? _mapController;

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
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
              initialCameraPosition: _initialCameraPosition,
              markers: _markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              zoomGesturesEnabled: true,
              scrollGesturesEnabled: true,
              tiltGesturesEnabled: true,
              rotateGesturesEnabled: true,
              trafficEnabled: true,
              mapType: MapType.normal,
              compassEnabled: true,
              mapToolbarEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
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
  const _LogisticsBackButton({
    required this.onPressed,
    required this.theme,
  });

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
