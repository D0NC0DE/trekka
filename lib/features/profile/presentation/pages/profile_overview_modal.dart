import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:trekka/app/di/auth_state_providers.dart';
import 'package:trekka/app/state/auth_state.dart';
import 'package:trekka/features/profile/domain/entities/user.dart';
import 'package:trekka/features/profile/presentation/widgets/profile_authenticated_content.dart';
import 'package:trekka/features/profile/presentation/widgets/profile_loading_content.dart';
import 'package:trekka/features/profile/presentation/widgets/profile_unauthenticated_content.dart';
import 'package:trekka/features/wallets/domain/entities/wallet.dart';

/// Displays profile details inside the center modal.
class ProfileOverviewModal extends ConsumerWidget {
  const ProfileOverviewModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthState authState = ref.watch(authStateProvider);
    final authNotifier = ref.read(authStateProvider.notifier);

    return switch (authState) {
      Authenticated(
        :final User user,
        :final Wallet? wallet,
        :final bool isLoadingWallet,
      ) =>
        ProfileAuthenticatedContent(
          user: user,
          wallet: wallet,
          isWalletLoading: isLoadingWallet,
          onLogout: () => authNotifier.signOut(),
        ),
      AuthError(:final String message) => ProfileUnauthenticatedContent(
        errorMessage: message,
      ),
      AuthInitial() => const ProfileLoadingContent(),
      _ => const ProfileUnauthenticatedContent(),
    };
  }
}
