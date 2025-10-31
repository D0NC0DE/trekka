import 'dart:async';

import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:trekka/features/logistics/data/models/ride_request_dto.dart';
import 'package:trekka/features/logistics/domain/entities/ride_request.dart';

typedef RideEventCallback = void Function(RideRequest ride);

/// Manages the logistics websocket connection and ride update subscriptions.
class LogisticsSocketService {
  LogisticsSocketService({required this.baseUrl});

  final String baseUrl;

  io.Socket? _socket;
  String? _currentToken;
  final Map<String, RideEventCallback> _rideListeners =
      <String, RideEventCallback>{};

  /// Ensure the socket is connected with the provided [token].
  Future<void> ensureConnected(String token) async {
    if (_socket != null &&
        _socket!.connected &&
        _currentToken != null &&
        _currentToken == token) {
      return;
    }

    if (_socket != null) {
      await _disposeSocket();
    }

    _currentToken = token;

    _socket = io.io(
      baseUrl,
      io.OptionBuilder()
          .setTransports(<String>['websocket'])
          .setAuth(<String, dynamic>{'token': token})
          .setExtraHeaders(<String, dynamic>{'Authorization': 'Bearer $token'})
          .enableReconnection()
          .setReconnectionAttempts(5)
          .disableAutoConnect()
          .build(),
    );

    _registerCoreListeners();
    _socket!.connect();
  }

  void _registerCoreListeners() {
    if (_socket == null) return;

    _socket!
      ..onConnect((_) {})
      ..onConnectError((dynamic error) {})
      ..onDisconnect((dynamic _) {})
      ..on('logistics:request:created', _handleRideEvent)
      ..on('logistics:request:updated', _handleRideEvent);
  }

  void _handleRideEvent(dynamic payload) {
    if (payload is! Map) return;

    final Map<String, dynamic> data = Map<String, dynamic>.from(payload);
    final String? rideId = data['id'] as String?;
    if (rideId == null) return;

    final RideEventCallback? listener = _rideListeners[rideId];
    if (listener == null) return;

    try {
      final RideRequest ride = RideRequestDto.fromJson(data).toEntity();
      listener(ride);
    } catch (_) {
      // Ignore malformed events.
    }
  }

  /// Start listening to ride updates for [rideId].
  void trackRide({required String rideId, required RideEventCallback onEvent}) {
    _rideListeners[rideId] = onEvent;
  }

  /// Stop listening for ride updates for [rideId].
  void untrackRide(String rideId) {
    _rideListeners.remove(rideId);
  }

  Future<void> _disposeSocket() async {
    if (_socket == null) return;

    _socket!
      ..off('logistics:request:created')
      ..off('logistics:request:updated');

    if (_socket!.connected) {
      final completer = Completer<void>();
      _socket!.once('disconnect', (_) => completer.complete());
      _socket!.disconnect();
      await completer.future.timeout(
        const Duration(milliseconds: 200),
        onTimeout: () {},
      );
    }

    _socket!.dispose();
    _socket = null;
    _currentToken = null;
  }

  /// Dispose the socket connection entirely.
  Future<void> dispose() async {
    await _disposeSocket();
    _rideListeners.clear();
  }
}
