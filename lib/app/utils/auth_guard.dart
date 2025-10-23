import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:trekka/app/di/auth_state_providers.dart';
import 'package:trekka/app/state/auth_state.dart';
import 'package:trekka/features/auth/presentation/widgets/auth_sheet.dart';

class AuthGuard {
  AuthGuard(this._ref);

  final Ref _ref;

  Future<bool> ensureAuthenticated(BuildContext context) async {
    if (_ref.read(authStateProvider) is Authenticated) {
      return true;
    }

    await AuthSheet.show(context);

    return _ref.read(authStateProvider) is Authenticated;
  }

  Future<void> runAuthenticated(
    BuildContext context,
    FutureOr<void> Function() action,
  ) async {
    if (await ensureAuthenticated(context)) {
      await action();
    }
  }
}

final authGuardProvider = Provider<AuthGuard>((Ref ref) => AuthGuard(ref));
